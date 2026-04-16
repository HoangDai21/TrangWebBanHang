<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Controller.Khachhang" %>
<%@ page import="Controller.SanphamDAO" %>

<%
    // Kiem tra quyen admin
    Khachhang khDangNhap = (Khachhang) session.getAttribute("khachhang");
    if (khDangNhap == null || !"admin".equals(khDangNhap.getTendangnhap())) {
        response.sendRedirect("Trangchu.jsp");
        return;
    }

    // Lay product ID tu request
    String maspStr = request.getParameter("id");

    if (maspStr == null || maspStr.isEmpty()) {
        response.sendRedirect("Trangchu.jsp?error=Khong tim thay san pham can xoa");
        return;
    }

    try {
        int masp = Integer.parseInt(maspStr);

        // Delete product
        SanphamDAO sanphamDAO = new SanphamDAO();
        boolean success = sanphamDAO.xoaSanpham(masp);

        if (success) {
            response.sendRedirect("Trangchu.jsp?success=Xoa san pham thanh cong");
        } else {
            response.sendRedirect("Trangchu.jsp?error=Khong the xoa san pham");
        }

    } catch (NumberFormatException e) {
        response.sendRedirect("Trangchu.jsp?error=ID san pham khong hop le");
    } catch (Exception e) {
        response.sendRedirect("Trangchu.jsp?error=Loi: " + e.getMessage());
    }
%>
