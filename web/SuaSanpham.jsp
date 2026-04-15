<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="Controller.Khachhang" %>
    <%@ page import="Controller.Sanpham" %>
    <%@ page import="Controller.SanphamDAO" %>
        <% Khachhang khDangNhap=(Khachhang) session.getAttribute("khachhang"); 
           
        // Check if user is admin
        boolean isAdmin = false;
        if (khDangNhap != null && "admin".equals(khDangNhap.getTendangnhap())) {
            isAdmin = true;
        } else {
            response.sendRedirect("Trangchu.jsp");
            return;
        }
        
        // Get product information
        String productId = request.getParameter("id");
        Sanpham sanpham = null;
        if (productId != null) {
            try {
                int id = Integer.parseInt(productId);
                SanphamDAO sanphamDAO = new SanphamDAO();
                sanpham = sanphamDAO.laySanphamTheoId(id);
            } catch (Exception e) {
                response.sendRedirect("TrangchuAdmin.jsp");
                return;
            }
        }
        
        if (sanpham == null) {
            response.sendRedirect("TrangchuAdmin.jsp");
            return;
        } %>
        
        <!DOCTYPE html>
        <html lang="vi">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Sửa sản phẩm - HĐStore Admin</title>
            <link rel="stylesheet" type="text/css" href="Css/style.css">
            <style>
                .admin-container {
                    max-width: 800px;
                    margin: 100px auto 50px;
                    padding: 30px;
                    background: white;
                    border-radius: 10px;
                    box-shadow: 0 4px 20px rgba(0,0,0,0.1);
                }
                
                .admin-header {
                    text-align: center;
                    margin-bottom: 30px;
                    padding-bottom: 20px;
                    border-bottom: 2px solid #f0f0f0;
                }
                
                .admin-header h1 {
                    color: #333;
                    margin-bottom: 10px;
                }
                
                .admin-badge {
                    background: #ff6b6b;
                    color: white;
                    padding: 4px 8px;
                    border-radius: 12px;
                    font-size: 11px;
                    font-weight: bold;
                    margin-left: 8px;
                }
                
                .product-info {
                    background: #f8f9fa;
                    padding: 15px;
                    border-radius: 5px;
                    margin-bottom: 20px;
                }
                
                .form-group {
                    margin-bottom: 20px;
                }
                
                .form-group label {
                    display: block;
                    margin-bottom: 8px;
                    font-weight: bold;
                    color: #333;
                }
                
                .form-group input,
                .form-group textarea,
                .form-group select {
                    width: 100%;
                    padding: 12px;
                    border: 2px solid #ddd;
                    border-radius: 5px;
                    font-size: 14px;
                    transition: border-color 0.3s ease;
                }
                
                .form-group input:focus,
                .form-group textarea:focus,
                .form-group select:focus {
                    outline: none;
                    border-color: #667eea;
                }
                
                .form-group textarea {
                    height: 100px;
                    resize: vertical;
                }
                
                .btn-container {
                    text-align: center;
                    margin-top: 30px;
                }
                
                .btn {
                    padding: 12px 30px;
                    margin: 0 10px;
                    border: none;
                    border-radius: 5px;
                    font-size: 16px;
                    font-weight: bold;
                    cursor: pointer;
                    transition: all 0.3s ease;
                    text-decoration: none;
                    display: inline-block;
                }
                
                .btn-primary {
                    background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
                    color: white;
                }
                
                .btn-primary:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 4px 15px rgba(40, 167, 69, 0.4);
                }
                
                .btn-secondary {
                    background: #6c757d;
                    color: white;
                }
                
                .btn-secondary:hover {
                    background: #5a6268;
                }
                
                .btn-danger {
                    background: #dc3545;
                    color: white;
                }
                
                .btn-danger:hover {
                    background: #c82333;
                }
                
                .error-message {
                    color: #dc3545;
                    background: #f8d7da;
                    border: 1px solid #f5c6cb;
                    padding: 10px;
                    border-radius: 5px;
                    margin-bottom: 20px;
                }
                
                .success-message {
                    color: #155724;
                    background: #d4edda;
                    border: 1px solid #c3e6cb;
                    padding: 10px;
                    border-radius: 5px;
                    margin-bottom: 20px;
                }
            </style>
        </head>
        <body>
            <div class="admin-container">
                <div class="admin-header">
                    <h1>✏️ SỬA SẢN PHẨM <span class="admin-badge">ADMIN</span></h1>
                    <p>Quản trị hệ thống HĐStore</p>
                    <a href="TrangchuAdmin.jsp" class="btn btn-secondary" style="margin-top: 10px;">← Quay lại trang chủ</a>
                </div>
                
                <div class="product-info">
                    <strong>Thông tin sản phẩm hiện tại:</strong><br>
                    ID: <%= sanpham.getMasp() %> | 
                    Tên: <%= sanpham.getTensp() %> | 
                    Giá: <%= sanpham.getGia() %> VNĐ
                </div>
                
                <% if (request.getParameter("error") != null) { %>
                    <div class="error-message">
                        <%= request.getParameter("error") %>
                    </div>
                <% } %>
                
                <% if (request.getParameter("success") != null) { %>
                    <div class="success-message">
                        <%= request.getParameter("success") %>
                    </div>
                <% } %>
                
                <form method="post" action="XuLySuaSanpham.jsp">
                    <input type="hidden" name="masp" value="<%= sanpham.getMasp() %>">
                    
                    <div class="form-group">
                        <label for="tensp">Tên sản phẩm:</label>
                        <input type="text" id="tensp" name="tensp" required value="<%= sanpham.getTensp() %>">
                    </div>
                    
                    <div class="form-group">
                        <label for="gia">Giá sản phẩm (VNĐ):</label>
                        <input type="number" id="gia" name="gia" required min="0" value="<%= sanpham.getGia() %>">
                    </div>
                    
                    <div class="form-group">
                        <label for="phanloai">Phân loại:</label>
                        <select id="phanloai" name="phanloai" required>
                            <option value="">-- Chọn phân loại --</option>
                            <option value="SSD" <%= "SSD".equals(sanpham.getPhanloai()) ? "selected" : "" %>>SSD</option>
                            <option value="HDD" <%= "HDD".equals(sanpham.getPhanloai()) ? "selected" : "" %>>HDD</option>
                            <option value="USB" <%= "USB".equals(sanpham.getPhanloai()) ? "selected" : "" %>>USB</option>
                            <option value="Thẻ nhớ" <%= "Thẻ nhớ".equals(sanpham.getPhanloai()) ? "selected" : "" %>>Thẻ nhớ</option>
                            <option value="Router" <%= "Router".equals(sanpham.getPhanloai()) ? "selected" : "" %>>Router WiFi</option>
                            <option value="Switch" <%= "Switch".equals(sanpham.getPhanloai()) ? "selected" : "" %>>Switch mạng</option>
                            <option value="Phụ kiện" <%= "Phụ kiện".equals(sanpham.getPhanloai()) ? "selected" : "" %>>Phụ kiện</option>
                            <option value="Khác" <%= "Khác".equals(sanpham.getPhanloai()) ? "selected" : "" %>>Khác</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="thongtin">Thông tin chi tiết:</label>
                        <textarea id="thongtin" name="thongtin" required><%= sanpham.getThongtin() %></textarea>
                    </div>
                    
                    <div class="form-group">
                        <label for="hinhanh">Hình ảnh sản phẩm:</label>
                        <input type="text" id="hinhanh" name="hinhanh" value="<%= sanpham.getHinhanh() != null ? sanpham.getHinhanh() : "" %>">
                        <small style="color: #666;">Nhập đường dẫn hình ảnh hoặc để trống nếu chưa có</small>
                    </div>
                    
                    <div class="btn-container">
                        <button type="submit" class="btn btn-primary">💾 Lưu thay đổi</button>
                        <a href="XoaSanpham.jsp?id=<%= sanpham.getMasp() %>" class="btn btn-danger" onclick="return confirm('Bạn có chắc chắn muốn xóa sản phẩm này?')">🗑️ Xóa sản phẩm</a>
                        <a href="TrangchuAdmin.jsp" class="btn btn-secondary">Hủy</a>
                    </div>
                </form>
            </div>
        </body>
        </html>
