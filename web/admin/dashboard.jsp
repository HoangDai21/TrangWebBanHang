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
    <title>Admin Dashboard - HÄStore</title>
    <link rel="stylesheet" type="text/css" href="../Css/style.css">
    <style>
        .admin-container {
            max-width: 1200px;
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
        .admin-menu {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .admin-card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            text-align: center;
            transition: transform 0.3s ease;
        }
        .admin-card:hover {
            transform: translateY(-5px);
        }
        .admin-card a {
            color: #333;
            text-decoration: none;
            font-weight: bold;
            font-size: 18px;
        }
        .admin-card svg {
            width: 50px;
            height: 50px;
            margin-bottom: 15px;
            color: #667eea;
        }
        .back-btn {
            background: #dc3545;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            text-decoration: none;
            display: inline-block;
            margin-bottom: 20px;
        }
        .back-btn:hover {
            background: #c82333;
        }
    </style>
</head>
<body>
    <div class="admin-container">
        <a href="../Trangchu.jsp" class="back-btn">â Quay láº¡ trang chá»§</a>
        
        <div class="admin-header">
            <h1>Admin Dashboard</h1>
            <p>Chào mÆ°ng báº¡n, <%= khDangNhap.getTentaikhoan() %>!</p>
            <p>Quáº£n lÃ½ há» thá»ng HÄStore</p>
        </div>
        
        <div class="admin-menu">
            <div class="admin-card">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M12 2L2 7v10c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V7l-10-5z"/>
                </svg>
                <a href="products.jsp">Quáº£n lÃ½ Sáº£n pháº©m</a>
            </div>
            
            <div class="admin-card">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
                    <circle cx="9" cy="7" r="4"/>
                    <path d="M23 21v-2a4 4 0 0 0-3-3.87"/>
                    <path d="M16 3.13a4 4 0 0 1 0 7.75"/>
                </svg>
                <a href="#">Quáº£n lÃ½ KhÃ¡ch hÃ ng</a>
            </div>
            
            <div class="admin-card">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <rect x="3" y="3" width="18" height="18" rx="2" ry="2"/>
                    <line x1="9" y1="9" x2="15" y2="9"/>
                    <line x1="9" y1="15" x2="15" y2="15"/>
                </svg>
                <a href="#">Quáº£n lÃ½ ÄÆ¡n hÃ ng</a>
            </div>
            
            <div class="admin-card">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M18 20V10"/>
                    <path d="M12 20V4"/>
                    <path d="M6 20v-6"/>
                </svg>
                <a href="#">Thá»ng kÃª</a>
            </div>
        </div>
        
        <div class="admin-card">
            <h3>ThÃ´ng tin há» thá»ng</h3>
            <p>â NgÃ y: <%= new java.util.Date() %></p>
            <p>â PhiÃªn báº£n: 1.0</p>
            <p>â Database: MySQL</p>
        </div>
    </div>
</body>
</html>
