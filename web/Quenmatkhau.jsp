<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Controller.Khachhang" %>
<%@ page import="Controller.KhachhangDAO" %>
<%@ page import="java.util.Random" %>
<%!
    private static String maskEmail(String email) {
        if (email == null) return "";
        String e = email.trim();
        int at = e.indexOf("@");
        if (at <= 1) return e;
        String name = e.substring(0, at);
        String domain = e.substring(at);
        String head = name.substring(0, 1);
        String tail = name.length() >= 2 ? name.substring(name.length() - 1) : "";
        return head + "****" + tail + domain;
    }

    private static String maskPhone(String phone) {
        if (phone == null) return "";
        String p = phone.trim();
        if (p.length() <= 4) return p;
        return "****" + p.substring(p.length() - 4);
    }
%>
<%
    if (session.getAttribute("khachhang") != null) {
        response.sendRedirect("Trangchu.jsp");
        return;
    }

    String loi = "";
    String ok = "";

    // Session keys
    final String S_OTP = "reset_otp";
    final String S_OTP_TS = "reset_otp_ts";
    final String S_RESET_ID = "reset_kh_id";
    final String S_RESET_TO = "reset_to";
    final String S_RESET_CH = "reset_channel";

    // Defaults (only Gmail)
    String channel = "gmail";
    String to = request.getParameter("to") != null ? request.getParameter("to") : "";
    String step = request.getParameter("step") != null ? request.getParameter("step") : "";

    boolean hasOtp = session.getAttribute(S_OTP) != null && session.getAttribute(S_RESET_ID) != null;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        if ("request_otp".equals(step)) {
            channel = "gmail";
            to = request.getParameter("to") != null ? request.getParameter("to").trim() : "";

            if (to.isEmpty()) {
                loi = "Vui lòng nhập Gmail để nhận OTP.";
            } else {
                KhachhangDAO dao = new KhachhangDAO();
                Khachhang kh = dao.timTheoGmailHoacSdt(to);
                if (kh == null) {
                    loi = "Không tìm thấy tài khoản với thông tin bạn cung cấp.";
                } else {
                    // Generate 6-digit OTP
                    int otp = 100000 + new Random().nextInt(900000);
                    session.setAttribute(S_OTP, String.valueOf(otp));
                    session.setAttribute(S_OTP_TS, System.currentTimeMillis());
                    session.setAttribute(S_RESET_ID, kh.getId());
                    session.setAttribute(S_RESET_TO, to);
                    session.setAttribute(S_RESET_CH, channel);

                    hasOtp = true;

                    // Demo note: OTP is not actually sent via email/SMS without external config/API.
                    // We still "send" logically, and show the OTP in UI for testing.
                    String masked = "gmail".equals(channel) ? maskEmail(to) : maskPhone(to);
                    ok = "OTP đã được gửi tới " + masked + ".";
                }
            }
        } else if ("verify_reset".equals(step)) {
            String otpIn = request.getParameter("otp") != null ? request.getParameter("otp").trim() : "";
            String mk1 = request.getParameter("matkhau") != null ? request.getParameter("matkhau") : "";
            String mk2 = request.getParameter("matkhau2") != null ? request.getParameter("matkhau2") : "";

            Object otpObj = session.getAttribute(S_OTP);
            Object tsObj = session.getAttribute(S_OTP_TS);
            Object idObj = session.getAttribute(S_RESET_ID);

            if (otpObj == null || tsObj == null || idObj == null) {
                loi = "OTP chưa được tạo hoặc đã hết hạn. Vui lòng yêu cầu OTP lại.";
                hasOtp = false;
            } else {
                long ts = (Long) tsObj;
                long ageMs = System.currentTimeMillis() - ts;
                long maxMs = 5L * 60L * 1000L; // 5 minutes

                if (ageMs > maxMs) {
                    session.removeAttribute(S_OTP);
                    session.removeAttribute(S_OTP_TS);
                    session.removeAttribute(S_RESET_ID);
                    session.removeAttribute(S_RESET_TO);
                    session.removeAttribute(S_RESET_CH);
                    hasOtp = false;
                    loi = "OTP đã hết hạn (quá 5 phút). Vui lòng yêu cầu OTP lại.";
                } else if (otpIn.isEmpty() || !otpIn.equals(String.valueOf(otpObj))) {
                    loi = "OTP không đúng. Vui lòng kiểm tra lại.";
                    hasOtp = true;
                } else if (mk1.isEmpty() || mk2.isEmpty()) {
                    loi = "Vui lòng nhập mật khẩu mới và xác nhận mật khẩu.";
                    hasOtp = true;
                } else if (!mk1.equals(mk2)) {
                    loi = "Mật khẩu xác nhận không khớp.";
                    hasOtp = true;
                } else {
                    int khId = (Integer) idObj;
                    KhachhangDAO dao = new KhachhangDAO();
                    boolean updated = dao.capNhatMatKhau(khId, mk1);
                    if (updated) {
                        session.removeAttribute(S_OTP);
                        session.removeAttribute(S_OTP_TS);
                        session.removeAttribute(S_RESET_ID);
                        session.removeAttribute(S_RESET_TO);
                        session.removeAttribute(S_RESET_CH);
                        response.sendRedirect("Dangnhap.jsp?reset=1");
                        return;
                    } else {
                        loi = "Không thể cập nhật mật khẩu. Kiểm tra kết nối CSDL.";
                        hasOtp = true;
                    }
                }
            }
        }
    }

    String sentTo = session.getAttribute(S_RESET_TO) != null ? String.valueOf(session.getAttribute(S_RESET_TO)) : to;
    String sentChannel = session.getAttribute(S_RESET_CH) != null ? String.valueOf(session.getAttribute(S_RESET_CH)) : channel;
    String otpForTest = session.getAttribute(S_OTP) != null ? String.valueOf(session.getAttribute(S_OTP)) : "";
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quên mật khẩu - MemoryZone</title>
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
                <a href="Trangchu.jsp">Trang chủ</a><span>/</span>Quên mật khẩu
            </nav>

            <h1 class="login-page-title">QUÊN MẬT KHẨU</h1>
            <p class="login-page-sub">Nhớ mật khẩu rồi? <a href="Dangnhap.jsp">Quay lại đăng nhập</a></p>

            <div class="login-card-wide">
                <% if (!ok.isEmpty()) { %>
                <div class="auth-msg auth-msg--ok"><%= ok %></div>
                <% } %>
                <% if (!loi.isEmpty()) { %>
                <div class="auth-msg auth-msg--err"><%= loi %></div>
                <% } %>

                <% if (!hasOtp) { %>
                <form class="auth-form" method="post" action="Quenmatkhau.jsp" autocomplete="on">
                    <input type="hidden" name="step" value="request_otp">

                    <label for="to">Gmail *</label>
                    <input id="to" name="to" type="email" required maxlength="100" placeholder="Ví dụ: admin@gmail.com" value="<%= to %>">

                    <div class="auth-actions">
                        <button type="submit" class="login-submit-yellow">Gửi OTP</button>
                    </div>

                    <p style="margin-top:10px;color:#556;line-height:1.5;">
                        Lưu ý: để gửi OTP thật qua email cần cấu hình SMTP. Hiện tại hệ thống tạo OTP và hiển thị OTP để test.
                    </p>
                </form>
                <% } else { %>
                <div class="auth-msg auth-msg--ok" style="margin-bottom:12px;">
                    OTP đã được tạo cho <strong><%= maskEmail(sentTo) %></strong>.
                    <div style="margin-top:6px;">
                        OTP (test): <code style="font-size:1.05em;"><%= otpForTest %></code>
                    </div>
                </div>

                <form class="auth-form" method="post" action="Quenmatkhau.jsp" autocomplete="on">
                    <input type="hidden" name="step" value="verify_reset">

                    <label for="otp">Nhập OTP *</label>
                    <input id="otp" name="otp" type="text" inputmode="numeric" pattern="[0-9]{6}" maxlength="6" required placeholder="6 chữ số">

                    <label for="matkhau">Mật khẩu mới *</label>
                    <input id="matkhau" name="matkhau" type="password" required maxlength="255">

                    <label for="matkhau2">Xác nhận mật khẩu mới *</label>
                    <input id="matkhau2" name="matkhau2" type="password" required maxlength="255">

                    <div class="auth-actions">
                        <button type="submit" class="login-submit-yellow">Đổi mật khẩu</button>
                    </div>
                </form>

                <p class="auth-footer-link" style="margin-top:10px;">
                    Không nhận được OTP? <a href="Quenmatkhau.jsp">Yêu cầu lại</a>
                </p>
                <% } %>
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

