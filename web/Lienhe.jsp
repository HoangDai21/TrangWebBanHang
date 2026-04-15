<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="java.sql.*" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>Thế Giới Thiết Bị Lưu Trữ & Mạng</title>
            <link rel="stylesheet" type="text/css" href="css/style.css">
            <link href="Css/Menu.css" rel="stylesheet" type="text/css" />
        </head>

        <body>
            <div class="banner">
                <h1>THIẾT BỊ LƯU TRỮ & THIẾT BỊ MẠNG</h1>
            </div>

            <div class="top-menu">
                <a href="Trangchu.jsp">Trang chủ</a>
                <a href="Giohang.jsp">Giỏ hàng</a>
                <a href="Dangky.jsp">Đăng ký</a>
                <a href="Dangnhap.jsp">Đăng nhập</a>
                <a href="Lienhe.jsp">Liên hệ</a>
            </div>

            <div class="main-container">
                <div class="left-menu">
                    <h3>DANH MỤC THIẾT BỊ</h3>
                    <ul>
                        <li><a href="category.jsp?type=storage">Thiết bị lưu trữ (SSD/HDD)</a></li>
                        <li><a href="category.jsp?type=network">Thiết bị mạng (Router/Switch)</a></li>
                        <li><a href="category.jsp?type=nas">Hệ thống NAS</a></li>
                        <li><a href="category.jsp?type=accessory">Phụ kiện công nghệ</a></li>
                    </ul>
                </div>

                <div class="content">
                    <h2>SẢN PHẨM NỔI BẬT</h2>
                    <div class="product-grid">
                        <div class="product-card">
                            <h2>SẢN PHẨM NỔI BẬTSẢN PHẨM NỔI BẬT</h2>
                            <a href="chi-tiet.jsp?id">
                                <h2>SẢN PHẨM NỔI BẬT</h2>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="footer">
                <p>Bản quyền © 2026 - MemoryStorage</p>
                <p>Thực hiện bởi: Hoang Quoc Dai</p>
                <p>Nội dung: Hoang Quoc Dai</p>
                <p>Ngày hoàn thành: none</p>
            </div>
        </body>

        </html>