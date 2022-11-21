/*
Sử dụng cơ sở dữ liệu QLDA. Với mỗi câu truy vấn cần thực hiện bằng 2
cách, dùng cast và convert.
 Chỉnh sửa cột thời trong bảng PhanCong với dữ liệu như sau:
-Với mỗi đề án, liệt kê tên đề án và tổng số giờ làm việc một tuần của tất cả các nhân viên
tham dự đề án đó.
-Với mỗi đề án, liệt kê tên đề án và tổng số giờ làm việc một tuần của tất cả các nhân viên
tham dự đề án đó.
Xuất định dạng “tổng số giờ làm việc” kiểu decimal với 2 số thập phân.
o Xuất định dạng “tổng số giờ làm việc” kiểu varchar*/
SELECT TENDEAN,SUM(THOIGIAN) AS TONGHIO, 
CAST (SUM(THOIGIAN) AS DECIMAL(8,2)) AS DEC1, 
CONVERT(DECIMAL(8,2),SUM(THOIGIAN)) AS DEC2 , 
CAST (SUM(THOIGIAN) AS varchar) AS VAR1, 
CONVERT(varchar,SUM(THOIGIAN)) AS VAR2  
FROM DEAN
JOIN CONGVIEC ON DEAN.MADA = CONGVIEC.MADA
JOIN PHANCONG ON PHANCONG.MADA = CONGVIEC.MADA
GROUP BY TENDEAN

/* Với mỗi phòng ban, liệt kê tên phòng ban và lương trung bình của những nhân viên làm
việc cho phòng ban đó.
o Xuất định dạng “luong trung bình” kiểu decimal với 2 số thập phân, sử dụng dấu
phẩy để phân biệt phần nguyên và phần thập phân.
o Xuất định dạng “luong trung bình” kiểu varchar. Sử dụng dấu phẩy tách cứ mỗi 3
chữ số trong chuỗi ra, gợi ý dùng thêm các hàm Left, Replace */
DECLARE @LTB VARCHAR(20)
SELECT @LTB = CONVERT(VARCHAR,AVG(LUONG),1)
FROM NHANVIEN
GROUP BY PHG
--TRUY XUẤT
SELECT TENPHG,AVG(LUONG) AS LTB,
CONVERT(decimal(8,2),AVG(LUONG),1) AS LTBDEC,
REPLACE( LEFT(@LTB,LEN(@LTB)-3),'.','.')+'.' + RIGHT(@LTB,2) AS LTBVAR

FROM PHONGBAN
JOIN NHANVIEN ON PHONGBAN.MAPHG = NHANVIEN.PHG
GROUP BY TENPHG
--Bài 2: (2 điểm)
--Sử dụng các hàm toán học
-- Với mỗi đề án, liệt kê tên đề án và tổng số giờ làm việc một tuần của tất cả các nhân viên
--tham dự đề án đó.
--o Xuất định dạng “tổng số giờ làm việc” với hàm CEILING
--o Xuất định dạng “tổng số giờ làm việc” với hàm FLOOR
--o Xuất định dạng “tổng số giờ làm việc” làm tròn tới 2 chữ số thập phân
SELECT TENDEAN,SUM(THOIGIAN) AS TONGHIO, 
CEILING (SUM(THOIGIAN)) AS CEI,
FLOOR(SUM(THOIGIAN)) AS FLO,
ROUND (SUM(THOIGIAN),2) AS ROD
FROM DEAN
JOIN CONGVIEC ON DEAN.MADA = CONGVIEC.MADA
JOIN PHANCONG ON PHANCONG.MADA = CONGVIEC.MADA
GROUP BY TENDEAN
-- Cho biết họ tên nhân viên (HONV, TENLOT, TENNV) có mức lương trên mức lương
--trung bình (làm tròn đến 2 số thập phân) của phòng &quot;Nghiên cứu&quot;
SELECT HONV,TENLOT,TENNV AVG() FROM NHANVIEN
--Bài 3: (2 điểm)
--Sử dụng các hàm xử lý chuỗi
-- Danh sách những nhân viên (HONV, TENLOT, TENNV, DCHI) có trên 2 thân nhân,
--thỏa các yêu cầu
--o Dữ liệu cột HONV được viết in hoa toàn bộ
--o Dữ liệu cột TENLOT được viết chữ thường toàn bộ
--o Dữ liệu chột TENNV có ký tự thứ 2 được viết in hoa, các ký tự còn lại viết
--thường( ví dụ: kHanh)
--o Dữ liệu cột DCHI chỉ hiển thị phần tên đường, không hiển thị các thông tin khác
--như số nhà hay thành phố.
SELECT HONV,TENLOT,TENNV,DCHI,UPPER(HONV) AS UPP,
LOWER(TENLOT) AS LOWW,
LOWER(LEFT(TENNV,1))+ UPPER (SUBSTRING(TENNV,2,1))+ 
LOWER(RIGHT(TENNV,LEN(TENNV)-2)) AS SUB,
SUBSTRING(DCHI,CHARINDEX(' ',DCHI),CHARINDEX(',',DCHI)- CHARINDEX(' ',DCHI)) AS CHR
FROM NHANVIEN

--1

--Quản trị cơ sở dữ liệu với SQL Server
-- Cho biết tên phòng ban và họ tên trưởng phòng của phòng ban có đông nhân viên nhất,
--hiển thị thêm một cột thay thế tên trưởng phòng bằng tên “Fpoly”
SELECT HONV+ ' '+TENLOT+' '+TENNV AS TRPHONG,TRPHG,TENPHG AS FPOLY 
FROM NHANVIEN JOIN PHONGBAN ON NHANVIEN.MANV = PHONGBAN.TRPHG
WHERE TRPHG = (SELECT TRPHG 
				FROM PHONGBAN JOIN NHANVIEN ON PHONGBAN.MAPHG = NHANVIEN.PHG
				GROUP BY TRPHG 
				HAVING COUNT(MANV) = (SELECT MAX(SLLN) 
									FROM(SELECT COUNT(MANV) AS SLLN 
									FROM NHANVIEN 
										GROUP BY PHG)AS SLLN))
--
SELECT HONV+' '+ TENLOT+' '+ TENNV AS TRPHONG, TRPHG, TENPHG AS FPOLY
FROM NHANVIEN JOIN PHONGBAN ON NHANVIEN.MANV = PHONGBAN.TRPHG
WHERE TRPHG = (SELECT TRPHG
			    FROM PHONGBAN JOIN NHANVIEN ON PHONGBAN.MAPHG = NHANVIEN.PHG
			    GROUP BY TRPHG
			    HAVING COUNT(MANV) = (SELECT MAX(SLLN)
									FROM (SELECT COUNT(MANV) AS SLLN
									FROM NHANVIEN
										 GROUP BY PHG) AS SLLN))
--Bài 4: (2 điểm)
--Sử dụng các hàm ngày tháng năm
-- Cho biết các nhân viên có năm sinh trong khoảng 1960 đến 1965.
-- Cho biết tuổi của các nhân viên tính đến thời điểm hiện tại.
-- Dựa vào dữ liệu NGSINH, cho biết nhân viên sinh vào thứ mấy.
-- Cho biết số lượng nhân viên, tên trưởng phòng, ngày nhận chức trưởng phòng và ngày
--nhận chức trưởng phòng hiển thi theo định dạng dd-mm-yy (ví dụ 25-04-2019)

