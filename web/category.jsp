<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Controller.Sanpham" %>
<%@ page import="Controller.SanphamDAO" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh mục sản phẩm - MemoryZone</title>
    <link rel="stylesheet" type="text/css" href="Css/style.css">
</head>
<body>
    <%
        String type = request.getParameter("type");
        String q = request.getParameter("q");
        String keyword = q != null ? q.trim() : "";
        String typeKeyword = "";

        if (type != null) {
            switch (type) {
                case "keyboard": typeKeyword = "bàn phím"; break;
                case "laptop": typeKeyword = "laptop"; break;
                case "pc": typeKeyword = "pc"; break;
                case "build": typeKeyword = "build"; break;
                case "parts": typeKeyword = "linh kiện"; break;
                case "monitor": typeKeyword = "màn hình"; break;
                case "lifestyle": typeKeyword = "livestream"; break;
                case "ssd": typeKeyword = "ssd"; break;
                case "ram": typeKeyword = "ram"; break;
                case "memory": typeKeyword = "thẻ nhớ"; break;
                case "storage": typeKeyword = "ổ cứng"; break;
                case "hdd": typeKeyword = "hdd"; break;
                case "usb": typeKeyword = "usb"; break;
                case "nas": typeKeyword = "nas"; break;
                case "accessory": typeKeyword = "phụ kiện"; break;
                default: typeKeyword = type;
            }
        }

        SanphamDAO dao = new SanphamDAO();
        List<Sanpham> allProducts = dao.layTatCaSanpham();
        List<Sanpham> filtered = new ArrayList<Sanpham>();
        DecimalFormat money = new DecimalFormat("#,###");

        if (allProducts != null) {
            for (Sanpham sp : allProducts) {
                String ten = sp.getTensp() != null ? sp.getTensp().toLowerCase() : "";
                String thongtin = sp.getThongtin() != null ? sp.getThongtin().toLowerCase() : "";

                boolean okByType = typeKeyword.isEmpty() ||
                        ten.contains(typeKeyword.toLowerCase()) ||
                        thongtin.contains(typeKeyword.toLowerCase());
                boolean okByKeyword = keyword.isEmpty() ||
                        ten.contains(keyword.toLowerCase()) ||
                        thongtin.contains(keyword.toLowerCase());

                if (okByType && okByKeyword) {
                    filtered.add(sp);
                }
            }
        }
    %>

    <div class="site-shell">
        <header class="top-header">
            <a href="Trangchu.jsp" class="brand-block">
                <div class="brand-text">
                    <div class="brand-name"><span class="mem">Memory</span><span class="zone">Zone</span></div>
                    <div class="brand-tag">KẾT QUẢ TÌM KIẾM</div>
                </div>
            </a>
            <form class="search-block" action="category.jsp" method="get">
                <input type="search" name="q" placeholder="Nhập từ khóa..." value="<%= keyword %>">
                <button type="submit" aria-label="Tìm kiếm">Tìm</button>
                <div class="search-hints">Lọc theo tên sản phẩm hoặc thông tin mô tả</div>
            </form>
            <div class="header-actions">
                <a class="action-link" href="Trangchu.jsp"><span><strong>Trang chủ</strong><small>Quay lại</small></span></a>
                <a class="cart-button" href="Giohang.jsp"><span>Giỏ hàng</span></a>
            </div>
        </header>

        <main class="page-layout" style="grid-template-columns: 1fr;">
            <section class="product-section">
                <div class="section-title-row">
                    <h2>KẾT QUẢ SẢN PHẨM</h2>
                    <span>Tìm thấy <%= filtered.size() %> sản phẩm</span>
                </div>
                <div class="product-grid">
                    <% if (!filtered.isEmpty()) {
                        for (Sanpham sp : filtered) {
                            String giaHienThi = money.format(sp.getGia()).replace(',', '.');
                            String hinhAnh = sp.getHinhanh();
                    %>
                    <article class="product-card">
                        <% if (hinhAnh != null && !hinhAnh.trim().isEmpty()) { %>
                        <img src="<%= hinhAnh %>" alt="<%= sp.getTensp() %>">
                        <% } else { %>
                        <div class="product-placeholder">Chưa có hình ảnh</div>
                        <% } %>
                        <div class="product-body">
                            <h3><%= sp.getTensp() %></h3>
                            <p class="price"><%= giaHienThi %> VNĐ</p>
                            <p class="product-info"><%= sp.getThongtin() %></p>
                            <a class="detail-link" href="chi-tiet.jsp?id=<%= sp.getMasp() %>">Xem chi tiết</a>
                        </div>
                    </article>
                    <%  }
                    } else { %>
                    <div class="empty-state">Không tìm thấy sản phẩm phù hợp. Vui lòng thử từ khóa khác.</div>
                    <% } %>
                </div>
            </section>
        </main>
    </div>
</body>
</html>
