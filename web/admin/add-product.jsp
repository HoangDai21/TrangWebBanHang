<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Controller.Khachhang" %>
<%
    Khachhang khDangNhap = (Khachhang) session.getAttribute("khachhang");
    Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
    
    if (khDangNhap == null || isAdmin == null || !isAdmin) {
        response.sendRedirect("../Dangnhap.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ThÃªm Sáº£n pháº©m - HÄStore</title>
    <link rel="stylesheet" type="text/css" href="../Css/style.css">
    <style>
        .admin-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        .admin-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            border-radius: 10px;
            margin-bottom: 30px;
            text-align: center;
        }
        .form-container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #333;
        }
        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
        }
        .form-group textarea {
            height: 100px;
            resize: vertical;
        }
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 5px;
            text-decoration: none;
            color: white;
            font-weight: bold;
            cursor: pointer;
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
        .form-actions {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 30px;
        }
    </style>
</head>
<body>
    <div class="admin-container">
        <div class="admin-header">
            <h1>ThÃªm Sáº£n pháº©m Má»i</h1>
            <p>Nháº­p thÃ´ng tin sáº£n pháº©m Äá» thÃªm vÃ o há» thá»ng</p>
        </div>
        
        <div class="form-container">
            <form action="../ThemSanpham" method="post" enctype="multipart/form-data">
                <div class="form-group">
                    <label for="tensp">TÃªn sáº£n pháº©m *</label>
                    <input type="text" id="tensp" name="tensp" required>
                </div>
                
                <div class="form-group">
                    <label for="gia">GiÃ¡ *</label>
                    <input type="number" id="gia" name="gia" required min="0">
                </div>
                
                <div class="form-group">
                    <label for="phanloai">PhÃ¢n loáº¡i *</label>
                    <select id="phanloai" name="phanloai" required>
                        <option value="">-- Chá»n phÃ¢n loáº¡i --</option>
                        <option value="SSD">SSD</option>
                        <option value="HDD">HDD</option>
                        <option value="USB">USB</option>
                        <option value="Tháº» nhá»">Tháº» nhá»</option>
                        <option value="Router">Router</option>
                        <option value="Switch">Switch</option>
                        <option value="NAS">NAS</option>
                        <option value="KhÃ¡c">KhÃ¡c</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="thongtin">MÃ´ táº£ sáº£n pháº©m *</label>
                    <textarea id="thongtin" name="thongtin" required placeholder="Nháº­p mÃ´ táº£ chi tiáº¿t vá» sáº£n pháº©m..."></textarea>
                </div>
                
                <div class="form-group">
                    <label for="hinhanh">HÃ¬nh áº£nh</label>
                    <input type="file" id="hinhanh" name="hinhanh" accept="image/*">
                    <small>Äá» trá»ng náº¿u khÃ´ng cÃ³ hÃ¬nh áº£nh</small>
                </div>
                
                <div class="form-actions">
                    <button type="submit" class="btn btn-success">+ ThÃªm Sáº£n pháº©m</button>
                    <a href="products.jsp" class="btn btn-warning">â Quay láº¡i</a>
                    <a href="dashboard.jsp" class="btn btn-primary">Dashboard</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
