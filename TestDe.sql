CREATE DATABASE DATHANG
GO
USE DATHANG
GO
CREATE TABLE MATHANG(
MaH varchar(10) primary key,
TenH nvarchar(50),
LoaiH nvarchar(50),
DVTinh nvarchar(50));
CREATE TABLE DONHANG(
SoDH varchar(10) primary key,
NgayDH datetime,
NgayGH datetime

);
CREATE TABLE CTDH(
SoDH varchar(10),
MaH varchar(10),
SoLuong int,
DonGia money,
Constraint FK_CTDH_MATHANG foreign key (MaH) references MATHANG(MaH),
Constraint FK_CTDH_DONHANG foreign key (SoDH) references DONHANG(SoDH)
);

if OBJECT_ID ('SP_MATHANG') is not null
drop proc SP_MATHANG
go
create proc SP_MATHANG 
@MaH varchar(10),
@TenH nvarchar(50),
@LoaiH nvarchar(50),
@DVTinh nvarchar(50)
as 
if @MaH is null or @TenH  is null or @LoaiH is null or @DVTinh is null
print 'Dữ liệu không hợp lệ'
else
insert into MATHANG values (@MaH,@TenH,@LoaiH,@DVTinh)
go
exec SP_MATHANG 'MH01',N'BƠM XE ĐẠP',N'Hàng loại 1',N'Cái'
exec SP_MATHANG 'MH02',N'MÁY HÀN',N'Hàng loại 2',N'Cái'
exec SP_MATHANG 'MH03',N'MÁY RỬA XE',N'Hàng loại 3',N'Cái'
select * from MATHANG

if OBJECT_ID ('SP_DONHANG') is not null
drop proc SP_DONHANG
go
create proc SP_DONHANG
@SoDH varchar(10),
@NgayDH datetime,
@NgayGH datetime

as 
if @SoDH is null or @NgayDH  is null or @NgayGH is null
print 'Dữ liệu không hợp lệ'
else
insert into DONHANG values (@SoDH,@NgayDH,@NgayGH)
go
exec SP_DONHANG 'DH01','2021-01-01','2021-03-26'
exec SP_DONHANG 'DH02','2021-02-02','2021-05-06'
exec SP_DONHANG 'DH03','2020-12-12','2021-01-01'
select * from DONHANG

if OBJECT_ID ('SP_CTDH') is not null
drop proc SP_CTDH
go
create proc SP_CTDH
@SoDH varchar(10),
@MaH varchar(10),
@SoLuong int,
@DonGia money

as 
if @SoDH is null or @MaH  is null or @SoLuong is null or @DonGia is null
print 'Dữ liệu không hợp lệ'
else
insert into CTDH values (@SoDH,@MaH,@SoLuong,@DonGia)
go
exec SP_CTDH 'DH01','MH01',100,150000
exec SP_CTDH 'DH02','MH02',120,200000
exec SP_CTDH 'DH03','MH03',150,70000
select * from CTDH
--câu 5
IF OBJECT_ID('XOA') IS NOT NULL
DROP PROC XOA
GO
CREATE PROC XOA
(@SoLuong INT)
AS
BEGIN TRY
DECLARE @BANG TABLE(
SoDH VARCHAR(10) ,MaH VARCHAR(10)
)
INSERT INTO @BANG 
SELECT SoDH ,MaH FROM CTDH WHERE SoLuong =@SoLuong
BEGIN TRAN
--xóa khóa ngoại

DELETE FROM CTDH WHERE SoLuong = @SoLuong
 
--XÓA KHÓA CHÍNH
DELETE FROM DONHANG WHERE SoDH IN (SELECT SoDH FROM @BANG) 
DELETE FROM MATHANG WHERE MaH IN (SELECT MaH FROM @BANG)

COMMIT TRAN
END TRY
BEGIN CATCH
  ROLLBACK TRAN
END CATCH
GO
EXEC XOA 100
select * from CTDH
select * from DONHANG
select * from MATHANG

