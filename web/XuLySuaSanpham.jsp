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

    // Check if form was submitted via POST
    if (!"POST".equalsIgnoreCase(request.getMethod())) {
        response.sendRedirect("Trangchu.jsp");
        return;
    }

    // Get form parameters
    String maspStr = request.getParameter("masp");
    String tensp = request.getParameter("tensp");
    String giaStr = request.getParameter("gia");
    String phanloai = request.getParameter("phanloai");
    String thongtin = request.getParameter("thongtin");
    String hinhanh = request.getParameter("hinhanh");

    // Validate required fields
    if (maspStr == null || tensp == null || giaStr == null || phanloai == null || thongtin == null ||
        maspStr.isEmpty() || tensp.isEmpty() || giaStr.isEmpty() || phanloai.isEmpty() || thongtin.isEmpty()) {
        response.sendRedirect("SuaSanpham.jsp?id=" + maspStr + "&error=Vui lòng điền đầy đủ thông tin");
        return;
    }

    try {
        int masp = Integer.parseInt(maspStr);
        double gia = Double.parseDouble(giaStr);

        // Validate price is positive
        if (gia < 0) {
            response.sendRedirect("SuaSanpham.jsp?id=" + masp + "&error=Giá sản phẩm không được âm");
            return;
        }

        // Create product object
        Sanpham sanpham = new Sanpham();
        sanpham.setMasp(masp);
        sanpham.setTensp(tensp.trim());
        sanpham.setGia(gia);
        sanpham.setPhanloai(phanloai);
        sanpham.setThongtin(thongtin.trim());
        sanpham.setHinhanh(hinhanh != null ? hinhanh.trim() : "");
        // Keep existing quantity (get from DB)
        SanphamDAO tempDAO = new SanphamDAO();
        Sanpham existing = tempDAO.laySanphamTheoId(masp);
        sanpham.setSoluong(existing != null ? existing.getSoluong() : 0);

        // Update product
        SanphamDAO sanphamDAO = new SanphamDAO();
        boolean success = sanphamDAO.capNhatSanpham(sanpham);

        if (success) {
            response.sendRedirect("Trangchu.jsp?success=Cập nhật sản phẩm thành công");
        } else {
            response.sendRedirect("SuaSanpham.jsp?id=" + masp + "&error=Không thể cập nhật sản phẩm");
        }

    } catch (NumberFormatException e) {
        response.sendRedirect("SuaSanpham.jsp?id=" + maspStr + "&error=Giá trị không hợp lệ");
    } catch (Exception e) {
        response.sendRedirect("SuaSanpham.jsp?id=" + maspStr + "&error=Lỗi: " + e.getMessage());
    }
%>
