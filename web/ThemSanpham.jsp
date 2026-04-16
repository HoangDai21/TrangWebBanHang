<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Controller.Khachhang" %>
<%@ page import="Controller.Sanpham" %>
<%@ page import="Controller.SanphamDAO" %>

<%
    // Check admin authentication
    Khachhang khDangNhap = (Khachhang) session.getAttribute("khachhang");
    if (khDangNhap == null || !"admin".equals(khDangNhap.getTendangnhap())) {
        response.sendRedirect("Trangchu.jsp");
        return;
    }

    String error = null;
    String success = null;

    // Process form submission
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String maspStr = request.getParameter("masp");
        String tensp = request.getParameter("tensp");
        String giaStr = request.getParameter("gia");
        String soluongStr = request.getParameter("soluong");
        String phanloai = request.getParameter("phanloai");
        String thongtin = request.getParameter("thongtin");
        String hinhanh = request.getParameter("hinhanh");

        // Validate required fields
        if (maspStr == null || tensp == null || giaStr == null || soluongStr == null || 
            phanloai == null || thongtin == null ||
            maspStr.isEmpty() || tensp.isEmpty() || giaStr.isEmpty() || soluongStr.isEmpty() ||
            phanloai.isEmpty() || thongtin.isEmpty()) {
            error = "Vui lòng điền đầy đủ thông tin";
        } else {
            try {
                int masp = Integer.parseInt(maspStr);
                double gia = Double.parseDouble(giaStr);
                int soluong = Integer.parseInt(soluongStr);

                // Validate values
                if (gia < 0) {
                    error = "Giá sản phẩm không được âm";
                } else if (soluong < 0) {
                    error = "Số lượng không được âm";
                } else {
                    // Check if product ID already exists
                    SanphamDAO sanphamDAO = new SanphamDAO();
                    Sanpham existing = sanphamDAO.laySanphamTheoId(masp);

                    if (existing != null) {
                        error = "Mã sản phẩm đã tồn tại, vui lòng chọn mã khác";
                    } else {
                        // Create new product
                        Sanpham sanpham = new Sanpham();
                        sanpham.setMasp(masp);
                        sanpham.setTensp(tensp.trim());
                        sanpham.setGia(gia);
                        sanpham.setSoluong(soluong);
                        sanpham.setPhanloai(phanloai);
                        sanpham.setThongtin(thongtin.trim());
                        sanpham.setHinhanh(hinhanh != null ? hinhanh.trim() : "");

                        // Add product
                        boolean result = sanphamDAO.themSanpham(sanpham);
                        if (result) {
                            success = "Thêm sản phẩm thành công!";
                        } else {
                            error = "Không thể thêm sản phẩm";
                        }
                    }
                }
            } catch (NumberFormatException e) {
                error = "Giá trị không hợp lệ";
            } catch (Exception e) {
                error = "Lỗi: " + e.getMessage();
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm sản phẩm - HĐStore Admin</title>
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
            <h1>➕ THÊM SẢN PHẨM <span class="admin-badge">ADMIN</span></h1>
            <p>Quản trị hệ thống HĐStore</p>
            <a href="TrangchuAdmin.jsp" class="btn btn-secondary" style="margin-top: 10px;">← Quay lại trang chủ</a>
        </div>

        <% if (error != null) { %>
            <div class="error-message">
                <%= error %>
            </div>
        <% } %>

        <% if (success != null) { %>
            <div class="success-message">
                <%= success %>
            </div>
        <% } %>

        <form method="post" action="ThemSanpham.jsp">
            <div class="form-group">
                <label for="masp">Mã sản phẩm:</label>
                <input type="number" id="masp" name="masp" required min="1" placeholder="Nhập mã sản phẩm (VD: 101)">
            </div>

            <div class="form-group">
                <label for="tensp">Tên sản phẩm:</label>
                <input type="text" id="tensp" name="tensp" required placeholder="Nhập tên sản phẩm">
            </div>

            <div class="form-group">
                <label for="gia">Giá sản phẩm (VNĐ):</label>
                <input type="number" id="gia" name="gia" required min="0" placeholder="Nhập giá sản phẩm">
            </div>

            <div class="form-group">
                <label for="soluong">Số lượng:</label>
                <input type="number" id="soluong" name="soluong" required min="0" placeholder="Nhập số lượng">
            </div>

            <div class="form-group">
                <label for="phanloai">Phân loại:</label>
                <select id="phanloai" name="phanloai" required>
                    <option value="">-- Chọn phân loại --</option>
                    <option value="SSD">SSD</option>
                    <option value="HDD">HDD</option>
                    <option value="USB">USB</option>
                    <option value="Thẻ nhớ">Thẻ nhớ</option>
                    <option value="Router">Router WiFi</option>
                    <option value="Switch">Switch mạng</option>
                    <option value="Phụ kiện">Phụ kiện</option>
                    <option value="Khác">Khác</option>
                </select>
            </div>

            <div class="form-group">
                <label for="thongtin">Thông tin chi tiết:</label>
                <textarea id="thongtin" name="thongtin" required placeholder="Nhập thông tin chi tiết sản phẩm"></textarea>
            </div>

            <div class="form-group">
                <label for="hinhanh">Hình ảnh sản phẩm:</label>
                <input type="text" id="hinhanh" name="hinhanh" placeholder="Nhập đường dẫn hình ảnh (VD: images/product.jpg)">
                <small style="color: #666;">Để trống nếu chưa có hình ảnh</small>
            </div>

            <div class="btn-container">
                <button type="submit" class="btn btn-primary">💾 Thêm sản phẩm</button>
                <a href="TrangchuAdmin.jsp" class="btn btn-secondary">Hủy</a>
            </div>
        </form>
    </div>
</body>
</html>
