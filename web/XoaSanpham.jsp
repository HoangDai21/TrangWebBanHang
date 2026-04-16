<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Controller.Khachhang" %>
<%@ page import="Controller.SanphamDAO" %>

<%
    // Check admin authentication
    Khachhang khDangNhap = (Khachhang) session.getAttribute("khachhang");
    if (khDangNhap == null || !"admin".equals(khDangNhap.getTendangnhap())) {
        response.sendRedirect("Trangchu.jsp");
        return;
    }

    // Get product ID from request
    String maspStr = request.getParameter("id");

    if (maspStr == null || maspStr.isEmpty()) {
        response.sendRedirect("TrangchuAdmin.jsp?error=Không tìm thấy sản phẩm cần xóa");
        return;
    }

    try {
        int masp = Integer.parseInt(maspStr);

        // Delete product
        SanphamDAO sanphamDAO = new SanphamDAO();
        boolean success = sanphamDAO.xoaSanpham(masp);

        if (success) {
            response.sendRedirect("TrangchuAdmin.jsp?success=Xóa sản phẩm thành công");
        } else {
            response.sendRedirect("TrangchuAdmin.jsp?error=Không thể xóa sản phẩm");
        }

    } catch (NumberFormatException e) {
        response.sendRedirect("TrangchuAdmin.jsp?error=ID sản phẩm không hợp lệ");
    } catch (Exception e) {
        response.sendRedirect("TrangchuAdmin.jsp?error=Lỗi: " + e.getMessage());
    }
%>
