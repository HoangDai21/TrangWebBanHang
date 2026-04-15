package Controller;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.stream.Collectors;

/**
 * Nhận mã code từ Facebook/Google, đổi token và tạo session đăng nhập.
 */
@WebServlet(name = "OAuthCallbackServlet", urlPatterns = {"/oauth/callback"})
public class OAuthCallbackServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String ctx = request.getContextPath();
        String err = request.getParameter("error");
        if (err != null && !err.isEmpty()) {
            response.sendRedirect(ctx + "/Dangnhap.jsp?oauth=cancel");
            return;
        }

        String code = request.getParameter("code");
        String state = request.getParameter("state");
        if (code == null || code.isEmpty() || state == null || state.isEmpty()) {
            response.sendRedirect(ctx + "/Dangnhap.jsp?oauth=invalid");
            return;
        }

        String base = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + ctx;
        String redirectUri = base + "/oauth/callback";

        ServletContext sc = getServletContext();

        try {
            if ("facebook".equalsIgnoreCase(state)) {
                handleFacebook(request, response, sc, code, redirectUri);
                return;
            }
            if ("google".equalsIgnoreCase(state)) {
                handleGoogle(request, response, sc, code, redirectUri);
                return;
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        response.sendRedirect(ctx + "/Dangnhap.jsp?oauth=fail");
    }

    private void handleFacebook(HttpServletRequest request, HttpServletResponse response,
            ServletContext sc, String code, String redirectUri) throws IOException {
        String ctx = request.getContextPath();
        String appId = nullToEmpty(sc.getInitParameter("oauth.facebook.app.id"));
        String secret = nullToEmpty(sc.getInitParameter("oauth.facebook.app.secret"));
        if (isPlaceholder(appId) || isPlaceholder(secret)) {
            response.sendRedirect(ctx + "/Dangnhap.jsp?oauth=need_config&p=facebook");
            return;
        }

        String tokenUrl = "https://graph.facebook.com/v18.0/oauth/access_token?client_id="
                + enc(appId) + "&redirect_uri=" + enc(redirectUri) + "&client_secret=" + enc(secret) + "&code=" + enc(code);
        String tokenJson = httpGet(tokenUrl);
        String accessToken = extractAccessToken(tokenJson);
        if (accessToken == null) {
            response.sendRedirect(ctx + "/Dangnhap.jsp?oauth=fail");
            return;
        }

        String meUrl = "https://graph.facebook.com/me?fields=id,name,email&access_token=" + enc(accessToken);
        String meJson = httpGet(meUrl);
        String id = extractJsonString(meJson, "id");
        String name = extractJsonString(meJson, "name");
        String email = extractJsonString(meJson, "email");

        Khachhang k = new Khachhang();
        k.setId(0);
        k.setTentaikhoan(name != null && !name.isEmpty() ? name : "Facebook");
        k.setTendangnhap(id != null ? "fb_" + id : "facebook_user");
        k.setGmail(email != null ? email : "");
        k.setSodt("");
        k.setDiachi("");
        k.setMatkhau("");

        HttpSession session = request.getSession(true);
        session.setAttribute("khachhang", k);
        session.setAttribute("oauth_provider", "facebook");
        response.sendRedirect(ctx + "/Trangchu.jsp");
    }

    private void handleGoogle(HttpServletRequest request, HttpServletResponse response,
            ServletContext sc, String code, String redirectUri) throws IOException {
        String ctx = request.getContextPath();
        String clientId = nullToEmpty(sc.getInitParameter("oauth.google.client.id"));
        String clientSecret = nullToEmpty(sc.getInitParameter("oauth.google.client.secret"));
        if (isPlaceholder(clientId) || isPlaceholder(clientSecret)) {
            response.sendRedirect(ctx + "/Dangnhap.jsp?oauth=need_config&p=google");
            return;
        }

        String postBody = "code=" + enc(code)
                + "&client_id=" + enc(clientId)
                + "&client_secret=" + enc(clientSecret)
                + "&redirect_uri=" + enc(redirectUri)
                + "&grant_type=authorization_code";

        String tokenJson = httpPostForm("https://oauth2.googleapis.com/token", postBody);
        String accessToken = extractAccessToken(tokenJson);
        if (accessToken == null) {
            response.sendRedirect(ctx + "/Dangnhap.jsp?oauth=fail");
            return;
        }

        String meJson = httpGetBearer("https://www.googleapis.com/oauth2/v3/userinfo", accessToken);
        String sub = extractJsonString(meJson, "sub");
        String name = extractJsonString(meJson, "name");
        String email = extractJsonString(meJson, "email");

        Khachhang k = new Khachhang();
        k.setId(0);
        k.setTentaikhoan(name != null && !name.isEmpty() ? name : "Google");
        k.setTendangnhap(sub != null ? "gg_" + sub : "google_user");
        k.setGmail(email != null ? email : "");
        k.setSodt("");
        k.setDiachi("");
        k.setMatkhau("");

        HttpSession session = request.getSession(true);
        session.setAttribute("khachhang", k);
        session.setAttribute("oauth_provider", "google");
        response.sendRedirect(ctx + "/Trangchu.jsp");
    }

    private static String httpGet(String urlStr) throws IOException {
        HttpURLConnection c = (HttpURLConnection) new URL(urlStr).openConnection();
        c.setRequestMethod("GET");
        c.setConnectTimeout(15000);
        c.setReadTimeout(15000);
        try {
            int code = c.getResponseCode();
            InputStream in = code >= 200 && code < 400 ? c.getInputStream() : c.getErrorStream();
            if (in == null) {
                return "";
            }
            return readAll(in);
        } finally {
            c.disconnect();
        }
    }

    private static String httpGetBearer(String urlStr, String bearer) throws IOException {
        HttpURLConnection c = (HttpURLConnection) new URL(urlStr).openConnection();
        c.setRequestMethod("GET");
        c.setRequestProperty("Authorization", "Bearer " + bearer);
        c.setConnectTimeout(15000);
        c.setReadTimeout(15000);
        try (InputStream in = c.getInputStream()) {
            return readAll(in);
        } finally {
            c.disconnect();
        }
    }

    private static String httpPostForm(String urlStr, String body) throws IOException {
        HttpURLConnection c = (HttpURLConnection) new URL(urlStr).openConnection();
        c.setRequestMethod("POST");
        c.setDoOutput(true);
        c.setRequestProperty("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
        c.setConnectTimeout(15000);
        c.setReadTimeout(15000);
        try (OutputStream os = c.getOutputStream()) {
            os.write(body.getBytes(StandardCharsets.UTF_8));
        }
        try {
            int code = c.getResponseCode();
            InputStream in = code >= 200 && code < 400 ? c.getInputStream() : c.getErrorStream();
            if (in == null) {
                return "";
            }
            return readAll(in);
        } finally {
            c.disconnect();
        }
    }

    private static String readAll(InputStream in) throws IOException {
        try (BufferedReader br = new BufferedReader(new InputStreamReader(in, StandardCharsets.UTF_8))) {
            return br.lines().collect(Collectors.joining("\n"));
        }
    }

    private static String extractAccessToken(String body) {
        if (body == null) {
            return null;
        }
        String at = extractJsonString(body, "access_token");
        if (at != null && !at.isEmpty()) {
            return at;
        }
        if (body.contains("access_token=")) {
            int start = body.indexOf("access_token=") + "access_token=".length();
            int end = body.indexOf('&', start);
            if (end < 0) {
                end = body.length();
            }
            return body.substring(start, end);
        }
        return null;
    }

    private static String extractJsonString(String json, String key) {
        if (json == null) {
            return null;
        }
        String look = "\"" + key + "\":\"";
        int i = json.indexOf(look);
        if (i < 0) {
            look = "\"" + key + "\": \"";
            i = json.indexOf(look);
            if (i < 0) {
                return null;
            }
        }
        int start = i + look.length();
        int end = json.indexOf('"', start);
        if (end <= start) {
            return null;
        }
        return json.substring(start, end);
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
