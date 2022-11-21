/* Bài 1: (3 điểm)
Viết trigger DML:
 Ràng buộc khi thêm mới nhân viên thì mức lương phải lớn hơn 15000, nếu vi phạm thì
xuất thông báo “luong phải &gt;15000’
 Ràng buộc khi thêm mới nhân viên thì độ tuổi phải nằm trong khoảng 18 &lt;= tuổi &lt;=65.
 Ràng buộc khi cập nhật nhân viên thì không được cập nhật những nhân viên ở TP HCM */
IF OBJECT_ID('CKLCB') IS NOT NULL 
	DROP TRIGGER CKLCB
GO
CREATE TRIGGER CKLCB 
	ON NHANVIEN FOR INSERT
AS
	IF(SELECT LUONG FROM inserted)<15000
		PRINT N'LƯƠNG PHẢI LỚN HƠN 1500'
-----CHÈN KHÔNG THÀNH CÔNG
INSERT INTO NHANVIEN VALUES('B','B','B','00','1977','HN','NAM',3000,'005',5)
-----CHÈN THÀNH CÔNG
INSERT INTO NHANVIEN VALUES('B','B','B','00','1977','HN','NAM',30000,'005',5)