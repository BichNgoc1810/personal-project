CREATE PROCEDURE sp_UpdateTongTien
AS
BEGIN
    UPDATE DmCHIPHI
    SET TongTien = (
        SELECT SUM(CtPHIEUNHAPHANG.SLNhap * CtPHIEUNHAPHANG.DonGia)
        FROM CtPHIEUNHAPHANG
        WHERE CtPHIEUNHAPHANG.MaPhieuNhap = DmCHIPHI.MaPhieuNhap
        GROUP BY CtPHIEUNHAPHANG.MaPhieuNhap
    )
    WHERE EXISTS (
        SELECT 1
        FROM CtPHIEUNHAPHANG
        WHERE CtPHIEUNHAPHANG.MaPhieuNhap = DmCHIPHI.MaPhieuNhap
    );
END



IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_GetDoanhThu')
BEGIN
    DROP PROCEDURE sp_GetDoanhThu;
END;

CREATE PROCEDURE sp_GetDoanhThu
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SELECT  
        DmDOANHTHU.NgayGhiNhan,
        SUM(CtDATPHONG.SLPhong * DmGIAPHONG.Gia) AS [DoanhThuPhong],
        SUM(CtDATTIENICH.SL * DmTIENICH.GiaTienIch) AS [DoanhThuTiệnIch],
        SUM(CtDATPHONG.SLPhong * DmGIAPHONG.Gia) + SUM(CtDATTIENICH.SL * DmTIENICH.GiaTienIch) AS [TongDoanhThu]
    FROM DmDOANHTHU
    JOIN DmHOADON ON DmDOANHTHU.MaHoaDon = DmHOADON.Ma
    JOIN CtHOADON ON CtHOADON.MaHoaDon = DmHOADON.Ma
    JOIN CtDATPHONG ON CtDATPHONG.MaPhong = CtHoaDon.MaPhong
    JOIN DmPHONG ON CtDATPHONG.MaPhong = DmPHONG.Ma
    JOIN DmGIAPHONG ON DmPHONG.MaLoaiPhong = DmGIAPHONG.MaLoaiPhong
    JOIN CtDATTIENICH ON CtDATTIENICH.MaKhachHang = CtDATPHONG.MaKhachHang
    JOIN DmTIENICH ON CtDATTIENICH.MaTienIch = DmTIENICH.Ma
    WHERE DmDOANHTHU.NgayGhiNhan >= @StartDate 
      AND DmDOANHTHU.NgayGhiNhan <= @EndDate
    GROUP BY DmDOANHTHU.NgayGhiNhan;
END;


EXEC sp_GetDoanhThu '2024-01-01', '2024-12-31';

CREATE PROCEDURE sp_GetChiPhi
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SELECT 
        lc.TenLoaiCP,  -- Lấy tên loại chi phí
        SUM(dc.TongTien) AS TongChiPhi  -- Tổng chi phí theo loại
    FROM 
        DmCHIPHI dc
    INNER JOIN 
        DmLOAICHIPHI lc ON dc.MaLoaiChiPhi = lc.Ma  -- Kết nối bảng DmCHIPHI và LoaiChiPhi
    WHERE 
        dc.NgayGhiNhan BETWEEN @StartDate AND @EndDate  -- Lọc theo khoảng thời gian
    GROUP BY 
        lc.TenLoaiCP  -- Nhóm theo tên loại chi phí
END


EXEC sp_GetChiPhi'2024-01-01', '2024-1-31';



CREATE PROCEDURE sp_XuatHoaDon


select hd.Ma as [Mã Hóa Đơn], hd.NgayLap as [Ngày lập], nv.HoTenNV as [Người Lập], kh.HoTenKH as [Họ Tên Khách Hàng], 
		p.TenPhong as [Phòng], ti.TenTienIch as [Tiện Ích], ctdp.NgayKT - ctdp.NgayBD as [Số Ngày]*Gia,

from DmHOADON hd JOIN CtHOADON cthd ON hd.Ma=cthd.MaHoaDon
JOIN CtDATPHONG ctdp ON cthd.MaPhong=ctdp.MaPhong
JOIN CtDATTIENICH ctdti ON cthd.MaTienIch=ctdti.MaTienIch
JOIN DmKHACHHANG kh ON hd.MaKhachHang=kh.Ma
JOIN DmNHANVIEN nv ON hd.MaNhanVien=nv.Ma
JOIN DmPHONG p ON cthd.MaPhong=p.Ma
JOIN DmTIENICH ti ON cthd.MaTienIch=ti.Ma
JOIN DmGIAPHONG gp ON p.MaLoaiPhong=gp.MaLoaiPhong
WHERE hd.MaKhachHang like '%KH001%'
GROUP BY MaLoaiPhong












SELECT 
    hd.Ma AS [Mã Hóa Đơn], 
    hd.NgayLap AS [Ngày lập], 
    nv.HoTenNV AS [Người Lập], 
    kh.HoTenKH AS [Họ Tên Khách Hàng], 
	ctdp.MaPhong,ctdti.MaTienIch,
    p.TenPhong AS [Phòng], 
    ti.TenTienIch AS [Tiện Ích], 
    DATEDIFF(DAY, ctdp.NgayBD, ctdp.NgayKT) AS [Số Ngày],
    DATEDIFF(DAY, ctdp.NgayBD, ctdp.NgayKT) * gp.Gia AS [Tiền Phòng],
	ctdti.SL* ti.GiaTienIch AS [Tiền Tiện Ích]  
FROM 
    DmHOADON hd
JOIN 
    CtHOADON cthd ON hd.Ma = cthd.MaHoaDon
JOIN 
    CtDATPHONG ctdp ON cthd.MaPhong = ctdp.MaPhong
JOIN 
    CtDATTIENICH ctdti ON cthd.MaTienIch = ctdti.MaTienIch
JOIN 
    DmKHACHHANG kh ON hd.MaKhachHang = kh.Ma
JOIN 
    DmNHANVIEN nv ON hd.MaNhanVien = nv.Ma
JOIN 
    DmPHONG p ON cthd.MaPhong = p.Ma
JOIN 
    DmTIENICH ti ON cthd.MaTienIch = ti.Ma
JOIN 
    DmGIAPHONG gp ON p.MaLoaiPhong = gp.MaLoaiPhong
WHERE 
    hd.MaKhachHang LIKE '%KH005%' AND  ctdti.NgaySD BETWEEN ctdp.NgayBD AND ctdp.NgayKT
GROUP BY 
    hd.Ma, hd.NgayLap, nv.HoTenNV, kh.HoTenKH, p.TenPhong, ti.TenTienIch, ctdp.NgayBD, ctdp.NgayKT, gp.Gia, ti.GiaTienIch,ctdti.SL,ctdti.MaTienIch, ctdp.MaPhong



	select TenPhong,DATEDIFF(DAY,NgayBD, NgayKT) * Gia AS [Tiền Phòng],TenTienIch,  SL*GiaTienIch as[Tiền Tiện Ích]
	from CtDATPHONG JOIN CtDATTIENICH ON CtDATPHONG.MaKhachHang=CtDATTIENICH.MaKhachHang
		join DmPHONG ON CtDATPHONG.MaPhong=DmPHONG.Ma join DmGIAPHONG ON DmGIAPHONG.MaLoaiPhong= DmPHONG.MaLoaiPhong
		join DmTIENICH ON DmTIENICH.Ma=CtDATTIENICH.MaTienIch
		join DmKHACHHANG On DmKHACHHANG.Ma=CtDATPHONG.MaKhachHang
	where CtDATPHONG.MaKhachHang='KH005' AND  CtDATTIENICH.NgaySD BETWEEN CtDATPHONG.NgayBD AND CtDATPHONG.NgayKT
	
	select DmHOADON.Ma,DmHOADON.NgayLap,HoTenNV
	from  DmHOADON Join CtHOADON on DmHOADON.Ma=CtHOADON.MaHoaDon Join DmNHANVIEN on DmHOADON.MaNhanVien=DmNHANVIEN.Ma
	where DmHOADON.MaKhachHang='KH005' 


	IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'GetInvoiceDetailsForCustomer')
BEGIN
    DROP PROCEDURE GetInvoiceDetailsForCustomer;
END;
/*
CREATE PROCEDURE GetInvoiceDetailsForCustomer
    @MaKhachHang NVARCHAR(50)
AS
BEGIN
    SELECT 
        hd.Ma AS MaHoaDon,
        nv.HoTenNV AS NhanVienLap,
        hd.NgayLap AS NgayLapHoaDon,
        kh.HoTenKH AS TenKhachHang,
        ph.TenPhong AS TenPhong,
        ti.TenTienIch AS TenTienIch,
        dp.SLPhong,
        di.SL AS SoLuongTienIch,
        gp.Gia AS GiaPhong,
        ti.GiaTienIch,
        DATEDIFF(DAY, dp.NgayBD, dp.NgayKT) AS [SoNgay],
        DATEDIFF(DAY, dp.NgayBD, dp.NgayKT) * gp.Gia AS [TienPhong],
        di.SL * ti.GiaTienIch AS [TienTienIch]
    FROM 
        DmHOADON hd
    JOIN 
        DmNHANVIEN nv ON hd.MaNhanVien = nv.Ma
    JOIN 
        DmKHACHHANG kh ON hd.MaKhachHang = kh.Ma
    JOIN 
        CtDATPHONG dp ON dp.MaKhachHang = kh.Ma
    JOIN 
        CtDATTIENICH di ON di.MaKhachHang = kh.Ma
    JOIN 
        DmPHONG ph ON dp.MaPhong = ph.Ma
    JOIN 
        DmGIAPHONG gp ON ph.MaLoaiPhong = gp.MaLoaiPhong
    JOIN 
        DmTIENICH ti ON di.MaTienIch = ti.Ma
    WHERE 
        kh.Ma = @MaKhachHang
        AND di.NgaySD BETWEEN dp.NgayBD AND dp.NgayKT
END;
*/


    
CREATE PROCEDURE GetInvoiceDetailsForCustomer
    @MaKhachHang NVARCHAR(50)
AS
BEGIN
    SELECT 
    hd.Ma AS MaHoaDon,
    nv.HoTenNV AS NhanVienLap,
    hd.NgayLap AS NgayLapHoaDon,
    kh.HoTenKH AS TenKhachHang,
    ph.TenPhong AS TenPhong,
    SUM(dp.SLPhong) AS SLPhong,
    ti.TenTienIch AS TenTienIch,
    SUM(di.SL) AS SoLuongTienIch,
    gp.Gia AS GiaPhong,
    ti.GiaTienIch,
    DATEDIFF(DAY, dp.NgayBD, dp.NgayKT) AS [SoNgay],
    SUM(DATEDIFF(DAY, dp.NgayBD, dp.NgayKT) * gp.Gia) AS [TienPhong],
    SUM(di.SL * ti.GiaTienIch) AS [TienTienIch]

FROM 
    DmHOADON hd
JOIN 
    DmNHANVIEN nv ON hd.MaNhanVien = nv.Ma
JOIN 
    DmKHACHHANG kh ON hd.MaKhachHang = kh.Ma
JOIN 
    CtDATPHONG dp ON dp.MaKhachHang = kh.Ma
JOIN 
    CtDATTIENICH di ON di.MaKhachHang = kh.Ma
JOIN 
    DmPHONG ph ON dp.MaPhong = ph.Ma
JOIN 
    DmGIAPHONG gp ON ph.MaLoaiPhong = gp.MaLoaiPhong
JOIN 
    DmTIENICH ti ON di.MaTienIch = ti.Ma
WHERE 
    kh.Ma = @MaKhachHang
    AND di.NgaySD BETWEEN dp.NgayBD AND dp.NgayKT
GROUP BY
    hd.Ma, nv.HoTenNV, hd.NgayLap, kh.HoTenKH, ph.TenPhong, ti.TenTienIch, gp.Gia, ti.GiaTienIch, dp.NgayBD, dp.NgayKT;

END;

