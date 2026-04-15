<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Controller.Sanpham" %>
<%@ page import="Controller.SanphamDAO" %>
<%@ page import="Controller.Khachhang" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.util.List" %>
<%
    Khachhang khDangNhap = (Khachhang) session.getAttribute("khachhang");
    Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
    
    if (khDangNhap == null || isAdmin == null || !isAdmin) {
        response.sendRedirect("../Dangnhap.jsp");
        return;
    }
    
    SanphamDAO sanphamDAO = new SanphamDAO();
    List<Sanpham> danhSachSanpham = sanphamDAO.layTatCaSanpham();
    DecimalFormat dinhDangTien = new DecimalFormat("#,###");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quáº£n lÃ½ Sáº£n pháº©m - HÄStore</title>
    <link rel="stylesheet" type="text/css" href="../Css/style.css">
    <style>
        .admin-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 20px;
        }
        .admin-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            border-radius: 10px;
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .admin-header h1 {
            margin: 0;
        }
        .admin-actions {
            display: flex;
            gap: 15px;
        }
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            text-decoration: none;
            color: white;
            font-weight: bold;
            transition: all 0.3s ease;
        }
        .btn-primary {
            background: #007bff;
        }
        .btn-success {
            background: #28a745;
        }
        .btn-danger {
            background: #dc3545;
        }
        .btn-warning {
            background: #ffc107;
            color: #333;
        }
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }
        .products-table {
            width: 100%;
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .products-table table {
            width: 100%;
            border-collapse: collapse;
        }
        .products-table th,
        .products-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        .products-table th {
            background: #f8f9fa;
            font-weight: bold;
            color: #333;
        }
        .products-table tr:hover {
            background: #f8f9fa;
        }
        .product-img {
            width: 60px;
            height: 60px;
            object-fit: cover;
            border-radius: 5px;
        }
        .action-buttons {
            display: flex;
            gap: 10px;
        }
        .action-buttons a {
            padding: 5px 10px;
            border-radius: 3px;
            text-decoration: none;
            color: white;
            font-size: 12px;
        }
        .empty-state {
            text-align: center;
            padding: 50px;
            color: #666;
        }
    </style>
</head>
<body>
    <div class="admin-container">
        <div class="admin-header">
            <div>
                <h1>Quáº£n lÃ½ Sáº£n pháº©m</h1>
                <p>Tá»ng sá»: <%= danhSachSanpham != null ? danhSachSanpham.size() : 0 %> sáº£n pháº©m</p>
            </div>
            <div class="admin-actions">
                <a href="dashboard.jsp" class="btn btn-warning">â Dashboard</a>
                <a href="add-product.jsp" class="btn btn-success">+ ThÃªm Sáº£n pháº©m</a>
                <a href="../Trangchu.jsp" class="btn btn-primary">Trang chá»§</a>
            </div>
        </div>
        
        <div class="products-table">
            <% if (danhSachSanpham != null && !danhSachSanpham.isEmpty()) { %>
                <table>
                    <thead>
                        <tr>
                            <th>HÃ¬nh áº£nh</th>
                            <th>TÃªn sáº£n pháº©m</th>
                            <th>GiÃ¡</th>
                            <th>PhÃ¢n loáº¡i</th>
                            <th>MÃ´ táº£</th>
                            <th>Thao tÃ¡c</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Sanpham sanpham : danhSachSanpham) { 
                            String giaHienThi = dinhDangTien.format(sanpham.getGia()).replace(',', '.');
                            String hinhAnh = sanpham.getHinhanh();
                        %>
                            <tr>
                                <td>
                                    <% if (hinhAnh != null && !hinhAnh.trim().isEmpty()) { %>
                                        <img src="<%= hinhAnh %>" alt="<%= sanpham.getTensp() %>" class="product-img">
                                    <% } else { %>
                                        <div style="width: 60px; height: 60px; background: #f0f0f0; display: flex; align-items: center; justify-content: center; border-radius: 5px;">No img</div>
                                    <% } %>
                                </td>
                                <td><strong><%= sanpham.getTensp() %></strong></td>
                                <td><%= giaHienThi %> VNÄ</td>
                                <td><%= sanpham.getPhanloai() != null ? sanpham.getPhanloai() : "ChÆ°a phÃ¢n loáº¡i" %></td>
                                <td><%= sanpham.getThongtin() != null && sanpham.getThongtin().length() > 50 ? sanpham.getThongtin().substring(0, 50) + "..." : sanpham.getThongtin() %></td>
                                <td>
                                    <div class="action-buttons">
                                        <a href="edit-product.jsp?id=<%= sanpham.getMasp() %>" class="btn btn-warning">Sá»a</a>
                                        <a href="delete-product.jsp?id=<%= sanpham.getMasp() %>" class="btn btn-danger" onclick="return confirm('Báº¡n cÃ³ cháº¯c cháº¯n muá»n xÃ³a sáº£n pháº©m nÃ y?')">XÃ³a</a>
                                    </div>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } else { %>
                <div class="empty-state">
                    <h3>ChÆ°a cÃ³ sáº£n pháº©m nÃ o</h3>
                    <p><a href="add-product.jsp" class="btn btn-success">+ ThÃªm sáº£n pháº©m Äáº§u tiÃªn</a></p>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>
