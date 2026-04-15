-- phpMyAdmin SQL Dump
-- CSDL: qlbanhang — bán hàng + đăng ký / đăng nhập khách hàng
-- MariaDB / MySQL, charset utf8mb4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `qlbanhang`
--
CREATE DATABASE IF NOT EXISTS `qlbanhang` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `qlbanhang`;

-- --------------------------------------------------------
-- Bảng chi tiết đơn hàng
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `chitietdonhang` (
  `madonhang` varchar(255) NOT NULL,
  `sanpham` varchar(255) NOT NULL,
  `soluong` int(11) NOT NULL,
  `thanhtien` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------
-- Bảng đơn hàng
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `tt_donhang` (
  `madon` varchar(255) NOT NULL,
  `soluong` int(11) NOT NULL,
  `thanhtien` double NOT NULL,
  `sanpham` varchar(255) NOT NULL,
  PRIMARY KEY (`madon`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------
-- Bảng khách hàng — dùng cho ĐĂNG KÝ / ĐĂNG NHẬP
-- tentaikhoan: họ tên hiển thị
-- tendangnhap: tên đăng nhập (duy nhất)
-- matkhau: mật khẩu (bài tập lưu dạng text; thực tế nên hash bcrypt/argon2)
-- --------------------------------------------------------
DROP TABLE IF EXISTS `tt_khachhang`;
CREATE TABLE `tt_khachhang` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tentaikhoan` varchar(255) NOT NULL COMMENT 'Họ tên / tên hiển thị',
  `tendangnhap` varchar(50) NOT NULL COMMENT 'Tên đăng nhập',
  `gmail` varchar(100) NOT NULL,
  `sodt` varchar(20) NOT NULL,
  `diachi` varchar(500) DEFAULT NULL,
  `matkhau` varchar(255) NOT NULL,
  `ngay_dang_ky` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tendangnhap` (`tendangnhap`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dữ liệu mẫu (đăng nhập: admin / password)
INSERT INTO `tt_khachhang` (`tentaikhoan`, `tendangnhap`, `gmail`, `sodt`, `diachi`, `matkhau`) VALUES
('Quản trị', 'admin', 'admin@gmail.com', '0900000000', 'Hà Nội', 'password');

-- --------------------------------------------------------
-- Bảng sản phẩm
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `tt_sanpham` (
  `masp` int(11) NOT NULL,
  `hinhanh` varchar(255) NOT NULL,
  `tensp` varchar(255) NOT NULL,
  `gia` double NOT NULL,
  `thongtin` varchar(500) NOT NULL,
  PRIMARY KEY (`masp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT IGNORE INTO `tt_sanpham` (`masp`, `hinhanh`, `tensp`, `gia`, `thongtin`) VALUES
(1, 'anhdep.png', 'ssd', 3000000, 'ssd1tb'),
(222, 'ram.png', 'ram 16GB DDR5 Bus 5200', 60000000, 'ram 16gb');

COMMIT;
