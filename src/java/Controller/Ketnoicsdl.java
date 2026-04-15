/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controller;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author HoangDai
 */
public class Ketnoicsdl {
    public static Connection ketnoi() throws ClassNotFoundException{
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection c = DriverManager.getConnection("jdbc:mysql://localhost:3306/qlbanhang","root","");
            return c;
        } catch (SQLException ex) {
            Logger.getLogger(Ketnoicsdl.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
        
    }
    public static void main(String[] args) throws ClassNotFoundException {
        Connection c = ketnoi();
        if(c!=null){
            System.out.println("connected");
        }else System.out.println("disconnected");
    }
}
