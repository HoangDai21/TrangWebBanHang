<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Controller.Sanpham" %>
<%@ page import="Controller.SanphamDAO" %>
<%@ page import="Controller.Khachhang" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.util.List" %>
<%
    Khachhang khDangNhap = (Khachhang) session.getAttribute("khachhang");
    String tenTaiKhoanHienThi = "";
    if (khDangNhap != null) {
        tenTaiKhoanHienThi = khDangNhap.getTentaikhoan();
        if (tenTaiKhoanHienThi == null || tenTaiKhoanHienThi.trim().isEmpty()) {
            tenTaiKhoanHienThi = khDangNhap.getTendangnhap() != null ? khDangNhap.getTendangnhap() : "";
        }
    }
%>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MemoryZone - Thiết bị lưu trữ & linh kiện máy tính</title>
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

        <div class="site-shell">
            <main class="page-layout">
                <aside class="sidebar-panel">
                    <h3>DANH MỤC THIẾT BỊ</h3>
                    <ul class="category-list">
                        <li>
                            <a href="category.jsp?type=keyboard">
                                <span class="cat-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><rect x="3" y="10" width="18" height="8" rx="1"/><path d="M7 14h2M11 14h2M15 14h2"/></svg></span>
                                <span class="cat-label">Chuột - Bàn phím - Tai nghe</span>
                                <span class="cat-chevron">›</span>
                            </a>
                        </li>
                        <li>
                            <a href="category.jsp?type=laptop">
                                <span class="cat-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><rect x="4" y="5" width="16" height="11" rx="1"/><path d="M2 18h20"/></svg></span>
                                <span class="cat-label">Laptop</span>
                                <span class="cat-chevron">›</span>
                            </a>
                        </li>
                        <li>
                            <a href="category.jsp?type=pc">
                                <span class="cat-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><rect x="5" y="3" width="14" height="12" rx="1"/><path d="M8 21h8M12 15v6"/></svg></span>
                                <span class="cat-label">PC / Máy bộ</span>
                                <span class="cat-chevron">›</span>
                            </a>
                        </li>
                        <li>
                            <a href="category.jsp?type=build">
                                <span class="cat-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><path d="M12 2l2 4h4l-3 3 1 4-4-2-4 2 1-4-3-3h4z"/></svg></span>
                                <span class="cat-label">PC tự build</span>
                                <span class="cat-chevron">›</span>
                            </a>
                        </li>
                        <li>
                            <a href="category.jsp?type=parts">
                                <span class="cat-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><rect x="4" y="8" width="16" height="10" rx="1"/><path d="M8 8V6M16 8V6"/></svg></span>
                                <span class="cat-label">Linh kiện PC / Laptop</span>
                                <span class="cat-chevron">›</span>
                            </a>
                        </li>
                        <li>
                            <a href="category.jsp?type=monitor">
                                <span class="cat-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><rect x="3" y="4" width="18" height="13" rx="1"/><path d="M8 21h8M12 17v4"/></svg></span>
                                <span class="cat-label">Màn hình - Loa</span>
                                <span class="cat-chevron">›</span>
                            </a>
                        </li>
                        <li>
                            <a href="category.jsp?type=lifestyle">
                                <span class="cat-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><circle cx="12" cy="12" r="3"/><path d="M12 2v2M12 20v2M2 12h2M20 12h2"/></svg></span>
                                <span class="cat-label">Livestream setup</span>
                                <span class="cat-chevron">›</span>
                            </a>
                        </li>
                        <li>
                            <a href="category.jsp?type=ssd">
                                <span class="cat-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><rect x="4" y="7" width="16" height="10" rx="1"/><path d="M8 17v3M16 17v3"/></svg></span>
                                <span class="cat-label">SSD gắn trong</span>
                                <span class="cat-chevron">›</span>
                            </a>
                        </li>
                        <li>
                            <a href="category.jsp?type=ram">
                                <span class="cat-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><rect x="5" y="8" width="14" height="8" rx="1"/><path d="M8 8V6M16 8V6"/></svg></span>
                                <span class="cat-label">RAM Laptop, PC</span>
                                <span class="cat-chevron">›</span>
                            </a>
                        </li>
                        <li>
                            <a href="category.jsp?type=memory">
                                <span class="cat-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><rect x="6" y="6" width="12" height="14" rx="2"/><circle cx="12" cy="12" r="2"/></svg></span>
                                <span class="cat-label">Thẻ nhớ</span>
                                <span class="cat-chevron">›</span>
                            </a>
                        </li>
                        <li>
                            <a href="category.jsp?type=storage">
                                <span class="cat-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><ellipse cx="12" cy="14" rx="8" ry="4"/><path d="M4 14v2c0 2 3.5 4 8 4s8-2 8-4v-2"/></svg></span>
                                <span class="cat-label">Ổ cứng SSD di động</span>
                                <span class="cat-chevron">›</span>
                            </a>
                        </li>
                        <li>
                            <a href="category.jsp?type=hdd">
                                <span class="cat-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><ellipse cx="12" cy="14" rx="8" ry="4"/><path d="M4 14v2c0 2 3.5 4 8 4s8-2 8-4v-2"/></svg></span>
                                <span class="cat-label">Ổ cứng HDD di động</span>
                                <span class="cat-chevron">›</span>
                            </a>
                        </li>
                        <li>
                            <a href="category.jsp?type=usb">
                                <span class="cat-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><path d="M12 2v6M9 8h6M10 8v12a2 2 0 002 2h0a2 2 0 002-2V8"/></svg></span>
                                <span class="cat-label">USB</span>
                                <span class="cat-chevron">›</span>
                            </a>
                        </li>
                        <li>
                            <a href="category.jsp?type=hdd2">
                                <span class="cat-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><circle cx="12" cy="12" r="7"/><path d="M12 5v3M12 16v3"/></svg></span>
                                <span class="cat-label">HDD</span>
                                <span class="cat-chevron">›</span>
                            </a>
                        </li>
                        <li>
                            <a href="category.jsp?type=nas">
                                <span class="cat-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><rect x="3" y="5" width="18" height="5" rx="1"/><rect x="3" y="13" width="18" height="5" rx="1"/></svg></span>
                                <span class="cat-label">Giải pháp NAS</span>
                                <span class="cat-chevron">›</span>
                            </a>
                        </li>
                        <li>
                            <a href="category.jsp?type=accessory">
                                <span class="cat-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><path d="M12 3l2 4h4l-3 3 1 4-4-2-4 2 1-4-3-3h4z"/></svg></span>
                                <span class="cat-label">Phụ kiện</span>
                                <span class="cat-chevron">›</span>
                            </a>
                        </li>
                    </ul>
                </aside>

                <section class="content-panel">
                    <div class="hero-carousel" id="heroCarousel">
                        <div class="hero-banner">
                            <div class="hero-slide active hero-slide--pc" data-index="0">
                                <div class="hero-copy">
                                    <span class="hero-kicker">PC SIÊU TỐC</span>
                                    <h1>Nhận ngay quà khủng khi mua PC Gaming</h1>
                                    <p>Ưu đãi Office, Windows 11 Pro và phụ kiện đi kèm — sẵn hàng giao nhanh tại MemoryZone.</p>
                                    <div class="hero-actions-row">
                                        <a href="#sanpham-noibat" class="hero-primary">NHẬN NGAY</a>
                                        <a href="category.jsp?q=pc" class="hero-secondary">Xem cấu hình</a>
                                    </div>
                                </div>
                                <div class="hero-visual" aria-hidden="true"></div>
                                <div class="hero-panel-card">
                                    <div class="mini-offer">OFFICE PROFESSIONAL PLUS</div>
                                    <div class="mini-offer">WINDOWS 11 PRO</div>
                                    <div class="mini-offer">BÀN PHÍM &amp; CHUỘT</div>
                                </div>
                            </div>

                            <div class="hero-slide hero-slide--nuphy" data-index="1">
                                <div class="hero-copy">
                                    <span class="hero-kicker">NuPhy</span>
                                    <h1>Bàn phím cơ di động — gõ êm, mang đi mọi nơi</h1>
                                    <p>Thiết kế mỏng nhẹ, layout đa dạng, phù hợp làm việc và chơi game.</p>
                                    <div class="hero-actions-row">
                                        <a href="#sanpham-noibat" class="hero-primary">KHÁM PHÁ</a>
                                        <a href="category.jsp?q=nuphy" class="hero-secondary">So sánh model</a>
                                    </div>
                                </div>
                                <div class="hero-visual" aria-hidden="true"></div>
                                <div class="hero-panel-card">
                                    <div class="mini-offer">BẢO HÀNH CHÍNH HÃNG</div>
                                    <div class="mini-offer">TẶNG KEYCAP</div>
                                </div>
                            </div>

                            <div class="hero-slide hero-slide--sandisk" data-index="2">
                                <div class="hero-copy">
                                    <span class="hero-kicker">Sandisk FIFA</span>
                                    <h1>World Cup 2026 Edition — lưu trữ phong cách</h1>
                                    <p>Ổ di động &amp; thẻ nhớ phiên bản giới hạn, tốc độ cao cho game thủ.</p>
                                    <div class="hero-actions-row">
                                        <a href="#sanpham-noibat" class="hero-primary">MUA NGAY</a>
                                    </div>
                                </div>
                                <div class="hero-visual" aria-hidden="true"></div>
                                <div class="hero-panel-card">
                                    <div class="mini-offer">USB 3.2 GEN 2</div>
                                    <div class="mini-offer">THIẾT KẾ ĐỘC QUYỀN</div>
                                </div>
                            </div>

                            <div class="hero-slide hero-slide--corsair" data-index="3">
                                <div class="hero-copy">
                                    <span class="hero-kicker">Corsair K70 Pro</span>
                                    <h1>Mua kèm Stream Deck — combo streamer</h1>
                                    <p>Switch quang, đèn RGB đồng bộ iCUE, phím macro tùy chỉnh.</p>
                                    <div class="hero-actions-row">
                                        <a href="#sanpham-noibat" class="hero-primary">XEM COMBO</a>
                                    </div>
                                </div>
                                <div class="hero-visual" aria-hidden="true"></div>
                                <div class="hero-panel-card">
                                    <div class="mini-offer">TẶNG STREAM DECK</div>
                                    <div class="mini-offer">PHẦN MỀM ĐỘC QUYỀN</div>
                                </div>
                            </div>

                            <div class="hero-slide hero-slide--rtx" data-index="4">
                                <div class="hero-copy">
                                    <span class="hero-kicker">RTX 5070 Ti</span>
                                    <h1>Nhận quà giới hạn khi nâng cấp VGA</h1>
                                    <p>Hiệu năng AI &amp; ray tracing thế hệ mới — đủ cho 4K và VR.</p>
                                    <div class="hero-actions-row">
                                        <a href="#sanpham-noibat" class="hero-primary">ĐẶT TRƯỚC</a>
                                    </div>
                                </div>
                                <div class="hero-visual" aria-hidden="true"></div>
                                <div class="hero-panel-card">
                                    <div class="mini-offer">QUÀ TẶNG GIỚI HẠN</div>
                                    <div class="mini-offer">TRẢ GÓP 0%</div>
                                </div>
                            </div>
                        </div>

                        <div class="promo-strip" role="tablist" aria-label="Chọn banner khuyến mãi">
                            <button type="button" class="promo-tab active" role="tab" aria-selected="true" data-slide="0">
                                <span class="tab-title">PC Siêu Tốc</span>
                                <span class="tab-sub">Ưu đãi độc quyền</span>
                            </button>
                            <button type="button" class="promo-tab" role="tab" aria-selected="false" data-slide="1">
                                <span class="tab-title">NuPhy</span>
                                <span class="tab-sub">Bàn phím cơ di động</span>
                            </button>
                            <button type="button" class="promo-tab" role="tab" aria-selected="false" data-slide="2">
                                <span class="tab-title">Sandisk FIFA</span>
                                <span class="tab-sub">World Cup 2026 Edition</span>
                            </button>
                            <button type="button" class="promo-tab" role="tab" aria-selected="false" data-slide="3">
                                <span class="tab-title">Corsair K70 Pro</span>
                                <span class="tab-sub">Mua kèm Stream Deck</span>
                            </button>
                            <button type="button" class="promo-tab" role="tab" aria-selected="false" data-slide="4">
                                <span class="tab-title">Mua RTX 5070 Ti</span>
                                <span class="tab-sub">Nhận quà giới hạn</span>
                            </button>
                        </div>
                    </div>

                    <div class="promo-grid">
                        <a href="category.jsp?type=storage" class="promo-card warm">Ổ CỨNG DI ĐỘNG<span>Siêu bền — dung lượng lớn</span></a>
                        <a href="category.jsp?type=memory" class="promo-card red">THẺ NHỚ CHÍNH HÃNG<span>Giảm giá lên đến 30%</span></a>
                        <a href="category.jsp?type=keyboard" class="promo-card orange">CHUỘT — BÀN PHÍM — TAI NGHE<span>Ưu đãi combo theo mùa</span></a>
                    </div>

                    <section class="product-section" id="sanpham-noibat">
                        <div class="section-title-row">
                            <h2>SẢN PHẨM NỔI BẬT</h2>
                            <span>Dữ liệu từ bảng tt_sanpham</span>
                        </div>

                        <%
                            SanphamDAO sanphamDAO = new SanphamDAO();
                            List<Sanpham> danhSachSanpham = sanphamDAO.layTatCaSanpham();
                            DecimalFormat dinhDangTien = new DecimalFormat("#,###");
                        %>

                        <div class="product-grid">
                            <% if (danhSachSanpham != null && !danhSachSanpham.isEmpty()) {
                                for (Sanpham sanpham : danhSachSanpham) {
                                    String giaHienThi = dinhDangTien.format(sanpham.getGia()).replace(',', '.');
                                    String hinhAnh = sanpham.getHinhanh();
                            %>
                            <article class="product-card">
                                <% if (hinhAnh != null && !hinhAnh.trim().isEmpty()) { %>
                                <img src="<%= hinhAnh %>" alt="<%= sanpham.getTensp() %>">
                                <% } else { %>
                                <div class="product-placeholder">Chưa có hình ảnh</div>
                                <% } %>
                                <div class="product-body">
                                    <h3><%= sanpham.getTensp() %></h3>
                                    <p class="price"><%= giaHienThi %> VNĐ</p>
                                    <p class="product-info"><%= sanpham.getThongtin() %></p>
                                    <a class="detail-link" href="chi-tiet.jsp?id=<%= sanpham.getMasp() %>">Xem chi tiết</a>
                                </div>
                            </article>
                            <%      }
                                } else {
                            %>
                            <div class="empty-state">Chưa có sản phẩm nào trong bảng tt_sanpham.</div>
                            <% } %>
                        </div>
                    </section>
                </section>

                <aside class="right-rail">
                    <div class="rail-card rail-top">PC SIÊU TỐC<span>Giá tốt &amp; sẵn hàng tại MemoryZone</span></div>
                    <div class="rail-card rail-mid">NHẬN NGAY<span>Office, Windows, bàn phím &amp; chuột</span></div>
                    <div class="rail-card rail-bottom">ƯU ĐÃI<span>Khám phá sản phẩm mới mỗi ngày</span></div>
                </aside>
            </main>

            <section class="product-section" id="tin-tuc">
                <div class="section-title-row">
                    <h2>TIN TỨC CÔNG NGHỆ</h2>
                    <span>Cập nhật mới từ MemoryZone</span>
                </div>
                <div class="promo-grid">
                    <a href="Lienhe.jsp" class="promo-card warm">Build PC 2026<span>Tư vấn cấu hình theo ngân sách</span></a>
                    <a href="Lienhe.jsp" class="promo-card red">Mẹo chọn SSD<span>Tối ưu tốc độ cho laptop và desktop</span></a>
                    <a href="Lienhe.jsp#tuyendung" class="promo-card orange">Tuyển dụng<span>Gia nhập đội ngũ kỹ thuật viên</span></a>
                </div>
            </section>

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
            var tabs = document.querySelectorAll('.promo-tab');
            var slides = document.querySelectorAll('.hero-slide');
            var chatButton = document.querySelector('.chat-fab');
            function showSlide(i) {
                slides.forEach(function (s) {
                    s.classList.toggle('active', s.getAttribute('data-index') === String(i));
                });
                tabs.forEach(function (t) {
                    var on = t.getAttribute('data-slide') === String(i);
                    t.classList.toggle('active', on);
                    t.setAttribute('aria-selected', on ? 'true' : 'false');
                });
            }
            tabs.forEach(function (tab) {
                tab.addEventListener('click', function () {
                    showSlide(tab.getAttribute('data-slide'));
                });
            });

            if (chatButton) {
                chatButton.addEventListener('click', function () {
                    var link = chatButton.getAttribute('data-chat-link') || 'Lienhe.jsp';
                    window.location.href = link;
                });
            }
        })();
    </script>
</body>

</html>
