<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Controller.Khachhang" %>
<%@ page import="Controller.KhachhangDAO" %>
<%
    if (session.getAttribute("khachhang") != null) {
        response.sendRedirect("Trangchu.jsp");
        return;
    }
    String loi = "";
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String tentaikhoan = request.getParameter("tentaikhoan");
        String tendangnhap = request.getParameter("tendangnhap");
        String gmail = request.getParameter("gmail");
        String sodt = request.getParameter("sodt");
        String diachi = request.getParameter("diachi");
        String matkhau = request.getParameter("matkhau");
        String matkhau2 = request.getParameter("matkhau2");

        if (matkhau == null || matkhau2 == null || !matkhau.equals(matkhau2)) {
            loi = "Mật khẩu xác nhận không khớp.";
        } else if (tendangnhap == null || tendangnhap.trim().isEmpty()) {
            loi = "Vui lòng nhập tên đăng nhập.";
        } else {
            Khachhang k = new Khachhang();
            k.setTentaikhoan(tentaikhoan != null ? tentaikhoan.trim() : "");
            k.setTendangnhap(tendangnhap.trim());
            k.setGmail(gmail != null ? gmail.trim() : "");
            k.setSodt(sodt != null ? sodt.trim() : "");
            k.setDiachi(diachi != null ? diachi.trim() : "");
            k.setMatkhau(matkhau);

            KhachhangDAO dao = new KhachhangDAO();
            int r = dao.dangKy(k);
            if (r == 1) {
                response.sendRedirect("Dangnhap.jsp?registered=1");
                return;
            } else if (r == 0) {
                loi = "Tên đăng nhập đã được sử dụng.";
            } else {
                loi = "Không thể đăng ký. Kiểm tra kết nối CSDL hoặc chạy lại file Sql/qlbanhang.sql.";
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký - MemoryZone</title>
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
                <div class="search-hints">bàn phím keychron · MSI Cyborg 15 · ASUS OLED · PC Gaming · USB</div>
            </form>

            <div class="header-actions">
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
                <a class="cart-button" href="Giohang.jsp">
                    <span class="cart-count">0</span>
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

    <div class="page-outer">
        <aside class="skin-ad skin-ad--left" aria-hidden="true">
            <div class="skin-ad-inner">
                ƯU ĐÃI HOT
                <span>PC Gaming · Linh kiện</span>
            </div>
        </aside>

        <div class="site-shell login-page-wrap">
            <div class="login-page-inner">
                <nav class="login-breadcrumb" aria-label="Breadcrumb">
                    <a href="Trangchu.jsp">Trang chủ</a><span>/</span>Đăng ký tài khoản
                </nav>

                <h1 class="login-page-title">ĐĂNG KÝ TÀI KHOẢN</h1>
                <p class="login-page-sub">Bạn đã có tài khoản? <a href="Dangnhap.jsp">Đăng nhập tại đây</a></p>

                <div class="login-card-wide">
                    <% if (!loi.isEmpty()) { %>
                    <div class="auth-msg auth-msg--err"><%= loi %></div>
                    <% } %>

                    <form class="auth-form" method="post" action="Dangky.jsp" autocomplete="on">
                        <label for="tentaikhoan">Họ tên *</label>
                        <input id="tentaikhoan" name="tentaikhoan" type="text" required maxlength="255" value="<%= request.getParameter("tentaikhoan") != null ? request.getParameter("tentaikhoan") : "" %>">

                        <label for="tendangnhap">Tên đăng nhập *</label>
                        <input id="tendangnhap" name="tendangnhap" type="text" required maxlength="50" value="<%= request.getParameter("tendangnhap") != null ? request.getParameter("tendangnhap") : "" %>">

                        <label for="gmail">Email *</label>
                        <input id="gmail" name="gmail" type="email" required maxlength="100" value="<%= request.getParameter("gmail") != null ? request.getParameter("gmail") : "" %>">

                        <label for="sodt">Số điện thoại *</label>
                        <input id="sodt" name="sodt" type="text" required maxlength="20" value="<%= request.getParameter("sodt") != null ? request.getParameter("sodt") : "" %>">

                        <label for="diachi">Địa chỉ</label>
                        <input id="diachi" name="diachi" type="text" maxlength="500" value="<%= request.getParameter("diachi") != null ? request.getParameter("diachi") : "" %>">

                        <label for="matkhau">Mật khẩu *</label>
                        <input id="matkhau" name="matkhau" type="password" required maxlength="255">

                        <label for="matkhau2">Xác nhận mật khẩu *</label>
                        <input id="matkhau2" name="matkhau2" type="password" required maxlength="255">

                        <div class="auth-actions">
                            <button type="submit" class="login-submit-yellow">Đăng ký</button>
                        </div>
                    </form>
                </div>
            </div>

            <div class="trust-bar">
                <div><strong>Giao hàng Siêu Tốc</strong>2–4H nội thành</div>
                <div><strong>7 ngày đổi trả</strong>Theo chính sách</div>
                <div><strong>100% chính hãng</strong>Cam kết sản phẩm</div>
                <div><strong>Thanh toán dễ dàng</strong>Tiền mặt, chuyển khoản</div>
            </div>

            <footer class="footer">
                <p>Bản quyền © 2026 — MemoryZone</p>
                <p>Thực hiện: Hoang Quoc Dai</p>
            </footer>
        </div>

        <aside class="skin-ad skin-ad--right" aria-hidden="true">
            <div class="skin-ad-inner">
                FLASH SALE
                <span>SSD · RAM · VGA</span>
            </div>
        </aside>
    </div>

    <button type="button" class="chat-fab" aria-label="Chat hỗ trợ" title="Chat" data-chat-link="Lienhe.jsp">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
            <path d="M21 12a8 8 0 01-8 8H8l-5 3 2-4a8 8 0 118-7z"/>
        </svg>
    </button>

    <script>
        (function () {
            var chatButton = document.querySelector('.chat-fab');
            if (chatButton) {
                chatButton.addEventListener('click', function () {
                    window.location.href = chatButton.getAttribute('data-chat-link') || 'Lienhe.jsp';
                });
            }
        })();
    </script>
</body>
</html>
