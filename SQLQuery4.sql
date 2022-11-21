/*
Bài 1: (3 điểm)
Sử dụng cơ sở dữ liệu QLDA. Thực hiện các câu truy vấn sau, sử dụng
if…else và case
 Viết chương trình xem xét có tăng lương cho nhân viên hay không. Hiển thị cột thứ 1 là
TenNV, cột thứ 2 nhận giá trị
o “TangLuong” nếu lương hiện tại của nhân viên nhở hơn trung bình lương trong
phòng mà nhân viên đó đang làm việc.
o “KhongTangLuong “ nếu lương hiện tại của nhân viên lớn hơn trung bình lương
trong phòng mà nhân viên đó đang làm việc.
 Viết chương trình phân loại nhân viên dựa vào mức lương.
o Nếu lương nhân viên nhỏ hơn trung bình lương mà nhân viên đó đang làm việc thì
xếp loại “nhanvien”, ngược lại xếp loại “truongphong”
*/

/*
Viết chương trình tính thuế mà nhân viên phải đóng theo công thức:
o 0&lt;luong&lt;25000 thì đóng 10% tiền lương
o 25000&lt;luong&lt;30000 thì đóng 12% tiền lương
o 30000&lt;luong&lt;40000 thì đóng 15% tiền lương
o 40000&lt;luong&lt;50000 thì đóng 20% tiền lương
o Luong&gt;50000 đóng 25% tiền lương
*/
-- TÍNH LƯƠNG TRUNG BÌNH
DECLARE @LTB  FLOAT
SELECT @LTB = AVG(LUONG) FROM NHANVIEN
GROUP BY PHG
SELECT @LTB AS LTB
--BÀI 1
SELECT CASE 
		WHEN PHAI=N'NỮ' THEN 'MS.'+TENNV
		WHEN PHAI=N'NAM' THEN 'MR.'+TENNV
	END AS TENNV,LUONG,
	CASE
		WHEN LUONG BETWEEN 0 AND 25000 THEN LUONG*0.1
		WHEN LUONG BETWEEN 25000 AND 30000 THEN LUONG*0.12
		WHEN LUONG BETWEEN 30000 AND 40000 THEN LUONG*0.15
		WHEN LUONG BETWEEN 40000 AND 50000 THEN LUONG*0.2
	END AS THUE,
	TENNV,LUONG,IIF(LUONG<@LTB,N'TĂNG LƯƠNG',N' KHÔNG TĂNG LƯƠNG') AS DCHINH,
	IIF(LUONG<@LTB,N'NHÂN VIÊN',N'TRƯỞNG PHÒNG') AS XEPLOAI FROM NHANVIEN
SELECT * FROM NHANVIEN

/*
Cho biết thông tin nhân viên (HONV, TENLOT, TENNV) có MaNV là số chẵn.
*/

/*
 Cho biết thông tin nhân viên (HONV, TENLOT, TENNV) có MaNV là số chẵn nhưng
không tính nhân viên có MaNV là 4.
*/
SELECT MANV,HONV,TENLOT,TENNV FROM NHANVIEN
WHERE CAST( RIGHT(MANV,1) AS INT)%2=0 AND CAST(RIGHT(MANV,1) AS INT) NOT LIKE  '%4'
/*
Thực hiện chèn thêm một dòng dữ liệu vào bảng PhongBan theo 2 bước
o Nhận thông báo “ thêm dư lieu thành cong” từ khối Try
o Chèn sai kiểu dữ liệu cột MaPHG để nhận thông báo lỗi “Them dư lieu that bai”
từ khối Catch
*/
BEGIN TRY 
	PRINT N'THÊM DỮ LIỆU THÀNH CÔNG'
END TRY
BEGIN CATCH
	INSERT INTO PHONGBAN VALUES('ABC',7,'008','10-10-2019')
	PRINT N'THÊM DỮ LIỆU THẤT BẠI'
END CATCH
SELECT * FROM PHONGBAN

/*
 Viết chương trình khai báo biến @chia, thực hiện phép chia @chia cho số 0 và dùng
RAISERROR để thông báo lỗi.
*/
BEGIN TRY
	DECLARE @CHIA INT;
	SET @CHIA=55/0

END TRY

BEGIN CATCH
	DECLARE @ERROR NVARCHAR(4000),@ERRORSEVERITY INT , @ERRORSTATE INT;
	SELECT @ERROR = ERROR_MESSAGE(),
			@ERRORSEVERITY=ERROR_SEVERITY(),
			@ERRORSTATE = ERROR_STATE();
	RAISERROR (@ERROR,@ERRORSEVERITY,@ERRORSTATE);
END CATCH
declare @tb float set @tb=5; select iif(@tb>7,'Kha','Tb')
Declare @dem int=0; WHILE @dem<3 BEGIN PRINT 'A' SET @dem=@dem+1 END PRINT 'B' 
 Declare @dem int=0; WHILE @dem<3 BEGIN PRINT 'A' SET @dem=@dem+2 END PRINT 'B'
 Declare @dem int=0; WHILE @dem<8 BEGIN IF @dem=3 BREAK ELSE PRINT 'A' SET @dem=@dem+1 END PRINT 'B'
 Declare @dem int=0; WHILE @dem<8 BEGIN IF @dem=3 begin Continue end ELSE PRINT 'A' SET @dem=@dem+1 END PRINT 'B'
 Declare @dem int=0; WHILE @dem<2 BEGIN IF @dem=3 begin Continue end ELSE PRINT 'A' SET @dem=@dem+1 END PRINT 'B'