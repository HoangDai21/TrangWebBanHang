/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controller;

/**
 *
 * @author HoangDai
 */
public class Sanpham {
    private int masp;
    private String hinhanh;
    private String tensp;
    private double gia;
    private String thongtin;
    private int soluong;
    private String phanloai;

    public Sanpham() {
    }

    public Sanpham(int masp, String hinhanh, String tensp, double gia, String thongtin, int soluong, String phanloai) {
        this.masp = masp;
        this.hinhanh = hinhanh;
        this.tensp = tensp;
        this.gia = gia;
        this.thongtin = thongtin;
        this.soluong = soluong;
        this.phanloai = phanloai;
    }

    public int getMasp() {
        return masp;
    }

    public void setMasp(int masp) {
        this.masp = masp;
    }

    public String getHinhanh() {
        return hinhanh;
    }

    public void setHinhanh(String hinhanh) {
        this.hinhanh = hinhanh;
    }

    public String getTensp() {
        return tensp;
    }

    public void setTensp(String tensp) {
        this.tensp = tensp;
    }

    public double getGia() {
        return gia;
    }

    public void setGia(double gia) {
        this.gia = gia;
    }

    public String getThongtin() {
        return thongtin;
    }

    public void setThongtin(String thongtin) {
        this.thongtin = thongtin;
    }

    public int getSoluong() {
        return soluong;
    }

    public void setSoluong(int soluong) {
        this.soluong = soluong;
    }

    public String getPhanloai() {
        return phanloai;
    }

    public void setPhanloai(String phanloai) {
        this.phanloai = phanloai;
    }
    
}
