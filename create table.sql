CREATE DATABASE QUANLYKHACHSAN
GO

USE QUANLYKHACHSAN
GO


CREATE TABLE DmKHACHHANG
(	Ma nchar(6) primary key,
	HoTenKH nvarchar(150) not null,
	DiaChi nvarchar(150) not null,
	SDT nchar(10) not null,
	Email nvarchar(100) null,
	GhiChu nvarchar(150) null
)
GO

CREATE TABLE DmLOAIPHONG
(
	Ma nchar(6) primary key,
	TenLoaiPhong nvarchar(150) not null,
	GhiChu nvarchar(150) null
)
GO

CREATE TABLE DmPHONG
(
	Ma nchar(6) primary key,
	MaLoaiPhong nchar(6) not null,
	TenPhong nvarchar(150) not null,
	TinhTrang nvarchar(150) not null,
	GhiChu nvarchar(150) null,
	 CONSTRAINT FK_DmPHONG_MaLoaiPhong
	 FOREIGN KEY (MaLoaiPhong)
	 REFERENCES DmLOAIPHONG (Ma)
)
GO

CREATE TABLE DmGIAPHONG
(
	Ma nchar(6) primary key,
	MaLoaiPhong nchar(6) not null,
	NgayApDung datetime2 not null,
	Gia float not null,
	GhiChu nvarchar(150) null,
	 CONSTRAINT FK_DmGIAPHONG_MaLoaiPhong
	 FOREIGN KEY (MaLoaiPhong)
	 REFERENCES DmLOAIPHONG (Ma)
)
GO

CREATE TABLE DmPHONGBAN
(
	Ma nchar(6) primary key,
	TenPhongBan nvarchar(150) not null,
	GhiChu nvarchar(150) not null
)
GO

CREATE TABLE DmCHUCVU
(
	Ma nchar(6) primary key,
	TenChucVu nvarchar(100) not null,
	GhiChu nvarchar(150) null
)
GO

CREATE TABLE DmNHANVIEN
(
	Ma nchar(6) primary key,
	MaPhongBan nchar(6) not null,
	MaChucVu nchar(6) not null,
	HoTenNV nvarchar(150) not null,
	GioiTinh nvarchar(6) not null,
	NgaySinh datetime2 not null,
	SDT nchar(10) null,
	Email nvarchar(100) null,
	DiaChi nvarchar(150) null,
	CONSTRAINT FK_DmNHANVIEN_MaPhongBan
	 FOREIGN KEY (MaPhongBan)
	 REFERENCES DmPHONGBAN (Ma),
	CONSTRAINT FK_DmNHANVIEN_MaChucVu
	 FOREIGN KEY (MaChucVu)
	 REFERENCES DmCHUCVU (Ma)
)
GO

CREATE TABLE DmTAIKHOAN
(
	Username nvarchar(100) primary key,
	Password nvarchar(10) not null,
	MaNhanVien nchar(6) not null,
	CONSTRAINT FK_DmTAIKHOAN_MaNhanVien
	 FOREIGN KEY (MaNhanVien)
	 REFERENCES DmNHANVIEN (Ma)
)
GO

CREATE TABLE DmNHACUNGCAP
(
	Ma nchar(6) primary key,
	TenNhaCungCap nvarchar(150) not null,
	DiaChi nvarchar(150) null,
	SDT nchar(10) null,
	GhiChu nvarchar(150) null
)
GO

CREATE TABLE DmLOAITIENICH
(
	Ma nchar(6) primary key,
	TenLoaiTienIch nvarchar(150) not null,
	Ghichu nvarchar(150)
)
GO


CREATE TABLE DmTIENICH
(
	Ma nchar(6) primary key,
	MaLoaiTienIch nchar(6) not null,
	MaNhaCungCap nchar(6) not null,
	TenTienIch nvarchar(150) not null,
	GiaTienIch float,
	SLTon int,
	TinhTrang nvarchar(150),
	GhiChu nvarchar(150),
	CONSTRAINT FK_DmTIENICH_MaLoaiTienIch
	 FOREIGN KEY (MaLoaiTienIch)
	 REFERENCES DmLOAITIENICH(Ma),
	CONSTRAINT FK_DmTIENICH_MaNhaCungCap
	 FOREIGN KEY (MaNhaCungCap)
	 REFERENCES DmNHACUNGCAP(Ma)
)
GO


CREATE TABLE DmLOAIDOANHTHU
(
	Ma nchar(6) primary key, 
	TenLoaiDT nvarchar(150) not null, 
	GhiChu nvarchar(150)
)
GO

CREATE TABLE DmDOANHTHU
(
	Ma nchar(6) not null, 
	MaLoaiDoanhThu nchar(6) not null, 
	MaHoaDon nchar(6) not null,
	NgayGhiNhan datetime2, 
	GhiChu nvarchar(150),
		CONSTRAINT PK_DmDOANHTHU PRIMARY KEY (Ma,MaLoaiDoanhThu,MaHoaDon),
	CONSTRAINT FK_DmDOANHTHU_MaLoaiDoanhThu
	 FOREIGN KEY (MaLoaiDoanhThu)
	 REFERENCES DmLOAIDOANHTHU(Ma),
	 CONSTRAINT FK_DmDOANHTHU_MaHoaDon FOREIGN KEY (MaHoaDon)
		REFERENCES DmHOADON (Ma)
)
GO


CREATE TABLE DmLOAICHIPHI
(
	Ma nchar(6) primary key,
	TenLoaiCP nvarchar(150) not null,
	GhiChu nvarchar(150)
)
GO




CREATE TABLE DmPHIEUNHAPHANG
(
	Ma nchar(6) primary key,
	MaNhanVien nchar(6) not null,
	NgayNhap datetime2 null,
	GhiChu nvarchar(150) null,
	CONSTRAINT FK_DmPHIEUNHAPHANG_MaNhanVien
	 FOREIGN KEY (MaNhanVien)
	 REFERENCES DmNHANVIEN (Ma)  
)
GO


CREATE TABLE DmCHIPHI
(
	Ma nchar(6) primary key,
	MaLoaiChiPhi nchar(6) not null,
	MaPhieuNhap nchar(6)  null,
	NgayGhiNhan datetime2,
	GhiChu nvarchar(150),
	CONSTRAINT FK_DmCHIPHI_MaLoaiChiPhi
	 FOREIGN KEY (MaLoaiChiPhi)
	 REFERENCES DmLOAICHIPHI(Ma)
)
GO

CREATE TABLE DmHOADON
(
    Ma nchar(6) PRIMARY KEY,
    MaKhachHang nchar(6) NOT NULL,
    MaNhanVien nchar(6) NOT NULL,
    NgayLap datetime2 NULL,
    GhiChu nvarchar(150) NULL,
    CONSTRAINT FK_DmHOADON_MaNhanVien
        FOREIGN KEY (MaNhanVien)
        REFERENCES DmNHANVIEN (Ma),
    CONSTRAINT FK_DmHOADON_MaKhachHang
        FOREIGN KEY (MaKhachHang)
        REFERENCES DmKHACHHANG (Ma)
);
GO


CREATE TABLE CtDATPHONG
(
	MaKhachHang nchar(6) not null,
	MaPhong nchar(6) not null,
	SLPhong int not null,
	NgayBD datetime2 not null,
	NgayKT datetime2 not null,
	CONSTRAINT PK_CtDATPHONG PRIMARY KEY (MaKhachHang,MaPhong),
	CONSTRAINT FK_CtDATPHONG_MaKhachHang
	 FOREIGN KEY (MaKhachHang)
	 REFERENCES DmKHACHHANG(Ma),
	CONSTRAINT FK_CtDATPHONG_MaPhong
	 FOREIGN KEY (MaPhong)
	 REFERENCES DmPHONG(Ma)
)
GO


CREATE TABLE CtDATTIENICH
(
	MaKhachHang nchar(6) not null,
	MaTienIch nchar(6) not null,
	SL int not null,
	NgaySD datetime2 not null,
	CONSTRAINT PK_CtDATTIENICH PRIMARY KEY (MaKhachHang,MaTienIch),
	CONSTRAINT FK_CtDATTIENICH_MaKhachHang
	 FOREIGN KEY (MaKhachHang)
	 REFERENCES DmKHACHHANG(Ma),
	CONSTRAINT FK_CtDATTIENICH_MaTienIch
	 FOREIGN KEY (MaTienIch)
	 REFERENCES DmTIENICH(Ma)
)
GO



CREATE TABLE CtHOADON
(
	MaHoaDon nchar(6) not null,
	MaPhong nchar(6) not null,
	MaTienIch nchar(6) not null,
	CONSTRAINT FK_CtHOADON_MaHoaDon
	 FOREIGN KEY (MaHoaDon)
	 REFERENCES DmHOADON (Ma),
	CONSTRAINT FK_CtHOADON_MaPhong
	 FOREIGN KEY (MaPhong)
	 REFERENCES DmPhong(Ma),
	CONSTRAINT FK_CtHOADON_MaTienIch
	 FOREIGN KEY (MaTienIch)
	 REFERENCES DmTIENICH (Ma)
)
GO

CREATE TABLE CtPHIEUNHAPHANG
(
	MaPhieuNhap nchar(6) not null,
	MaTienIch nchar(6) not null,
	SLNhap int not null,
	DonGia float not null,
	CONSTRAINT PK_CtPHIEUNHAPHANG PRIMARY KEY (MaPhieuNhap,MaTienIch),
	CONSTRAINT FK_CtPHIEUNHAPHANG_MaPhieuNhap
	 FOREIGN KEY (MaPhieuNhap)
	 REFERENCES DmPHIEUNHAPHANG(Ma),
	CONSTRAINT FK_CtPHIEUNHAPHANG_MaTienIch
	 FOREIGN KEY (MaTienIch)
	 REFERENCES DmTIENICH (Ma)
)
GO



