package Controller;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

/**
 * Bắt đầu luồng OAuth Facebook / Google. Cấu hình App ID / Secret trong WEB-INF/web.xml.
 */
@WebServlet(name = "OAuthLoginServlet", urlPatterns = {"/oauth/login"})
public class OAuthLoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String provider = request.getParameter("provider");
        if (provider == null) {
            response.sendRedirect(request.getContextPath() + "/Dangnhap.jsp?oauth=invalid");
            return;
        }

        String ctx = request.getContextPath();
        String base = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + ctx;
        String redirectUri = base + "/oauth/callback";

        ServletContext sc = getServletContext();

        if ("facebook".equalsIgnoreCase(provider)) {
            String appId = nullToEmpty(sc.getInitParameter("oauth.facebook.app.id"));
            if (isPlaceholder(appId)) {
                response.sendRedirect(ctx + "/Dangnhap.jsp?oauth=need_config&p=facebook");
                return;
            }
            String url = "https://www.facebook.com/v18.0/dialog/oauth?client_id=" + enc(appId)
                    + "&redirect_uri=" + enc(redirectUri)
                    + "&state=" + enc("facebook")
                    + "&scope=email,public_profile&response_type=code";
            response.sendRedirect(url);
            return;
        }

        if ("google".equalsIgnoreCase(provider)) {
            String clientId = nullToEmpty(sc.getInitParameter("oauth.google.client.id"));
            if (isPlaceholder(clientId)) {
                response.sendRedirect(ctx + "/Dangnhap.jsp?oauth=need_config&p=google");
                return;
            }
            String url = "https://accounts.google.com/o/oauth2/v2/auth?client_id=" + enc(clientId)
                    + "&redirect_uri=" + enc(redirectUri)
                    + "&response_type=code&scope=" + enc("openid email profile")
                    + "&state=" + enc("google")
                    + "&access_type=online&prompt=select_account";
            response.sendRedirect(url);
            return;
        }

        response.sendRedirect(ctx + "/Dangnhap.jsp?oauth=invalid");
    }

    private static String enc(String s) {
        return URLEncoder.encode(s, StandardCharsets.UTF_8);
    }

    private static String nullToEmpty(String s) {
        return s == null ? "" : s;
    }

    private static boolean isPlaceholder(String s) {
        String t = s.trim();
        return t.isEmpty() || t.startsWith("YOUR_");
    }
}
