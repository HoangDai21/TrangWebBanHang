package Controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet("/ThemSanpham")
public class ThemSanpham extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Boolean isAdmin = session != null ? (Boolean) session.getAttribute("isAdmin") : null;

        if (session == null || isAdmin == null || !isAdmin) {
            response.sendRedirect(request.getContextPath() + "/Dangnhap.jsp");
            return;
        }

        try {
            String tensp = request.getParameter("tensp");
            String giaStr = request.getParameter("gia");
            String phanloai = request.getParameter("phanloai");
            String thongtin = request.getParameter("thongtin");

            // Xá» lý file upload
            Part filePart = request.getPart("hinhanh");
            String hinhanh = "";

            if (filePart != null && filePart.getSize() > 0) {
                String fileName = filePart.getSubmittedFileName();
                if (fileName != null && !fileName.trim().isEmpty()) {
                    // LÆ°u file vÃ o thÆ° má»¥c uploads
                    String uploadPath = getServletContext().getRealPath("") + "uploads";
                    java.io.File uploadDir = new java.io.File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdir();
                    }

                    hinhanh = "uploads/" + fileName;
                    filePart.write(uploadPath + "/" + fileName);
                }
            }

            // Táº¡o Sanpham object
            Sanpham sanpham = new Sanpham();
            sanpham.setTensp(tensp);
            sanpham.setGia(Integer.parseInt(giaStr));
            sanpham.setPhanloai(phanloai);
            sanpham.setThongtin(thongtin);
            sanpham.setHinhanh(hinhanh);

            // LÆ°u vÃ o database
            SanphamDAO sanphamDAO = new SanphamDAO();
            boolean success = sanphamDAO.themSanpham(sanpham);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/products.jsp?success=1");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/add-product.jsp?error=1");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/add-product.jsp?error=1");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/admin/add-product.jsp");
    }
}
