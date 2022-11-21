--Câu1.

--Bài 1: Sử dụng biến vô hướng 
--Cho biết lương cao nhất của NhanVien (4 điểm)
DECLARE @MAX_LUONG INT
SET @MAX_LUONG = (SELECT MAX(LUONG) FROM NHANVIEN)
SELECT @MAX_LUONG AS 'LUONG CAO NHAT'

--Bài 2 :  Sử dụng biến vô hướng:  (4 điểm)
--Viết chương trình tìm UCLN (Cả 2 số chia hết cho 1 số lớn nhất) và BCNN (1 số chia hết cho cả 2 số nhưng nhỏ nhất) của 2 số:
--- Khai báo 2 biến: @a và @b. Với @a  = 12 và @b = 5
--- Cấu trúc điều khiển WHILE, IF ... ELSE để tìm và xuất ra màn hình UCLN của 2 biến @a và @b. (while (dk) 	Begin <các câulênh>  end)

DECLARE @A INT,
        @B INT
SET @A = 12;
SET @B = 5;
IF @A > @B
BEGIN
    SELECT @A = @A % @B
END;

WHILE @B % @A != 0
BEGIN
    SELECT @A = @B % @A
END;
SELECT @A AS UCLN;
DECLARE @A INT,
        @B INT,
        @BCNN INT;
SET @A = 12;
SET @B = 5;
IF @A > @B
BEGIN
    SET @BCNN = @B;
END;
ELSE
BEGIN
    SET @BCNN = @A;
END;
WHILE @BCNN < @A * @B
BEGIN
    IF @BCNN % @A = 0
       AND @BCNN % @B = 0
    BEGIN
        BREAK;
    END;
    SET @BCNN = @BCNN + 1;
END;
SELECT @BCNN AS BCNN;
 


--Bài 3: Sử dụng biến Bảng: (2 điểm)
--Tạo biến bảng chứa thông tin các Nhân viên sinh năm 1960
DECLARE @BANGTT TABLE(
	HONV nvarchar(15) ,
	TENLOT nvarchar(15),
	TENNV nvarchar(15) ,
	MANV nvarchar(9) ,
	NGSINH datetime ,
	DCHI nvarchar(30) ,
	PHAI nvarchar(3) ,
	LUONG float ,
	MA_NQL nvarchar(9) ,
	PHG int
)
INSERT INTO @BANGTT
SELECT * FROM NHANVIEN
WHERE NGSINH BETWEEN '1960-01-01' AND '1960-12-31' 
SELECT * FROM @BANGTT