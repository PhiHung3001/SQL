/*Bài 1: (3 điểm)
Viết stored-procedure:
 In ra dòng ‘Xin chào’ + @ten với @ten là tham số đầu vào là tên Tiếng Việt có dấu của
bạn. Gợi ý:
o sử dụng UniKey để gõ Tiếng Việt ♦
o chuỗi unicode phải bắt đầu bởi N (vd: N’Tiếng Việt’) ♦
o dùng hàm cast (&lt;biểuThức&gt; as &lt;kiểu&gt;) để đổi thành kiểu &lt;kiểu&gt;
của&lt;biểuThức&gt;.*/
-- KIỂM TRA SỰ TỔN TẠI CỦA SP
IF OBJECT_ID('SPCHAO') IS NOT NULL
DROP PROC
GO
	CREATE PROC SPCHAO @TEN NVARCHAR(50)
AS
	PRINT N'XIN CHÀO:' + @TEN
GO
-- GỌI LẠI SP

EXEC SPCHAO N'hOÀNG PHI HÙNG'

-- Nhập vào 2 số @s1,@s2. In ra câu ‘Tổng là : @tg’ với @tg=@s1+@s2.
IF OBJECT_ID ('SPSOCHAN') IS NOT NULL
DROP PROC SPSOCHAN
GO
	CREATE PROC SPSOCHAN @N INT
AS
	DECLARE @A INT = 2, @TONG INT = 0
	WHILE @A<= @N
		BEGIN
			SELECT @TONG += @A
			SET @A += 2
		END
	PRINT N'TỔNG SỐ CHẴN:' + CAST(@TONG AS VARCHAR)
EXEC SPSOCHAN 12
 Nhập vào số nguyên @n. In ra tổng các số chẵn từ 1 đến @n.
 Nhập vào 2 số. In ra ước chung lớn nhất của chúng theo gợi ý dưới đây:
o b1. Không mất tính tổng quát giả sử a &lt;= A
o b2. Nếu A chia hết cho a thì : (a,A) = a ngược lại : (a,A) = (A%a,a) hoặc (a,A) =
(a,A-a)
o b3. Lặp lại b1,b2 cho đến khi điều kiện trong b2 được thỏa
/*Bài 2: (3 điểm)
Sử dụng cơ sở dữ liệu QLDA, Viết các Proc:
Quản trị cơ sở dữ liệu với SQL Server
 Nhập vào @Manv, xuất thông tin các nhân viên theo @Manv.*/
IF OBJECT_ID('SPBAI21') IS NOT NULL
	DROP PROC SPBAI21
GO
CREATE PROC SPBAI21 @MANV VARCHAR(5)
AS
SELECT * FROM NHANVIEN
WHERE MANV = @MANV
EXEC SPBAI21 '004'
-- Nhập vào @MaDa (mã đề án), cho biết số lượng nhân viên tham gia đề án đó
IF OBJECT_ID('BAI22') IS NOT NULL
	DROP PROC BAI22
GO
CREATE PROC BAI22 @MADA INT
AS 
SELECT COUNT(MA_NVIEN) AS SLNV
FROM PHANCONG
WHERE MADA = @MADA
EXEC BAI22 1


/*
 Nhập vào @MaDa và @Ddiem_DA (địa điểm đề án), cho biết số lượng nhân viên tham
gia đề án có mã đề án là @MaDa và địa điểm đề án là @Ddiem_DA*/
IF OBJECT_ID('BAI23') IS NOT NULL
 DROP PROC BAI23
 GO 
 CREATE PROC BAI23 @MADA INT, @Ddiem_DA NVARCHAR(50)
 AS
SELECT COUNT(MA_NVIEN) AS SLNV
FROM PHANCONG JOIN DEAN ON PHANCONG.MADA = DEAN.MADA
WHERE DEAN.MADA = @MADA AND Ddiem_DA = @Ddiem_DA
GO
EXEC BAI23 1 , N'VŨNG TÀU'
/*
 Nhập vào @Trphg (mã trưởng phòng), xuất thông tin các nhân viên có trưởng phòng là
@Trphg và các nhân viên này không có thân nhân.*/
----C1: KHÔNG SỬ DỤNG PROC
SELECT * FROM NHANVIEN JOIN PHONGBAN 
	ON NHANVIEN.PHG = PHONGBAN.MAPHG
WHERE TRPHG = 5 AND MANV NOT IN (SELECT MA_NVIEN FROM THANNHAN)
--C2: SỬ DỤNG PROC
IF OBJECT_ID('BAI25') IS NOT NULL
	DROP PROC BAI25
GO 
CREATE PROC BAI25 @MANV VARCHAR(5),@MAPB VARCHAR(5)
AS
IF @MANV NOT IN (SELECT MANV FROM NHANVIEN WHERE PHG = @MAPB)
	PRINT N'MANV:' + @MANV + N'KHÔNG THUỘC PHÒNG:'  + @MAPB
ELSE 
	PRINT N'MANV:' + @MANV + N' THUỘC PHÒNG:'  + @MAPB
EXEC BAI25 '004',5
EXEC BAI25 '004',1 
/*
 Nhập vào @Manv và @Mapb, kiểm tra nhân viên có mã @Manv có thuộc phòng ban có
mã @Mapb hay không
Bài 3: (3 điểm)
Sử dụng cơ sở dữ liệu QLDA, Viết các Proc
 Thêm phòng ban có tên CNTT vào csdl QLDA, các giá trị được thêm vào dưới dạng
tham số đầu vào, kiếm tra nếu trùng Maphg thì thông báo thêm thất bại.
 Cập nhật phòng ban có tên CNTT thành phòng IT.
 Thêm một nhân viên vào bảng NhanVien, tất cả giá trị đều truyền dưới dạng tham số đầu
vào với điều kiện:
o nhân viên này trực thuộc phòng IT
o Nhận @luong làm tham số đầu vào cho cột Luong, nếu @luong&lt;25000 thì nhân
viên này do nhân viên có mã 009 quản lý, ngươc lại do nhân viên có mã 005 quản
lý
o Nếu là nhân viên nam thi nhân viên phải nằm trong độ tuổi 18-65, nếu là nhân
viên nữ thì độ tuổi phải từ 18-60.*/
IF OBJECT_ID('SPBAI3_3') IS NOT NULL
DROP PROC SPBAI3_3
GO
CREATE PROC SPBAI3_3
@HONV NVARCHAR(15), @TENLOT NVARCHAR(15), @TENNV NVARCHAR(15),
@MANV VARCHAR(10), @NGSINH DATETIME, @DCHI NVARCHAR(50),
@PHAI NVARCHAR(5), @LUONG MONEY, @MA_NQL VARCHAR(5), @PHG INT
AS
DECLARE @TUOI INT = DATEDIFF(YEAR, @NGSINH, GETDATE())
IF(@PHG != (SELECT MAPHG FROM PHONGBAN WHERE TENPHG = 'IT'))
PRINT N'NHẬP SAI, NHẬP LẠI VÌ NHÂN VIÊN KHÔNG THUỘC PHÒNG IT'
ELSE IF @PHAI = 'NAM' AND (@TUOI < 18 OR @TUOI > 65)
PRINT N'NHÂN VIÊN NAM PHẢI TUỔI TỪ 18 ĐẾN 65'
ELSE IF @PHAI = N'NỮ' AND (@TUOI < 18 OR @TUOI > 60)
PRINT N'NHÂN VIÊN NỮ PHẢI TUỔI TỪ 18 ĐẾN 60'
ELSE
INSERT INTO NHANVIEN 
VALUES(@HONV, @TENLOT,@TENNV,@MANV,@NGSINH,@DCHI,@PHAI,@LUONG,
IIF(@LUONG < 25000,'009','005'),@PHG)
-----GỌI
EXEC SPBAI3_3 'A','B','C','00000','1977-10-10','HN','NAM',30000,NULL,6
SELECT * FROM NHANVIEN