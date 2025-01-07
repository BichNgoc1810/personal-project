-- Khi có bản ghi mới thêm vào bảng HoaDon, cập nhật trạng thái phòng thành 'Trống'
CREATE TRIGGER TR_CAPNHAT_TINHTRANG_PHONG_1
ON DmHOADON
AFTER INSERT
AS
BEGIN
    UPDATE DmPhong
    SET TinhTrang = 'Trống'
    WHERE Ma IN (
        SELECT MaPhong
        FROM CtHOADON
        WHERE MaHoaDon = (SELECT Ma FROM INSERTED)
    );
END;


GO
-- Cập nhật trạng thái phòng thành 'Hết' sau khi có bản ghi được chèn vào ChiTietDatPhong
CREATE TRIGGER TR_CAPNHAT_TINHTRANG_PHONG_2
ON CtDATPHONG
AFTER INSERT
AS
BEGIN
    
    UPDATE DmPHONG
    SET DmPHONG.TinhTrang = N'Đã đặt'
    FROM DmPHONG
    INNER JOIN inserted ON DmPHONG.Ma = inserted.MaPhong;
END;

GO
-- Cập nhật số lượng tồn của tiện ích trong bảng DmTienIch khi có đơn đặt mới
CREATE TRIGGER TR_CAPNHAT_SOLUONGTON_1
ON CtDATTIENICH
AFTER INSERT
AS
BEGIN
    
    UPDATE DmTIENICH
    SET DmTIENICH.SLTon = DmTIENICH.SLTon - inserted.SL
    FROM DmTIENICH
    INNER JOIN inserted ON DmTIENICH.Ma = inserted.MaTienIch;
END;

GO
CREATE TRIGGER TR_CAPNHAT_SOLUONGTON_DELETE
ON CtDATTIENICH
AFTER DELETE
AS
BEGIN
    UPDATE DmTIENICH
    SET DmTIENICH.SLTon = DmTIENICH.SLTon + deleted.SL
    FROM DmTIENICH
    INNER JOIN deleted ON DmTIENICH.Ma = deleted.MaTienIch;
END;


GO
-- Cập nhật số lượng tồn của tiện ích trong bảng TienIch khi có phiếu nhập mới

CREATE TRIGGER TR_CAPNHAT_SOLUONGTON_2
ON CtPHIEUNHAPHANG
AFTER INSERT
AS
BEGIN

    UPDATE DmTIENICH
    SET DmTIENICH.SLTon = DmTIENICH.SLTon + inserted.SLNhap
    FROM DmTIENICH
	INNER JOIN inserted ON DmTIENICH.Ma = inserted.MaTienIch;
END;
