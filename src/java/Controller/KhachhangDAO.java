package Controller;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class KhachhangDAO {

    /** true nếu tên đăng nhập đã tồn tại */
    public boolean tonTaiTenDangNhap(String tendangnhap) {
        String sql = "SELECT 1 FROM tt_khachhang WHERE tendangnhap = ? LIMIT 1";
        try {
            Connection connection = Ketnoicsdl.ketnoi();
            if (connection == null) {
                return false;
            }
            try (Connection conn = connection;
                    PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, tendangnhap.trim());
                try (ResultSet rs = ps.executeQuery()) {
                    return rs.next();
                }
            }
        } catch (ClassNotFoundException | SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }

    /** Đăng ký: 1 = thành công, 0 = trùng tài khoản, -1 = lỗi */
    public int dangKy(Khachhang k) {
        if (k == null || k.getTendangnhap() == null || k.getTendangnhap().trim().isEmpty()) {
            return -1;
        }
        if (tonTaiTenDangNhap(k.getTendangnhap())) {
            return 0;
        }
        String sql = "INSERT INTO tt_khachhang (tentaikhoan, tendangnhap, gmail, sodt, diachi, matkhau) VALUES (?,?,?,?,?,?)";
        try {
            Connection connection = Ketnoicsdl.ketnoi();
            if (connection == null) {
                return -1;
            }
            try (Connection conn = connection;
                    PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, nullToEmpty(k.getTentaikhoan()));
                ps.setString(2, k.getTendangnhap().trim());
                ps.setString(3, nullToEmpty(k.getGmail()));
                ps.setString(4, nullToEmpty(k.getSodt()));
                ps.setString(5, nullToEmpty(k.getDiachi()));
                ps.setString(6, nullToEmpty(k.getMatkhau()));
                return ps.executeUpdate() > 0 ? 1 : -1;
            }
        } catch (ClassNotFoundException | SQLException ex) {
            ex.printStackTrace();
            return -1;
        }
    }

    /**
     * Đăng nhập bằng email (cột gmail) hoặc tên đăng nhập.
     */
    public Khachhang dangNhapBangEmailHoacTenDangNhap(String emailHoacTen, String matkhau) {
        if (emailHoacTen == null || matkhau == null) {
            return null;
        }
        String login = emailHoacTen.trim();
        if (login.isEmpty()) {
            return null;
        }
        String sql = "SELECT id, tentaikhoan, tendangnhap, gmail, sodt, diachi, matkhau FROM tt_khachhang "
                + "WHERE (LOWER(gmail) = LOWER(?) OR tendangnhap = ?) AND matkhau = ? LIMIT 1";
        try {
            Connection connection = Ketnoicsdl.ketnoi();
            if (connection == null) {
                return null;
            }
            try (Connection conn = connection;
                    PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, login);
                ps.setString(2, login);
                ps.setString(3, matkhau);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        return null;
                    }
                    return mapKhachhang(rs);
                }
            }
        } catch (ClassNotFoundException | SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    /** Đăng nhập: null nếu sai hoặc lỗi */
    public Khachhang dangNhap(String tendangnhap, String matkhau) {
        if (tendangnhap == null || matkhau == null) {
            return null;
        }
        String sql = "SELECT id, tentaikhoan, tendangnhap, gmail, sodt, diachi, matkhau FROM tt_khachhang WHERE tendangnhap = ? AND matkhau = ? LIMIT 1";
        try {
            Connection connection = Ketnoicsdl.ketnoi();
            if (connection == null) {
                return null;
            }
            try (Connection conn = connection;
                    PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, tendangnhap.trim());
                ps.setString(2, matkhau);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        return null;
                    }
                    return mapKhachhang(rs);
                }
            }
        } catch (ClassNotFoundException | SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    /** Tìm khách hàng theo gmail hoặc số điện thoại (để quên mật khẩu) */
    public Khachhang timTheoGmailHoacSdt(String gmailHoacSdt) {
        if (gmailHoacSdt == null) {
            return null;
        }
        String key = gmailHoacSdt.trim();
        if (key.isEmpty()) {
            return null;
        }
        String sql = "SELECT id, tentaikhoan, tendangnhap, gmail, sodt, diachi, matkhau FROM tt_khachhang "
                + "WHERE LOWER(gmail) = LOWER(?) OR sodt = ? LIMIT 1";
        try {
            Connection connection = Ketnoicsdl.ketnoi();
            if (connection == null) {
                return null;
            }
            try (Connection conn = connection;
                    PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, key);
                ps.setString(2, key);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        return null;
                    }
                    return mapKhachhang(rs);
                }
            }
        } catch (ClassNotFoundException | SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    /** Đổi mật khẩu theo id: true nếu cập nhật thành công */
    public boolean capNhatMatKhau(int id, String matkhauMoi) {
        if (id <= 0 || matkhauMoi == null) {
            return false;
        }
        String sql = "UPDATE tt_khachhang SET matkhau = ? WHERE id = ? LIMIT 1";
        try {
            Connection connection = Ketnoicsdl.ketnoi();
            if (connection == null) {
                return false;
            }
            try (Connection conn = connection;
                    PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, matkhauMoi);
                ps.setInt(2, id);
                return ps.executeUpdate() > 0;
            }
        } catch (ClassNotFoundException | SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }

    private static Khachhang mapKhachhang(ResultSet rs) throws SQLException {
        Khachhang k = new Khachhang();
        k.setId(rs.getInt("id"));
        k.setTentaikhoan(rs.getString("tentaikhoan"));
        k.setTendangnhap(rs.getString("tendangnhap"));
        k.setGmail(rs.getString("gmail"));
        k.setSodt(rs.getString("sodt"));
        k.setDiachi(rs.getString("diachi"));
        k.setMatkhau(rs.getString("matkhau"));
        return k;
    }

    private static String nullToEmpty(String s) {
        return s == null ? "" : s;
    }
}
