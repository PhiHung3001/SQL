/*
Bài 1: Biến vô hướng: (4 điểm)
- Cho biết tổng lương của các Nhân Viên.
- Xuất ra bằng 2 cách: CAST, CONVERT
*/
DECLARE @TONGLUONG FLOAT
SELECT @TONGLUONG = CAST(SUM(LUONG) AS VARCHAR ) FROM NHANVIEN
SELECT @TONGLUONG AS 'TỔNG LƯƠNG CAST'

DECLARE @TONGLUONG1 FLOAT
SELECT @TONGLUONG1 = CONVERT(VARCHAR,SUM(LUONG)) FROM NHANVIEN
SELECT @TONGLUONG1 AS 'TỔNG LƯƠNG CONVERT'


/*
Bài 2: Biến bảng: (4 điểm)
- Tạo biến bảng @ThongTin chứa các thông tin về nhân viên và tổng số
nhân thân của họ (Kể cả những nhân viên chưa khai báo nhân thân nào):
MaNV, Tổng số nhân thân.
- Truy xuất nối bảng @ThongTin với bảng Nhân viên, lấy ra các thông tin
sau: MaNV, TenNV(viết hoa chữ cái đầu), Ngày sinh (dd-mm-yyyy), Tuổi,
Tổng số nhân thân
----khai báo biến bảng @thongtin (manv, số thân nhân)
*/
DECLARE @ThongTin TABLE
(MANV NVARCHAR(50),
TENNV NVARCHAR(50),
TongNT INT)
INSERT INTO @ThongTin
	SELECT MANV, TENNV, COUNT(MA_NVIEN) AS 'Tổng số nhân thân	'
	FROM dbo.THANNHAN JOIN NHANVIEN ON NHANVIEN.MA_NQL = THANNHAN.MA_NVIEN 
	GROUP BY MANV, TENNV;
SELECT * FROM @ThongTin 

SELECT NHANVIEN.MANV, 
	   UPPER(NHANVIEN.TENNV) AS'TenNV', 
	   CONVERT(VARCHAR, NHANVIEN.NGSINH, 103) AS'Ngày Sinh', YEAR(GETDATE())-YEAR(NHANVIEN.NGSINH) AS'Tuổi', A.TongNT
FROM @ThongTin A  JOIN NHANVIEN  ON A.MANV = NHANVIEN.MANV
/*
Bài 3: Sử dụng biến Bảng: (2 điểm)
- Cho biết số lượng nhân viên, tên trưởng phòng, ngày nhận chức trưởng
phòng và ngày nhận chức trưởng phòng hiển thi theo định dạng dd-mm-yy
(ví dụ 25-04-2019)
*/
DECLARE @SLNV TABLE
(
    SLNV INT,
    PHG NCHAR(10)
);
INSERT INTO @SLNV
SELECT COUNT(MANV),
       PHG
FROM dbo.NHANVIEN
GROUP BY PHG;
DECLARE @BT3 TABLE
(
    SLNV INT,
    TENTP NVARCHAR(9),
    NGAYNHAN VARCHAR(50)
);
INSERT INTO @BT3
SELECT [@SLNV].SLNV,
       TENNV,
       CONVERT(VARCHAR, NG_NHANCHUC, 105) AS 'Ngày Nhận Chức'
FROM dbo.PHONGBAN
    JOIN @SLNV
        ON MAPHG = PHG
    JOIN dbo.NHANVIEN
        ON NHANVIEN.MANV = PHONGBAN.TRPHG
GROUP BY TENNV,
         CONVERT(VARCHAR, NG_NHANCHUC, 105),
         [@SLNV].SLNV;
SELECT *
FROM @BT3;
