ALTER TABLE DmPhong
ADD CONSTRAINT chk_TinhTrang
CHECK (TinhTrang IN ('Trống', 'Đã đặt', 'Bảo trì'));





ALTER TABLE DmKhachHang
ADD CONSTRAINT CK_SDT_Length
CHECK (LEN(SDT) = 10 AND SDT NOT LIKE '%[^0-9]%');


ALTER TABLE DmGiaPhong
ADD CONSTRAINT CK_GiaPhong
CHECK (Gia > 0);


ALTER TABLE DmTienIch
ADD CONSTRAINT CK_SoLuongTon
CHECK (SLTon >= 0);

ALTER TABLE DmNhanVien
ADD CONSTRAINT CK_GioiTinh
CHECK (GioiTinh IN ('Nam', 'Nữ'));


ALTER TABLE CtDatPhong
ADD CONSTRAINT CK_SoLuongPhong
CHECK (SLPhong > 0);


ALTER TABLE CtDatPhong
ADD CONSTRAINT CK_NgayKetThuc
CHECK (NgayKT >= NgayBD);


ALTER TABLE CtDatTienIch
ADD CONSTRAINT CK_SoLuongTienIch
CHECK (SL > 0);
