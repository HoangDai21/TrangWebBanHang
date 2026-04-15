<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Controller.Khachhang" %>
<%@ page import="Controller.Ketnoicsdl" %>
<%@ page import="Controller.Sanpham" %>
<%@ page import="Controller.SanphamDAO" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.LinkedHashMap" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%
    request.setCharacterEncoding("UTF-8");
%>
<%! 
    private int toInt(String raw, int fallback) {
        try {
            return Integer.parseInt(raw);
        } catch (Exception ex) {
            return fallback;
        }
    }
%>
<%
    Khachhang khDangNhap = (Khachhang) session.getAttribute("khachhang");
    String tenTaiKhoanHienThi = "";
    if (khDangNhap != null) {
        tenTaiKhoanHienThi = khDangNhap.getTentaikhoan();
        if (tenTaiKhoanHienThi == null || tenTaiKhoanHienThi.trim().isEmpty()) {
            tenTaiKhoanHienThi = khDangNhap.getTendangnhap() != null ? khDangNhap.getTendangnhap() : "";
        }
    }

    Object rawCart = session.getAttribute("cart");
    LinkedHashMap<Integer, Integer> cart;
    if (rawCart instanceof LinkedHashMap) {
        cart = (LinkedHashMap<Integer, Integer>) rawCart;
    } else {
        cart = new LinkedHashMap<Integer, Integer>();
        session.setAttribute("cart", cart);
    }

    String action = request.getParameter("action");
    if ("add".equals(action)) {
        int id = toInt(request.getParameter("id"), -1);
        int qty = toInt(request.getParameter("qty"), 1);
        if (id > 0) {
            if (qty < 1) {
                qty = 1;
            }
            int oldQty = cart.containsKey(id) ? cart.get(id) : 0;
            cart.put(id, oldQty + qty);
            session.setAttribute("cart", cart);
        }
        response.sendRedirect("Giohang.jsp?added=1");
        return;
    }

    if ("remove".equals(action)) {
        int id = toInt(request.getParameter("id"), -1);
        if (id > 0) {
            cart.remove(id);
            session.setAttribute("cart", cart);
        }
        response.sendRedirect("Giohang.jsp?removed=1");
        return;
    }

    if ("clear".equals(action)) {
        cart.clear();
        session.setAttribute("cart", cart);
        response.sendRedirect("Giohang.jsp?cleared=1");
        return;
    }

    if ("update".equals(action) && "POST".equalsIgnoreCase(request.getMethod())) {
        List<Integer> ids = new ArrayList<Integer>(cart.keySet());
        for (Integer id : ids) {
            String qtyRaw = request.getParameter("qty_" + id);
            int qty = toInt(qtyRaw, cart.get(id));
            if (qty <= 0) {
                cart.remove(id);
            } else if (qty > 99) {
                cart.put(id, 99);
            } else {
                cart.put(id, qty);
            }
        }
        session.setAttribute("cart", cart);
        response.sendRedirect("Giohang.jsp?updated=1");
        return;
    }

    SanphamDAO dao = new SanphamDAO();
    List<Sanpham> allProducts = dao.layTatCaSanpham();
    Map<Integer, Sanpham> productMap = new LinkedHashMap<Integer, Sanpham>();
    if (allProducts != null) {
        for (Sanpham sp : allProducts) {
            productMap.put(sp.getMasp(), sp);
        }
    }

    class CartLine {
        public Sanpham product;
        public int qty;
        public double lineTotal;
    }

    List<CartLine> lines = new ArrayList<CartLine>();
    int totalQty = 0;
    double totalMoney = 0;
    for (Map.Entry<Integer, Integer> e : cart.entrySet()) {
        Sanpham p = productMap.get(e.getKey());
        if (p == null) {
            continue;
        }
        int q = e.getValue() == null ? 1 : e.getValue();
        if (q < 1) {
            q = 1;
        }
        CartLine line = new CartLine();
        line.product = p;
        line.qty = q;
        line.lineTotal = p.getGia() * q;
        lines.add(line);
        totalQty += q;
        totalMoney += line.lineTotal;
    }

    DecimalFormat moneyFmt = new DecimalFormat("#,###");
    String msg = "";
    String err = "";
    String paymentCode = "";
    String paymentMethodDone = "";

    if ("checkout".equals(action) && "POST".equalsIgnoreCase(request.getMethod())) {
        String hoten = request.getParameter("hoten");
        String sodt = request.getParameter("sodt");
        String diachi = request.getParameter("diachi");
        String paymentMethod = request.getParameter("paymentMethod");
        if (hoten == null || hoten.trim().isEmpty() || sodt == null || sodt.trim().isEmpty() || diachi == null || diachi.trim().isEmpty()) {
            err = "Vui lòng nhập đầy đủ họ tên, số điện thoại và địa chỉ nhận hàng.";
        } else if (lines.isEmpty()) {
            err = "Giỏ hàng đang trống, không thể thanh toán.";
        } else {
            String madon = "DH" + System.currentTimeMillis();
            String summary = "Đơn " + lines.size() + " sản phẩm - " + hoten.trim();
            if (summary.length() > 250) {
                summary = summary.substring(0, 250);
            }
            Connection conn = null;
            PreparedStatement psDon = null;
            PreparedStatement psCt = null;
            PreparedStatement psUpdateStock = null;
            try {
                conn = Ketnoicsdl.ketnoi();
                if (conn == null) {
                    err = "Không thể kết nối CSDL để lưu đơn hàng.";
                } else {
                    conn.setAutoCommit(false);
                    psDon = conn.prepareStatement("INSERT INTO tt_donhang(madon, soluong, thanhtien, sanpham) VALUES(?,?,?,?)");
                    psDon.setString(1, madon);
                    psDon.setInt(2, totalQty);
                    psDon.setDouble(3, totalMoney);
                    psDon.setString(4, summary);
                    psDon.executeUpdate();

                    psCt = conn.prepareStatement("INSERT INTO chitietdonhang(madonhang, sanpham, soluong, thanhtien) VALUES(?,?,?,?)");
                    psUpdateStock = conn.prepareStatement("UPDATE tt_sanpham SET soluong = CASE WHEN soluong > 0 THEN soluong - 1 ELSE 0 END WHERE masp = ?");
                    for (CartLine line : lines) {
                        psCt.setString(1, madon);
                        psCt.setString(2, line.product.getTensp());
                        psCt.setInt(3, line.qty);
                        psCt.setDouble(4, line.lineTotal);
                        psCt.addBatch();

                        psUpdateStock.setInt(1, line.product.getMasp());
                        psUpdateStock.addBatch();
                    }
                    psCt.executeBatch();
                    psUpdateStock.executeBatch();
                    conn.commit();

                    cart.clear();
                    session.setAttribute("cart", cart);
                    lines.clear();
                    totalQty = 0;
                    totalMoney = 0;
                    paymentMethodDone = "online".equals(paymentMethod) ? "ONLINE" : "COD";
                    if ("online".equals(paymentMethod)) {
                        paymentCode = "PAY" + (System.currentTimeMillis() % 100000000);
                        msg = "Đặt hàng thành công. Đơn hàng: " + madon + ". Mã thanh toán online: " + paymentCode + ".";
                    } else {
                        msg = "Đặt hàng COD thành công. Đơn hàng: " + madon + ". Nhân viên sẽ gọi xác nhận sớm.";
                    }
                }
            } catch (Exception ex) {
                err = "Lưu đơn hàng thất bại: " + ex.getMessage();
                try {
                    if (conn != null) {
                        conn.rollback();
                    }
                } catch (SQLException ignore) {
                }
            } finally {
                try { if (psUpdateStock != null) psUpdateStock.close(); } catch (SQLException ignore) {}
                try { if (psCt != null) psCt.close(); } catch (SQLException ignore) {}
                try { if (psDon != null) psDon.close(); } catch (SQLException ignore) {}
                try { if (conn != null) conn.close(); } catch (SQLException ignore) {}
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ hàng - MemoryZone</title>
    <link rel="stylesheet" type="text/css" href="Css/style.css">
</head>
<body>
    <div class="sticky-top">
        <header class="top-header">
            <a href="Trangchu.jsp" class="brand-block">
                <div class="brand-mark" aria-hidden="true">
                    <svg viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <rect x="2" y="6" width="28" height="20" rx="3" stroke="#ffd44d" stroke-width="2"/>
                        <path d="M8 14h16M8 18h10" stroke="#ffd44d" stroke-width="2" stroke-linecap="round"/>
                    </svg>
                </div>
                <div class="brand-text">
                    <div class="brand-name"><span class="mem">Memory</span><span class="zone">Zone</span></div>
                    <div class="brand-tag">BY SIÊU TỐC</div>
                </div>
            </a>

            <form class="search-block" action="category.jsp" method="get">
                <input type="search" name="q" placeholder="Bạn cần tìm gì?" autocomplete="off">
                <button type="submit" aria-label="Tìm kiếm">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                        <circle cx="11" cy="11" r="7"/>
                        <path d="M20 20l-4.3-4.3"/>
                    </svg>
                </button>
                <div class="search-hints">SSD · RAM · Bàn phím · Chuột · Linh kiện</div>
            </form>

            <div class="header-actions">
                <% if (khDangNhap != null) { %>
                <div class="header-user">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" aria-hidden="true">
                        <circle cx="12" cy="8" r="4"/>
                        <path d="M4 20c0-4 3.5-6 8-6s8 2 8 6"/>
                    </svg>
                    <span>
                        <strong class="header-user-name"><%= tenTaiKhoanHienThi %></strong>
                        <small class="header-user-meta"><a href="Dangxuat.jsp">Đăng xuất</a></small>
                    </span>
                </div>
                <% } else { %>
                <a class="action-link" href="Dangnhap.jsp">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                        <circle cx="12" cy="8" r="4"/>
                        <path d="M4 20c0-4 3.5-6 8-6s8 2 8 6"/>
                    </svg>
                    <span>
                        <strong>Tài khoản</strong>
                        <small>Đăng nhập</small>
                    </span>
                </a>
                <% } %>
                <a class="cart-button" href="Giohang.jsp">
                    <span class="cart-count"><%= totalQty %></span>
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                        <path d="M6 6h15l-1.5 9h-12z"/>
                        <circle cx="9" cy="20" r="1.5"/>
                        <circle cx="18" cy="20" r="1.5"/>
                        <path d="M6 6L5 3H2"/>
                    </svg>
                    <span>Giỏ hàng</span>
                </a>
            </div>
        </header>

        <nav class="main-nav main-nav--with-cat">
            <a class="main-nav-cat" href="Trangchu.jsp"><span class="main-nav-cat-icon" aria-hidden="true">☰</span> DANH MỤC SẢN PHẨM</a>
            <div class="main-nav-links">
                <a href="Giohang.jsp">THANH TOÁN</a>
                <a href="Lienhe.jsp#tragop">TRẢ GÓP</a>
                <a href="Lienhe.jsp#hethong">HỆ THỐNG CỬA HÀNG</a>
                <a href="Lienhe.jsp">HỖ TRỢ KHÁCH HÀNG</a>
                <a href="Trangchu.jsp#tin-tuc">TIN TỨC</a>
                <a href="Lienhe.jsp#tuyendung">TUYỂN DỤNG</a>
            </div>
        </nav>
    </div>

    <div class="site-shell">
        <main class="page-layout" style="grid-template-columns: 1fr;">
            <section class="product-section">
                <div class="section-title-row">
                    <h2>GIỎ HÀNG CỦA BẠN</h2>
                    <span><span id="cartTotalQty"><%= totalQty %></span> sản phẩm</span>
                </div>

                <% if (request.getParameter("added") != null) { %>
                <div class="auth-msg auth-msg--ok">Đã thêm sản phẩm vào giỏ hàng.</div>
                <% } %>
                <% if (request.getParameter("updated") != null) { %>
                <div class="auth-msg auth-msg--ok">Đã cập nhật số lượng.</div>
                <% } %>
                <% if (request.getParameter("removed") != null) { %>
                <div class="auth-msg auth-msg--ok">Đã xóa sản phẩm khỏi giỏ hàng.</div>
                <% } %>
                <% if (request.getParameter("cleared") != null) { %>
                <div class="auth-msg auth-msg--ok">Đã xóa toàn bộ giỏ hàng.</div>
                <% } %>
                <% if (!msg.isEmpty()) { %>
                <div class="auth-msg auth-msg--ok"><%= msg %></div>
                <% } %>
                <% if (!err.isEmpty()) { %>
                <div class="auth-msg auth-msg--err"><%= err %></div>
                <% } %>

                <% if (!lines.isEmpty()) { %>
                <form method="post" action="Giohang.jsp?action=update" id="cartForm">
                    <table class="cart-table">
                        <thead>
                            <tr>
                                <th>Sản phẩm</th>
                                <th>Đơn giá</th>
                                <th>Số lượng</th>
                                <th>Thành tiền</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (CartLine line : lines) { %>
                            <tr class="cart-row" data-price="<%= line.product.getGia() %>">
                                <td>
                                    <div class="cart-product">
                                        <div class="cart-thumb">
                                            <% if (line.product.getHinhanh() != null && !line.product.getHinhanh().trim().isEmpty()) { %>
                                            <img src="<%= line.product.getHinhanh() %>" alt="<%= line.product.getTensp() %>">
                                            <% } else { %>
                                            <span>No image</span>
                                            <% } %>
                                        </div>
                                        <div>
                                            <div class="cart-product-name"><%= line.product.getTensp() %></div>
                                            <div class="cart-product-meta">Mã: <%= line.product.getMasp() %></div>
                                        </div>
                                    </div>
                                </td>
                                <td><%= moneyFmt.format(line.product.getGia()).replace(',', '.') %> VNĐ</td>
                                <td>
                                    <input class="cart-qty" type="number" min="1" max="99" name="qty_<%= line.product.getMasp() %>" value="<%= line.qty %>" inputmode="numeric">
                                </td>
                                <td class="cart-line-total"><span class="cart-line-total-value"><%= moneyFmt.format(line.lineTotal).replace(',', '.') %></span> VNĐ</td>
                                <td>
                                    <a class="cart-remove" href="Giohang.jsp?action=remove&id=<%= line.product.getMasp() %>">Xóa</a>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                    <div class="cart-actions-row">
                        <button type="submit" class="hero-secondary cart-btn-ghost">Cập nhật giỏ hàng</button>
                        <a href="Giohang.jsp?action=clear" class="hero-secondary cart-btn-ghost">Xóa toàn bộ</a>
                    </div>
                </form>

                <div class="checkout-layout">
                    <section class="checkout-form-card">
                        <h3>Thông tin nhận hàng</h3>
                        <form method="post" action="Giohang.jsp?action=checkout" class="auth-form">
                            <label for="hoten">Họ và tên *</label>
                            <input id="hoten" name="hoten" type="text" required maxlength="255" value="<%= khDangNhap != null ? khDangNhap.getTentaikhoan() : "" %>">

                            <label for="sodt">Số điện thoại *</label>
                            <input id="sodt" name="sodt" type="text" required maxlength="20" value="<%= khDangNhap != null ? khDangNhap.getSodt() : "" %>">

                            <label for="diachi">Địa chỉ nhận hàng *</label>
                            <input id="diachi" name="diachi" type="text" required maxlength="500" value="<%= khDangNhap != null ? khDangNhap.getDiachi() : "" %>">

                            <label for="ghichu">Ghi chú</label>
                            <input id="ghichu" name="ghichu" type="text" maxlength="500" placeholder="Ví dụ: Giao giờ hành chính">

                            <div class="payment-methods">
                                <label class="payment-option">
                                    <input type="radio" name="paymentMethod" value="cod" checked>
                                    <span>Thanh toán khi nhận hàng (COD)</span>
                                </label>
                                <label class="payment-option">
                                    <input type="radio" name="paymentMethod" value="online">
                                    <span>Thanh toán online (Momo/Banking)</span>
                                </label>
                            </div>

                            <div id="onlineHint" class="payment-online-hint">
                                Thanh toán online dạng mô phỏng: sau khi đặt đơn sẽ sinh mã thanh toán để đối soát.
                            </div>

                            <div class="auth-actions">
                                <button type="submit">Đặt hàng</button>
                            </div>
                        </form>
                    </section>

                    <aside class="checkout-summary-card">
                        <h3>Tóm tắt đơn hàng</h3>
                        <div class="summary-row"><span>Tạm tính</span><strong><span id="cartSubtotal"><%= moneyFmt.format(totalMoney).replace(',', '.') %></span> VNĐ</strong></div>
                        <div class="summary-row"><span>Phí vận chuyển</span><strong>0 VNĐ</strong></div>
                        <div class="summary-row total"><span>Tổng cộng</span><strong><span id="cartGrandTotal"><%= moneyFmt.format(totalMoney).replace(',', '.') %></span> VNĐ</strong></div>
                        <% if ("ONLINE".equals(paymentMethodDone) && !paymentCode.isEmpty()) { %>
                        <div class="payment-code-box">
                            <div>Mã thanh toán online</div>
                            <strong><%= paymentCode %></strong>
                        </div>
                        <% } %>
                    </aside>
                </div>
                <% } else { %>
                <div class="empty-state">Giỏ hàng đang trống. Hãy chọn sản phẩm và bấm "Mua ngay".</div>
                <p style="margin-top: 12px;">
                    <a class="detail-link" href="Trangchu.jsp">Tiếp tục mua sắm</a>
                </p>
                <% } %>
            </section>
        </main>
    </div>

    <script>
        (function () {
            // Auto update totals when quantity changes (client-side)
            var cartForm = document.getElementById('cartForm');
            if (cartForm) {
                var qtyInputs = cartForm.querySelectorAll('input.cart-qty');
                var nf = (window.Intl && Intl.NumberFormat) ? new Intl.NumberFormat('vi-VN') : null;

                function fmtMoney(n) {
                    var v = Math.round((Number(n) || 0));
                    return nf ? nf.format(v) : String(v);
                }

                function clampQty(raw) {
                    var q = parseInt(raw, 10);
                    if (isNaN(q)) q = 1;
                    if (q < 1) q = 1;
                    if (q > 99) q = 99;
                    return q;
                }

                function recalc() {
                    var rows = cartForm.querySelectorAll('tr.cart-row');
                    var totalQty = 0;
                    var totalMoney = 0;
                    for (var i = 0; i < rows.length; i++) {
                        var row = rows[i];
                        var price = parseFloat(row.getAttribute('data-price') || '0');
                        if (isNaN(price)) price = 0;
                        var input = row.querySelector('input.cart-qty');
                        if (!input) continue;
                        var qty = clampQty(input.value);
                        // normalize display value
                        if (String(input.value) !== String(qty)) input.value = qty;
                        var lineTotal = price * qty;
                        totalQty += qty;
                        totalMoney += lineTotal;
                        var lineEl = row.querySelector('.cart-line-total-value');
                        if (lineEl) lineEl.textContent = fmtMoney(lineTotal);
                    }

                    var qtyEl = document.getElementById('cartTotalQty');
                    if (qtyEl) qtyEl.textContent = String(totalQty);

                    // update header cart count too
                    var headerCount = document.querySelector('.cart-button .cart-count');
                    if (headerCount) headerCount.textContent = String(totalQty);

                    var subEl = document.getElementById('cartSubtotal');
                    if (subEl) subEl.textContent = fmtMoney(totalMoney);
                    var grandEl = document.getElementById('cartGrandTotal');
                    if (grandEl) grandEl.textContent = fmtMoney(totalMoney);
                }

                function onQtyChange(e) {
                    var t = e && e.target;
                    if (!t || !t.classList || !t.classList.contains('cart-qty')) return;
                    recalc();
                }

                for (var i = 0; i < qtyInputs.length; i++) {
                    qtyInputs[i].addEventListener('input', onQtyChange);
                    qtyInputs[i].addEventListener('change', onQtyChange);
                }
                recalc();
            }

            var radios = document.querySelectorAll('input[name="paymentMethod"]');
            var hint = document.getElementById('onlineHint');
            function updateHint() {
                if (!hint) return;
                var online = false;
                for (var i = 0; i < radios.length; i++) {
                    if (radios[i].checked && radios[i].value === 'online') {
                        online = true;
                    }
                }
                hint.style.display = online ? 'block' : 'none';
            }
            for (var i = 0; i < radios.length; i++) {
                radios[i].addEventListener('change', updateHint);
            }
            updateHint();
        })();
    </script>
</body>
</html>