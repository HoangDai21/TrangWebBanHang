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
        String sql = "SELECT masp, hinhanh, tensp, gia, thongtin, soluong, phanloai FROM tt_sanpham ORDER BY masp DESC";

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
                    sanpham.setSoluong(resultSet.getInt("soluong"));
                    sanpham.setPhanloai(resultSet.getString("phanloai"));
                    danhSachSanpham.add(sanpham);
                }
            }
        } catch (ClassNotFoundException | SQLException ex) {
            ex.printStackTrace();
        }

        return danhSachSanpham;
    }
    
    public Sanpham laySanphamTheoId(int masp) {
        String sql = "SELECT masp, hinhanh, tensp, gia, thongtin, soluong, phanloai FROM tt_sanpham WHERE masp = ?";
        
        try {
            Connection connection = Ketnoicsdl.ketnoi();
            if (connection == null) {
                return null;
            }

            try (Connection conn = connection;
                    PreparedStatement statement = conn.prepareStatement(sql)) {
                
                statement.setInt(1, masp);
                ResultSet resultSet = statement.executeQuery();
                
                if (resultSet.next()) {
                    Sanpham sanpham = new Sanpham();
                    sanpham.setMasp(resultSet.getInt("masp"));
                    sanpham.setHinhanh(resultSet.getString("hinhanh"));
                    sanpham.setTensp(resultSet.getString("tensp"));
                    sanpham.setGia(resultSet.getDouble("gia"));
                    sanpham.setThongtin(resultSet.getString("thongtin"));
                    sanpham.setSoluong(resultSet.getInt("soluong"));
                    sanpham.setPhanloai(resultSet.getString("phanloai"));
                    return sanpham;
                }
            }
        } catch (ClassNotFoundException | SQLException ex) {
            ex.printStackTrace();
        }
        
        return null;
    }
    
    public boolean themSanpham(Sanpham sanpham) {
        String sql = "INSERT INTO tt_sanpham (masp, hinhanh, tensp, gia, thongtin, soluong, phanloai) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try {
            Connection connection = Ketnoicsdl.ketnoi();
            if (connection == null) {
                return false;
            }

            try (Connection conn = connection;
                    PreparedStatement statement = conn.prepareStatement(sql)) {
                
                statement.setInt(1, sanpham.getMasp());
                statement.setString(2, sanpham.getHinhanh());
                statement.setString(3, sanpham.getTensp());
                statement.setDouble(4, sanpham.getGia());
                statement.setString(5, sanpham.getThongtin());
                statement.setInt(6, sanpham.getSoluong());
                statement.setString(7, sanpham.getPhanloai());
                
                int rowsAffected = statement.executeUpdate();
                return rowsAffected > 0;
            }
        } catch (ClassNotFoundException | SQLException ex) {
            ex.printStackTrace();
        }
        
        return false;
    }
    
    public boolean capNhatSanpham(Sanpham sanpham) {
        String sql = "UPDATE tt_sanpham SET hinhanh = ?, tensp = ?, gia = ?, thongtin = ?, soluong = ?, phanloai = ? WHERE masp = ?";
        
        try {
            Connection connection = Ketnoicsdl.ketnoi();
            if (connection == null) {
                return false;
            }

            try (Connection conn = connection;
                    PreparedStatement statement = conn.prepareStatement(sql)) {
                
                statement.setString(1, sanpham.getHinhanh());
                statement.setString(2, sanpham.getTensp());
                statement.setDouble(3, sanpham.getGia());
                statement.setString(4, sanpham.getThongtin());
                statement.setInt(5, sanpham.getSoluong());
                statement.setString(6, sanpham.getPhanloai());
                statement.setInt(7, sanpham.getMasp());
                
                int rowsAffected = statement.executeUpdate();
                return rowsAffected > 0;
            }
        } catch (ClassNotFoundException | SQLException ex) {
            ex.printStackTrace();
        }
        
        return false;
    }
    
    public boolean xoaSanpham(int masp) {
        String sql = "DELETE FROM tt_sanpham WHERE masp = ?";
        
        try {
            Connection connection = Ketnoicsdl.ketnoi();
            if (connection == null) {
                return false;
            }

            try (Connection conn = connection;
                    PreparedStatement statement = conn.prepareStatement(sql)) {
                
                statement.setInt(1, masp);
                
                int rowsAffected = statement.executeUpdate();
                return rowsAffected > 0;
            }
        } catch (ClassNotFoundException | SQLException ex) {
            ex.printStackTrace();
        }
        
        return false;
    }
}
