--Sistemde bir obs veri tabani mevcuttur. Bu veri tabanina iliskin sorgular asagýda listelenecektir.

--tablolari listeleme

SELECT * FROM class 
SELECT * FROM department
SELECT * FROM lecturers 
SELECT * FROM lesson
SELECT * FROM note
SELECT * FROM pass_status 
SELECT * FROM register 
SELECT * FROM student

--ogrenci tablosunda adi Z C ve M harfi ile baslayanlarýn listesi

SELECT * FROM student where student_name like '[ZCM]%'

 --ogrenci tablosunda dogum tarihi verilen araliklarda olan ogrencileri sýrala
SELECT * FROM student
where date_birth between '01/01/2000' and '12/31/2002'

--ogrenci tablosunda kac farkli isim var
 SELECT count(distinct student_name) as farkli_isim_sayisi from student 

 
--silinen öðrencinin adýný soyadýný mezun tablosuna trigger ile kaydediyoruz. foreign keyler oldugu icin bagli oldugu diger tablolardan da silinmesi gerekiyor.
create table graduate(graduate_name varchar(50))
ALTER TRIGGER delete_student 
ON student
INSTEAD OF DELETE
AS 
BEGIN
    -- Silinen öðrenci bilgilerini geçici bir tabloya kopyalayýn
    DECLARE @deleted TABLE (student_id INT, student_name VARCHAR(50));
    INSERT INTO @deleted (student_id, student_name)
    SELECT student_id, student_name 
    FROM deleted;

    -- pass_status tablosundaki ilgili kayýtlarý siliyoruz
    DELETE FROM pass_status
    WHERE register_id IN (SELECT register_id FROM register WHERE student_id IN (SELECT student_id FROM @deleted));

    -- not tablosundaki ilgili kayýtlarý siliyoruz
    DELETE FROM note
    WHERE register_id IN (SELECT register_id FROM register WHERE student_id IN (SELECT student_id FROM @deleted));

    -- register tablosundaki ilgili kayýtlarý siliyoruz
    DELETE FROM register
    WHERE student_id IN (SELECT student_id FROM @deleted);

    -- Silinen öðrencinin adýný graduate tablosuna ekliyoruz
    INSERT INTO graduate (graduate_name)
    SELECT student_name 
    FROM @deleted;
    
    -- Öðrenciyi student tablosundan siliyoruz
    DELETE FROM student
    WHERE student_id IN (SELECT student_id FROM @deleted);
END;

DELETE FROM student WHERE student_id =7 --silinmek istenen ögrencinin id si girilerek islem gerceklestiriliyor.
SELECT * FROM student
select * from graduate






-- herhangi bir dersten kalan ögrencileri verir. join islemi ile ogrenci, ders kaydi, dersten gecme, ders, bolum tablolari birlestirildi*
SELECT s.student_id, s.student_name,p.status,d.department_name,les.lesson_name,les.lecturers_id
FROM student s
JOIN pass_status p ON s.student_id = p.pass_status_id
JOIN register r ON  r.register_id=p.pass_status_id
JOIN department d ON s.student_id=d.department_id
JOIN lesson les ON les.lesson_id=d.department_id
WHERE p.status = 'Kaldý'

--vize notu 50den fazla olan ogrencileri sirala
SELECT s.student_id, s.student_name,p.status,n.vize_exam
FROM student s
JOIN pass_status p ON s.student_id = p.pass_status_id
JOIN register r ON  r.register_id=p.pass_status_id
JOIN note n ON r.register_id=n.note_id
WHERE n.vize_exam >50

--7. indexe yeni ögrenci atandý
INSERT INTO student(student_id,student_name, date_birth, department_id)
VALUES(7,'Ezel Bayraktar', '2000-11-01' , 3)
select *from student


--ogrenci adi ile butunleme notu guncellendi
UPDATE note
SET but_exam = 99
WHERE register_id IN (
    SELECT register_id
    FROM register
    WHERE student_id IN (
        SELECT student_id
        FROM student
        WHERE student_name = 'Canan Demir'
    )
);

select *from note


--ogrenci kaydini daha efektif hale getirmek icin bir stored procedure yazalim

CREATE PROCEDURE Addstudent
    @student_id INT,
    @student_name NVARCHAR(100),
    @date_birth DATE,
    @department_id INT
AS
BEGIN
    -- INSERT iþlemi
    INSERT INTO student (student_id, student_name, date_birth, department_id)
    VALUES (@student_id, @student_name, @date_birth, @department_id);
END;
GO


-- Stored procedure'u çagýrma
EXEC Addstudent
    @student_id = 9,
    @student_name = 'Nurgül Kýzmaz',
    @date_birth = '1999-02-18',
    @department_id = 1;

select *from student


