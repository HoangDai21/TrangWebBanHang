<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Controller.Sanpham" %>
<%@ page import="Controller.SanphamDAO" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%
    String type = request.getParameter("type");
    String q = request.getParameter("q");
    String keyword = q != null ? q.trim() : "";
    String typeKeyword = "";

    if (type != null) {
        switch (type) {
            case "ssd": typeKeyword = "ssd"; break;
            case "hdd": typeKeyword = "hdd"; break;
            case "hdd2": typeKeyword = "hdd"; break;
            case "storage": typeKeyword = "\u1ed5 c\u1ee9ng"; break;
            case "usb": typeKeyword = "usb"; break;
            case "memory": typeKeyword = "th\u1ebb nh\u1edb"; break;
            case "nas": typeKeyword = "nas"; break;
            case "nas_hdd": typeKeyword = "nas"; break;
            case "raid": typeKeyword = "raid"; break;
            case "backup_cloud": typeKeyword = "backup"; break;
            case "router": typeKeyword = "router"; break;
            case "mesh": typeKeyword = "mesh"; break;
            case "switch_net": typeKeyword = "switch"; break;
            case "switch": typeKeyword = "switch"; break;
            case "modem": typeKeyword = "modem"; break;
            case "ap": typeKeyword = "access point"; break;
            case "lan_cable": typeKeyword = "lan"; break;
            case "adapter_usb_lan": typeKeyword = "usb"; break;
            case "wifi_card": typeKeyword = "card"; break;
            case "repeater": typeKeyword = "k\u00edch s\u00f3ng"; break;
            case "box_hdd": typeKeyword = "box"; break;
            case "dock_hdd": typeKeyword = "dock"; break;
            case "adapter_storage": typeKeyword = "adapter"; break;
            case "cable_sata": typeKeyword = "c\u00e1p"; break;
            case "accessory": typeKeyword = "ph\u1ee5 ki\u1ec7n"; break;
            case "WiFi": typeKeyword = "wifi"; break;
            default: typeKeyword = type;
        }
    }

    SanphamDAO dao = new SanphamDAO();
    List<Sanpham> allProducts = dao.layTatCaSanpham();
    List<Sanpham> filtered = new ArrayList<Sanpham>();
    DecimalFormat money = new DecimalFormat("#,###");

    String typeKeywordLower = typeKeyword.toLowerCase();
    String keywordLower = keyword.toLowerCase();

    if (allProducts != null) {
        for (Sanpham sp : allProducts) {
            String ten = sp.getTensp() != null ? sp.getTensp().toLowerCase() : "";
            String thongtin = sp.getThongtin() != null ? sp.getThongtin().toLowerCase() : "";
            String phanloai = sp.getPhanloai() != null ? sp.getPhanloai().toLowerCase() : "";

            boolean okByType = typeKeyword.isEmpty()
                    || phanloai.contains(typeKeywordLower)
                    || ten.contains(typeKeywordLower)
                    || thongtin.contains(typeKeywordLower);
            boolean okByKeyword = keyword.isEmpty()
                    || phanloai.contains(keywordLower)
                    || ten.contains(keywordLower)
                    || thongtin.contains(keywordLower);

            if (okByType && okByKeyword) {
                filtered.add(sp);
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh mục sản phẩm - MemoryZone</title>
    <link rel="stylesheet" type="text/css" href="Css/style.css">
</head>
<body>
    <div class="site-shell">
        <header class="top-header">
            <a href="Trangchu.jsp" class="brand-block">
                <div class="brand-text">
                    <div class="brand-name"><span class="mem">Memory</span><span class="zone">Zone</span></div>
                    <div class="brand-tag">KẾT QUẢ TÌM KIẾM</div>
                </div>
            </a>
            <form class="search-block" action="category.jsp" method="get">
                <% if (type != null && !type.trim().isEmpty()) { %>
                <input type="hidden" name="type" value="<%= type %>">
                <% } %>
                <input type="search" name="q" placeholder="Nhập từ khóa..." value="<%= keyword %>">
                <button type="submit" aria-label="Tìm kiếm">Tìm</button>
                <div class="search-hints">Lọc theo phân loại, tên sản phẩm hoặc thông tin mô tả</div>
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
                            <p class="product-info"><strong>Phân loại:</strong> <%= sp.getPhanloai() != null ? sp.getPhanloai() : "Chưa phân loại" %></p>
                            <p class="product-info"><%= sp.getThongtin() %></p>
                            <a class="detail-link" href="chitiet.jsp?id=<%= sp.getMasp() %>">Xem chi tiết</a>
                        </div>
                    </article>
                    <% } } else { %>
                    <div class="empty-state">Không tìm thấy sản phẩm phù hợp. Vui lòng thử từ khóa khác.</div>
                    <% } %>
                </div>
            </section>
        </main>
    </div>
</body>
</html>
