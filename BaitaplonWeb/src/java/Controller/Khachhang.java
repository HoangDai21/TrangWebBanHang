/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controller;

/**
 *
 * @author HoangDai
 */
public class Khachhang {
    private int id;
    private String tentaikhoan;
    private String tendangnhap;
    private String gmail;
    private String sodt;
    private String diachi;
    private String matkhau;

    public Khachhang() {
    }

    public Khachhang(int id, String tentaikhoan, String tendangnhap, String gmail, String sodt, String diachi, String matkhau) {
        this.id = id;
        this.tentaikhoan = tentaikhoan;
        this.tendangnhap = tendangnhap;
        this.gmail = gmail;
        this.sodt = sodt;
        this.diachi = diachi;
        this.matkhau = matkhau;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTentaikhoan() {
        return tentaikhoan;
    }

    public void setTentaikhoan(String tentaikhoan) {
        this.tentaikhoan = tentaikhoan;
    }

    public String getTendangnhap() {
        return tendangnhap;
    }

    public void setTendangnhap(String tendangnhap) {
        this.tendangnhap = tendangnhap;
    }

    public String getGmail() {
        return gmail;
    }

    public void setGmail(String gmail) {
        this.gmail = gmail;
    }

    public String getSodt() {
        return sodt;
    }

    public void setSodt(String sodt) {
        this.sodt = sodt;
    }

    public String getDiachi() {
        return diachi;
    }

    public void setDiachi(String diachi) {
        this.diachi = diachi;
    }

    public String getMatkhau() {
        return matkhau;
    }

    public void setMatkhau(String matkhau) {
        this.matkhau = matkhau;
    }

}
