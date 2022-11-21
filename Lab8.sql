-- câu 1
CREATE DATABASE QLHH
GO
USE QLHH
GO

CREATE TABLE Khachhang(
	Makh VARCHAR(10) primary key,
	Tenkh nvarchar(10),
	diachi nvarchar(50),
	dienthoai varchar(10),
	gioitinh Nvarchar (5),
	

);
CREATE TABLE Mathang(
	Mamh varchar(10) primary key,
	tenmh varchar(50),
	dongia money,


);
CREATE TABLE DonDH(
	Mamh varchar(10),
	Makh varchar(10),
	ngaydh datetime,
	ngaygh datetime,
	soluong int,
	
	CONSTRAINT FK_DonDH_Khachhang foreign key (Makh) references Khachhang(Makh),
	CONSTRAINT FK_DonDH_Mathang foreign key (Mamh) references Mathang(Mamh),

);
--câu 2
--thêm vào bảng khachhang
IF OBJECT_ID('SPkhachhang')IS NOT NULL
DROP PROC SPkhachhang
GO
CREATE PROC SPkhachhang
@Makh VARCHAR(10),
	@Tenkh nvarchar(10),
	@diachi nvarchar(50),
	@dienthoai varchar(10),
	@gioitinh Nvarchar (5)
AS
IF @Makh is null or
	@Tenkh is null or
	@diachi is null or
	@dienthoai is null or
	@gioitinh is null
PRINT N'DỮ LIỆU KHÔNG HỢP LỆ'
 ELSE
 INSERT INTO Khachhang VALUES (@Makh,@Tenkh,@diachi,@dienthoai,@gioitinh)
 GO

 EXEC SPkhachhang 'KH01',N'HÙNG',N'NAM TỪ LIÊM','09436587410',N'NAM'
 EXEC SPkhachhang 'KH02',N'SỸ',N'HÀ ĐÔNG','0965231498',N'NAM'
 EXEC SPkhachhang 'KH03',N'HÀ',N'ĐỐNG ĐA','0965631498',N'NỮ'
 SELECT * FROM Khachhang
 --THÊM VÀO BẢNG MATHHANG
 IF OBJECT_ID('SPMmathang')IS NOT NULL
DROP PROC SPMmathang
GO
CREATE PROC SPMmathang
@Mamh varchar(10),
	@tenmh varchar(50),
	@dongia money
AS
IF @Mamh is null or  @tenmh is null or @dongia is null
PRINT N'DỮ LIỆU KHÔNG HỢP LỆ'
 ELSE
 INSERT INTO Mathang VALUES (@Mamh,@tenmh,@dongia)
 GO
 
 EXEC SPMmathang 'MH01',N'MÁY BƠM',120000
  EXEC SPMmathang 'MH02',N'MÁY HÀN',150000
   EXEC SPMmathang 'MH03',N'MÁY NÉN',200000
 SELECT * FROM Mathang
 -- THÊM VÀO BẢNG DONdh
 IF OBJECT_ID('SPDonDh')IS NOT NULL
DROP PROC SPDonDh
GO
CREATE PROC SPDonDh
	@Mamh varchar(10),
	@Makh varchar(10),
	@ngaydh datetime,
	@ngaygh datetime,
	@soluong int
AS
IF @Mamh is null or  @Makh is null or @ngaydh is null or @ngaygh is null or @soluong is null
PRINT N'DỮ LIỆU KHÔNG HỢP LỆ'
 ELSE
 INSERT INTO DonDH VALUES (@Mamh,@Makh,@ngaydh,@ngaygh,@soluong)
 GO
 
 EXEC SPDonDh 'MH01','KH01','2021-03-27','2021-04-27',12
  EXEC SPDonDh 'MH02','KH02','2021-01-01','2021-05-23',15
   EXEC SPDonDh 'MH03','KH03','2021-06-07','2021-06-15',20
SELECT * FROM DonDH
-- câu 3
SELECT * FROM KHACHHANG

IF OBJECT_ID('CAU3') IS NOT NULL
    DROP FUNCTION CAU3
    GO
CREATE FUNCTION CAU3 
(@TENKH NVARCHAR(10),@DIACHI NVARCHAR(50),
 @DIENTHOAI VARCHAR(10), @GIOITINH VARCHAR (5)
)
RETURNS VARCHAR(10)
BEGIN 
RETURN (SELECT MAKH FROM KHACHHANG
WHERE TENKH=@TENKH AND DIACHI=@DIACHI
AND DIENTHOAI =@DIENTHOAI AND GIOITINH=@GIOITINH)
END
GO
--GỌI
DECLARE @MAKH VARCHAR(10)
SET @MAKH =DBO.CAU3 (N'HÙNG',N'NAM TỪ LIÊM','09436587410','NAM')
 select @MAKH as 'Makh'

-- câu 4
 IF OBJECT_ID('cau4') IS NOT NULL
    DROP VIEW cau4
GO
	CREATE VIEW cau4
AS
SELECT top 2 Khachhang.Tenkh,Mathang.tenmh,ngaydh,ngaygh,soluong,Mathang.dongia,Mathang.dongia*soluong as thanhtien   FROM DonDH 
join Khachhang on Khachhang.Makh = DonDH.Makh
join Mathang on Mathang.Mamh = DonDH.Mamh
order by Mathang.dongia*soluong desc
select * from cau4

-- câu 5

IF OBJECT_ID('SP_05') IS NOT NULL
    DROP PROC SP_05
GO
CREATE PROC SP_05
 @Mamh VARCHAR(10)
AS
BEGIN TRY 
      BEGIN TRAN
      --XÓA KHÓA NGOẠI
      delete DonDH where MAMH IN (SELECT MAMH FROM MATHANG WHERE MAMH=@MAMH)
      --XÓA KHÓA CHÍNH
       delete MATHANG where MAMH=@MAMH
         COMMIT TRAN
END TRY
   BEGIN CATCH
      ROLLBACK TRAN
    END CATCH

EXEC SP_05 'MH01'
