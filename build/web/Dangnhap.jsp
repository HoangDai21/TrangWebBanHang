<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="Controller.Khachhang" %>
        <%@ page import="Controller.KhachhangDAO" %>
            <% if (session.getAttribute("khachhang") !=null) { response.sendRedirect("Trangchu.jsp"); return; } String
                loi="" ; String registered=request.getParameter("registered"); String
                reset=request.getParameter("reset"); String oauth=request.getParameter("oauth"); String
                error=request.getParameter("error"); if ("POST".equalsIgnoreCase(request.getMethod())) { String
                email=request.getParameter("email"); String matkhau=request.getParameter("matkhau"); KhachhangDAO
                dao=new KhachhangDAO(); Khachhang kh=dao.dangNhapBangEmailHoacTenDangNhap(email, matkhau); if (kh
                !=null) { session.setAttribute("khachhang", kh); if (kh.getId()==1 || "admin"
                .equalsIgnoreCase(kh.getTendangnhap())) { session.setAttribute("isAdmin", true); } else {
                session.removeAttribute("isAdmin"); } response.sendRedirect("Trangchu.jsp"); return; }
                loi="Sai email / tên đăng nhập hoặc mật khẩu." ; } String ctx=request.getContextPath(); String
                emailValue=request.getParameter("email"); %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Đăng nhập tài khoản - MemoryZone</title>
                    <link rel="stylesheet" type="text/css" href="Css/style.css">
                </head>

                <body>
                    <div class="sticky-top">
                        <header class="top-header">
                            <a href="Trangchu.jsp" class="brand-block">
                                <div class="brand-mark" aria-hidden="true">
                                    <svg viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
                                        <rect x="2" y="6" width="28" height="20" rx="3" stroke="#ffd44d"
                                            stroke-width="2" />
                                        <path d="M8 14h16M8 18h10" stroke="#ffd44d" stroke-width="2"
                                            stroke-linecap="round" />
                                    </svg>
                                </div>
                                <div class="brand-text">
                                    <div class="brand-name"><span class="mem">Memory</span><span
                                            class="zone">Zone</span></div>
                                    <div class="brand-tag">BY SIÊU TỐC</div>
                                </div>
                            </a>

                            <form class="search-block" action="category.jsp" method="get">
                                <input type="search" name="q" placeholder="Bạn cần tìm gì?" autocomplete="off">
                                <button type="submit" aria-label="Tìm kiếm">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                                        <circle cx="11" cy="11" r="7" />
                                        <path d="M20 20l-4.3-4.3" />
                                    </svg>
                                </button>
                                <div class="search-hints">bàn phím keychron · MSI Cyborg 15 · ASUS OLED · PC Gaming ·
                                    USB</div>
                            </form>

                            <div class="header-actions">
                                <a class="action-link" href="Dangnhap.jsp">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                                        <circle cx="12" cy="8" r="4" />
                                        <path d="M4 20c0-4 3.5-6 8-6s8 2 8 6" />
                                    </svg>
                                    <span>
                                        <strong>Tài khoản</strong>
                                        <small>Đăng nhập</small>
                                    </span>
                                </a>
                                <a class="cart-button" href="Giohang.jsp">
                                    <span class="cart-count">0</span>
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                                        <path d="M6 6h15l-1.5 9h-12z" />
                                        <circle cx="9" cy="20" r="1.5" />
                                        <circle cx="18" cy="20" r="1.5" />
                                        <path d="M6 6L5 3H2" />
                                    </svg>
                                    <span>Giỏ hàng</span>
                                </a>
                            </div>
                        </header>

                        <nav class="main-nav main-nav--with-cat">
                            <a class="main-nav-cat" href="Trangchu.jsp"><span class="main-nav-cat-icon"
                                    aria-hidden="true">☰</span> DANH MỤC SẢN PHẨM</a>
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
                                    <a href="Trangchu.jsp">Trang chủ</a><span>/</span>Đăng nhập tài khoản
                                </nav>

                                <h1 class="login-page-title">ĐĂNG NHẬP TÀI KHOẢN</h1>
                                <p class="login-page-sub">Bạn chưa có tài khoản? <a href="Dangky.jsp">Đăng ký tại
                                        đây</a></p>

                                <div class="login-card-wide">
                                    <% if ("1".equals(registered)) { %>
                                        <div class="auth-msg auth-msg--ok">Đăng ký thành công. Vui lòng đăng nhập.</div>
                                        <% } %>
                                            <% if ("1".equals(reset)) { %>
                                                <div class="auth-msg auth-msg--ok">Đổi mật khẩu thành công. Vui lòng
                                                    đăng nhập lại.</div>
                                                <% } %>
                                                    <% if ("need_config".equals(oauth)) { %>
                                                        <div class="auth-msg auth-msg--err">Chưa cấu hình OAuth. Sửa App
                                                            ID / Secret trong <code>WEB-INF/web.xml</code>. Redirect URI
                                                            (đăng ký tại Facebook/Google):
                                                            <br><code>http://<%= request.getServerName() %>:<%= request.getServerPort() %><%= ctx %>/oauth/callback</code>
                                                        </div>
                                                        <% } %>
                                                            <% if ("cancel".equals(oauth)) { %>
                                                                <div class="auth-msg auth-msg--err">Bạn đã hủy đăng nhập
                                                                    OAuth.</div>
                                                                <% } %>
                                                                    <% if ("invalid".equals(oauth) || "fail"
                                                                        .equals(oauth)) { %>
                                                                        <div class="auth-msg auth-msg--err">Đăng nhập
                                                                            OAuth không thành công. Thử lại hoặc dùng
                                                                            email.</div>
                                                                        <% } %>
                                                                            <% if ("1".equals(error)) { %>
                                                                                <div class="auth-msg auth-msg--err">Sai
                                                                                    tên đăng nhập hoặc mật khẩu.</div>
                                                                                <% } %>
                                                                                    <% if (!loi.isEmpty()) { %>
                                                                                        <div
                                                                                            class="auth-msg auth-msg--err">
                                                                                            <%= loi %>
                                                                                        </div>
                                                                                        <% } %>

                                                                                            <form class="auth-form"
                                                                                                method="post"
                                                                                                action="<%= ctx %>/Dangnhap.jsp"
                                                                                                autocomplete="on">
                                                                                                <label for="email">Email
                                                                                                    *</label>
                                                                                                <input id="email"
                                                                                                    name="email"
                                                                                                    type="text" required
                                                                                                    maxlength="100"
                                                                                                    placeholder="admin@gmail.com hoặc tên đăng nhập"
                                                                                                    value="<%= emailValue != null ? emailValue : "" %>">

                                                                                                <label for="matkhau">Mật
                                                                                                    khẩu *</label>
                                                                                                <input id="matkhau"
                                                                                                    name="matkhau"
                                                                                                    type="password"
                                                                                                    required
                                                                                                    maxlength="255">

                                                                                                <a class="login-forgot login-forgot--btn"
                                                                                                    href="Quenmatkhau.jsp">Quên
                                                                                                    mật khẩu</a>

                                                                                                <div
                                                                                                    class="auth-actions">
                                                                                                    <button
                                                                                                        type="submit"
                                                                                                        class="login-submit-yellow">Đăng
                                                                                                        nhập</button>
                                                                                                </div>
                                                                                            </form>

                                                                                            <p
                                                                                                class="social-login-title">
                                                                                                Hoặc đăng nhập bằng</p>
                                                                                            <div class="social-buttons">
                                                                                                <a class="social-btn social-btn--fb"
                                                                                                    href="<%= ctx %>/oauth/login?provider=facebook">
                                                                                                    <svg viewBox="0 0 24 24"
                                                                                                        fill="currentColor"
                                                                                                        aria-hidden="true">
                                                                                                        <path
                                                                                                            d="M9 8h-3v4h3v12h5v-12h3.642l.358-4h-4v-1.667c0-.955.192-1.333 1.115-1.333h2.885v-5h-3.808c-3.596 0-5.192 1.583-5.192 4.615v2.385z" />
                                                                                                    </svg>
                                                                                                    Facebook
                                                                                                </a>
                                                                                                <a class="social-btn social-btn--gg"
                                                                                                    href="<%= ctx %>/oauth/login?provider=google">
                                                                                                    <svg viewBox="0 0 24 24"
                                                                                                        fill="currentColor"
                                                                                                        aria-hidden="true">
                                                                                                        <path
                                                                                                            d="M12.545 10.239v3.821h5.445c-.712 2.315-2.647 3.972-5.445 3.972a6.033 6.033 0 110-12.064c1.498 0 2.866.549 3.921 1.453l2.814-2.814A9.969 9.969 0 0012.545 2C7.021 2 2.543 6.477 2.543 12s4.478 10 10.002 10c8.396 0 10.249-7.85 9.426-11.748l-9.426-.013z" />
                                                                                                    </svg>
                                                                                                    Google
                                                                                                </a>
                                                                                            </div>
                                </div>
                            </div>

                            <div class="trust-bar">
                                <div><strong>Giao hàng Siêu Tốc</strong>2-4H nội thành</div>
                                <div><strong>7 ngày đổi trả</strong>Theo chính sách</div>
                                <div><strong>100% chính hãng</strong>Cam kết sản phẩm</div>
                                <div><strong>Thanh toán dễ dàng</strong>Tiền mặt, chuyển khoản</div>
                            </div>

                            <footer class="footer">
                                <p>Bản quyền © 2026 - MemoryZone</p>
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

                    <button type="button" class="chat-fab" aria-label="Chat hỗ trợ" title="Chat"
                        data-chat-link="Lienhe.jsp">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                            <path d="M21 12a8 8 0 01-8 8H8l-5 3 2-4a8 8 0 118-7z" />
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