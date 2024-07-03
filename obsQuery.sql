/*OBS veri tabani olusturulacak. Tablolar ve tablolar arasýndaki iliskiler sql kodlari ile olusturulacaktir.

ogrenci
dersler
ogretim elemanlari
notlar
siniflar
bolumler
ders programlari
kulupler
odevler

		ÝLÝSKÝLER
ogrenci-ders= coktan coga
ogrenci-not= bire cok
ders- ogretim elamani= birden coga
ders-sinif= birden coga
ogrenci-kulup= coktan coga
ders- odev = birden coga
ogrenci- odev= coktan coga
*/


--bolum tablosu olusturuldu
create table department(
department_id int primary key,
department_name varchar(100)
)


--ogretim elemanlarý tablosu olusturuuldu
create table lecturers(
lecturers_id int primary key,
lecturers_name varchar(50),
department_id int foreign key references department(department_id)    
)

--ders tablosu olusturuldu
create table lesson(
lesson_id int primary key,
lesson_name varchar(100),
credit int,       --ders kredisi
department_id int foreign key references department(department_id),
lecturers_id int foreign key references lecturers(lecturers_id)
)

--sinif tabblosu olusturuldu
create table class(
class_id int primary key,
class_name varchar(50),
capacity INT         
)

--ogrenci tablosu olusturuldu
create table student(
student_id int primary key,
student_name varchar(50),
date_birth DATE,
department_id int foreign key references department(department_id)
)


--ogrenci ders kayit tablosu olusturuldu
create table register(   
register_id int primary key,
register_date DATE,
student_id int foreign key references student(student_id),
lesson_id int foreign key references lesson(lesson_id)
)


--notlar tablosu olusturuldu
create table note(
note_id int primary key,
vize_exam float,  --vize notu
final_exam float, --final notu
but_exam float,    --büt notu
register_id int foreign key references register(register_id)
)

--gecme durumu tablosu
create table pass_status(
	pass_status_id int primary key,
	register_id int foreign key references register(register_id),
	status varchar(20) --"gecti" ,"kaldi", "bute kaldi"
	)


--gecme durumunu hesaplayan fonksiyon
GO
CREATE PROCEDURE calculate_pass_status
    @register_id INT
AS
BEGIN
    DECLARE @vize FLOAT;
    DECLARE @final FLOAT;
    DECLARE @but FLOAT;
    DECLARE @average FLOAT;
    DECLARE @status VARCHAR(20);

    -- Notlarý al
 
  SELECT @vize = vize_exam, @final = final_exam, @but = but_exam  --vize final ve but notlari note tablosundan alinir
    FROM note
    WHERE register_id = @register_id;
    
    -- Ortalama hesapla ve durumu belirle
    IF @final IS NOT NULL       -- eger final notu mevcutsa
    BEGIN
        SET @average = @vize * 0.4 + @final * 0.6;
        IF @average >= 60
            SET @status = 'Gecti';      --ortalama 60 uzeri ise gecti
        ELSE
            SET @status = 'Kaldi';      --ortalama 60 alti ise kaldi
    END
    ELSE IF @but IS NOT NULL			--but notu mevcutsa
    BEGIN
        SET @average = @vize * 0.4 + @but * 0.6;  --ortalama hesaplanir
        IF @average >= 60
            SET @status = 'Gecti';           --ortalama 60 uzeri ise gecti
        ELSE
            SET @status = 'Kaldi';		    --ortalama 60 alti ise kaldi
    END
    ELSE									--but ve final notu yoksa bute kaldi
    BEGIN
        SET @status = 'Bute Kaldi';
    END

    -- Durumu geçme durumu tablosuna ekle veya güncelle
    IF EXISTS (SELECT 1 FROM pass_status WHERE register_id = @register_id) --pass_status tablosunda register_id ye sahip bir deger var mi?
    BEGIN
        UPDATE pass_status		--eger meccutsa gunceleleme yapilir
        SET status = @status
        WHERE register_id = @register_id;
    END
    ELSE                   --mevcut degilse yeni bir kayit eklenir
    BEGIN
        INSERT INTO pass_status (register_id, status)
        VALUES (@register_id, @status);
    END
END;
GO

--notlar tablosuna veri eklendiginde veya guncellendiginde fonksiyonu otomatik cagýran tetikleyici
GO 
CREATE TRIGGER trigger_calculate_pass_status
ON note
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @register_id INT;
    SELECT @register_id = inserted.register_id
    FROM inserted;

    EXEC calculate_pass_status @register_id;
END;
GO

--ders programi tablosu olusturuldu
create table syllabus(
syllabus_id int primary key,
weekdays varchar(10),   --haftanin gunleri
starting_date TIME,     --baslama tarihi
end_date TIME,			--bitis tarihi
lesson_id int foreign key references lesson(lesson_id),
class_id int foreign key references class(class_id)
)


--kulup tablosu olusturuldu
create table club(
club_id int primary key,   
club_name varchar(100),
club_president varchar(30), --kulup baskani
foundation_date DATE      --kulup kurulus tarihi
)


--kulup uyeligi tablosu olusturuldu
create table club_membership(
club_membership_id int primary key,
membership_date DATE,      --uyelik tarihi
student_id int foreign key references student(student_id),
club_id int foreign key references club(club_id)
)

--odevler tablosu olusturuldu
create table homework(
homework_id int primary key,
homeworkdescription TEXT,   --odev aciklamasi
deadline DATE,   --son tarih
lesson_id int foreign key references lesson(lesson_id)
)


--odev teslimi tablosu olusturuldu
create table homework_submission(
homework_submission_id int primary key,
delivery_date DATE,    -- odev teslim tarihi
homework_id int foreign key references homework(homework_id),
student_id int foreign key references student(student_id)
)