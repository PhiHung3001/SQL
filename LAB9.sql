﻿-- CÂU 1
CREATE DATABASE QLCT
GO 
USE QLCT
GO
CREATE TABLE KHACHHANG(
	MAKH VARCHAR(10) PRIMARY KEY,
	TENKH NVARCHAR(50),
	DIACHI NVARCHAR(50),
	DIENTHOAI VARCHAR(10),
	GIOITINH NVARCHAR(5)


);
CREATE TABLE CONGTO(
	MACT VARCHAR(10) PRIMARY KEY,
	MAKH VARCHAR(10),
	TENCT NVARCHAR(50),
	SODIENTIEUTHU INT,
	MUCGIA MONEY,
	CONSTRAINT FK_CONGTO_KHACHHANG FOREIGN KEY (MAKH) REFERENCES KHACHHANG(MAKH)


);
-- CÂU 2
IF OBJECT_ID('SP_KHACHHANG')IS NOT NULL
DROP PROC SP_KHACHHANG
GO
CREATE PROC SP_KHACHHANG
	@MAKH VARCHAR(10),
	@TENKH NVARCHAR(50),
	@DIACHI NVARCHAR(50),
	@DIENTHOAI VARCHAR(10),
	@GIOITINH NVARCHAR(5)
AS
IF @MAKH IS NULL OR	@TENKH IS NULL OR @DIACHI IS NULL OR @DIENTHOAI IS NULL OR @GIOITINH	IS NULL

PRINT N'DỮ LIỆU KHÔNG HỢP LỆ'
 ELSE
 INSERT INTO KHACHHANG VALUES (@MAKH,@TENKH,@DIACHI,@DIENTHOAI,@GIOITINH)
 GO
 EXEC SP_KHACHHANG 'KH01',N'HOÀNG PHI HÙNG',N'NAM TỪ LIÊM','0387490099',N'NAM'
 EXEC SP_KHACHHANG 'KH02',N'TRẦN TIẾN MẠNH',N'ĐỐNG ĐA','0949325099',N'NAM'
 SELECT * FROM KHACHHANG
 IF OBJECT_ID('SP_CONGTO')IS NOT NULL
DROP PROC SP_CONGTO
GO
CREATE PROC SP_CONGTO
	@MACT VARCHAR(10),
	@MAKH VARCHAR(10),
	@TENCT NVARCHAR(50),
	@SODIENTIEUTHU INT,
	@MUCGIA MONEY
AS
IF @MACT IS NULL OR	@MAKH IS NULL OR @TENCT IS NULL OR @SODIENTIEUTHU IS NULL OR @MUCGIA	IS NULL

PRINT N'DỮ LIỆU KHÔNG HỢP LỆ'
 ELSE
 INSERT INTO CONGTO VALUES (@MACT,@MAKH,@TENCT,@SODIENTIEUTHU,@MUCGIA)
 GO
 EXEC SP_CONGTO 'CT01','KH01',N'CÔNG TƠ NHÀ SỐ 1',172,3000
 EXEC SP_CONGTO 'KH02','KH02',N'CÔNG TƠ NHÀ SỐ 2',200,3000

 SELECT * FROM CONGTO
 -- CÂU 3
 SELECT * FROM KHACHHANG

IF OBJECT_ID('CAU3') IS NOT NULL
    DROP FUNCTION CAU3
GO
CREATE FUNCTION CAU3 
(@MAKH VARCHAR(10)
)
RETURNS VARCHAR(10)
BEGIN 
RETURN (SELECT SODIENTIEUTHU FROM CONGTO
WHERE @MAKH = MAKH)
END
GO
--GỌI
DECLARE @SODIENTIEUTHU INT
SET @SODIENTIEUTHU =DBO.CAU3 ('KH01')
 select @SODIENTIEUTHU as 'SỐ ĐIỆN'

 -- CÂU 4
 IF OBJECT_ID('XOA') IS NOT NULL
    DROP PROC XOA
GO
CREATE PROC XOA
 @MAKH VARCHAR(10)
AS
BEGIN TRY 
      BEGIN TRAN
      --XÓA KHÓA NGOẠI
      delete CONGTO where MaKH IN (SELECT MaKH FROM KHACHHANG WHERE MaKH=@MAKH)
      --XÓA KHÓA CHÍNH
       delete KHACHHANG WHERE MaKH=@MAKH
         COMMIT TRAN
END TRY
   BEGIN CATCH
      ROLLBACK TRAN
    END CATCH

EXEC XOA 'KH01'
 -- CÂU 5
IF OBJECT_ID('VIEWTT') IS NOT NULL
    DROP VIEW VIEWTT
GO
    CREATE VIEW VIEWTT
AS
SELECT KH.MAKH ,TENKH,DIACHI,MACT ,SODIENTIEUTHU,MUCGIA,(SODIENTIEUTHU*MUCGIA) AS THANHTIEN ,
IIF(SODIENTIEUTHU>300,N'DÙNG NHIỀU',N'ĐỦ DÙNG') AS TRANGTHAI FROM KHACHHANG KH 
JOIN CONGTO CT ON KH.MAKH=CT.MAKH

SELECT * FROM VIEWTT

