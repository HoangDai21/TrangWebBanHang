package Controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/*")
public class AdminServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Khachhang khachhang = null;

        if (session != null) {
            khachhang = (Khachhang) session.getAttribute("khachhang");
        }

        // Kiêmr tra xem co phai admin va mat khau dung khong
        if (khachhang != null && isAdmin(khachhang)) {
            // Set admin session attribute
            session.setAttribute("isAdmin", true);

            // Forward to trang admin
            String path = request.getPathInfo();
            if (path == null || path.equals("/")) {
                request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
            } else if (path.equals("/products")) {
                request.getRequestDispatcher("/admin/products.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/Trangchu.jsp");
            }
        } else {
            // Khong phai admin, chuyen ve trang chu
            response.sendRedirect(request.getContextPath() + "/Trangchu.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if ("admin".equals(username) && "password".equals(password)) {
            // Tao session admin
            HttpSession session = request.getSession();
            session.setAttribute("isAdmin", true);

            // Tao khachhang object cho admin
            Khachhang admin = new Khachhang();
            admin.setTendangnhap("admin");
            admin.setTentaikhoan("Admin");
            session.setAttribute("khachhang", admin);

            response.sendRedirect(request.getContextPath() + "/admin/");
        } else {
            response.sendRedirect(request.getContextPath() + "/Dangnhap.jsp?error=1");
        }
    }

    private boolean isAdmin(Khachhang khachhang) {
        if (khachhang == null) {
            return false;
        }

        if (khachhang.getId() == 1) {
            return true;
        }

        String tendangnhap = khachhang.getTendangnhap();
        return tendangnhap != null && tendangnhap.equalsIgnoreCase("admin");
    }
}
