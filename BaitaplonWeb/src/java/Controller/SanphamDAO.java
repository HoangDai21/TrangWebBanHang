/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controller;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author HoangDai
 */
public class SanphamDAO {

    public List<Sanpham> layTatCaSanpham() {
        List<Sanpham> danhSachSanpham = new ArrayList<>();
        String sql = "SELECT masp, hinhanh, tensp, gia, thongtin FROM tt_sanpham ORDER BY masp DESC";

        try {
            Connection connection = Ketnoicsdl.ketnoi();
            if (connection == null) {
                return danhSachSanpham;
            }

            try (Connection conn = connection;
                    PreparedStatement statement = conn.prepareStatement(sql);
                    ResultSet resultSet = statement.executeQuery()) {

                while (resultSet.next()) {
                    Sanpham sanpham = new Sanpham();
                    sanpham.setMasp(resultSet.getInt("masp"));
                    sanpham.setHinhanh(resultSet.getString("hinhanh"));
                    sanpham.setTensp(resultSet.getString("tensp"));
                    sanpham.setGia(resultSet.getDouble("gia"));
                    sanpham.setThongtin(resultSet.getString("thongtin"));
                    danhSachSanpham.add(sanpham);
                }
            }
        } catch (ClassNotFoundException | SQLException ex) {
            ex.printStackTrace();
        }

        return danhSachSanpham;
    }
}
