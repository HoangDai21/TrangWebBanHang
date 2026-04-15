<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Controller.Sanpham" %>
<%@ page import="Controller.SanphamDAO" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết sản phẩm - MemoryZone</title>
    <link rel="stylesheet" type="text/css" href="Css/style.css">
</head>
<body>
    <%
        String idRaw = request.getParameter("id");
        int productId = -1;
        Sanpham product = null;
        DecimalFormat money = new DecimalFormat("#,###");

        try {
            productId = Integer.parseInt(idRaw);
        } catch (Exception e) {
            productId = -1;
        }

        SanphamDAO dao = new SanphamDAO();
        List<Sanpham> allProducts = dao.layTatCaSanpham();
        if (allProducts != null) {
            for (Sanpham sp : allProducts) {
                if (sp.getMasp() == productId) {
                    product = sp;
                    break;
                }
            }
        }
    %>

    <div class="site-shell">
        <header class="top-header">
            <a href="Trangchu.jsp" class="brand-block">
                <div class="brand-text">
                    <div class="brand-name"><span class="mem">Memory</span><span class="zone">Zone</span></div>
                    <div class="brand-tag">CHI TIẾT SẢN PHẨM</div>
                </div>
            </a>
            <div class="search-block">
                <input type="text" value="Xem thông tin sản phẩm" readonly>
                <button type="button">i</button>
                <div class="search-hints">Thông số - Giá - Mô tả</div>
            </div>
            <div class="header-actions">
                <a class="action-link" href="category.jsp"><span><strong>Danh mục</strong><small>Quay lại</small></span></a>
                <a class="cart-button" href="Giohang.jsp"><span>Giỏ hàng</span></a>
            </div>
        </header>

        <main class="page-layout" style="grid-template-columns: 1fr;">
            <% if (product != null) {
                String giaHienThi = money.format(product.getGia()).replace(',', '.');
                String hinhAnh = product.getHinhanh();
            %>
            <section class="product-section">
                <div class="section-title-row">
                    <h2><%= product.getTensp() %></h2>
                    <span>Mã SP: <%= product.getMasp() %></span>
                </div>
                <div style="display:grid;grid-template-columns:minmax(240px,360px) 1fr;gap:18px;">
                    <% if (hinhAnh != null && !hinhAnh.trim().isEmpty()) { %>
                    <img src="<%= hinhAnh %>" alt="<%= product.getTensp() %>" style="width:100%;border-radius:8px;border:1px solid #dde3ea;">
                    <% } else { %>
                    <div class="product-placeholder" style="height:260px;border-radius:8px;">Chưa có hình ảnh</div>
                    <% } %>
                    <div>
                        <p class="price" style="font-size:1.25rem;"><%= giaHienThi %> VNĐ</p>
                        <p class="product-info"><%= product.getThongtin() %></p>
                        <div style="display:flex;gap:10px;flex-wrap:wrap;">
                            <a class="hero-primary" href="Giohang.jsp?action=add&id=<%= product.getMasp() %>&qty=1">Thêm vào giỏ hàng</a>
                            <a class="hero-primary" href="Giohang.jsp?action=add&id=<%= product.getMasp() %>&qty=1">Mua ngay</a>
                            <a class="hero-secondary" href="category.jsp">Xem sản phẩm khác</a>
                        </div>
                    </div>
                </div>
            </section>
            <% } else { %>
            <section class="product-section">
                <div class="empty-state">Không tìm thấy sản phẩm. Vui lòng quay lại danh mục để chọn sản phẩm khác.</div>
                <p style="margin-top:12px;">
                    <a class="detail-link" href="category.jsp">Quay lại danh mục</a>
                </p>
            </section>
            <% } %>
        </main>
    </div>
</body>
</html>
