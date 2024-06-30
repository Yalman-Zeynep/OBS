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
create table bolumler(
bolumler_id int primary key,
bolum_adý varchar(100)
)


--ogretim elemanlarý tablosu olusturuuldu
create table elemanlar(
elemanlar_id int primary key,
elemanlar_adi varchar(50),
bolumler_id int foreign key references bolumler(bolumler_id)
)

--ders tablosu olusturuldu
create table ders(
ders_id int primary key,
ders_adi varchar(100),
kredi int,
bolum_id int foreign key references bolumler(bolumler_id),
elemanlar_id int foreign key references elemanlar(elemanlar_id)
)

--sinif tabblosu olusturuldu
create table sinif(
sinif_id int primary key,
sinif_adi varchar(50),
kapasite INT
)

--ogrenci tablosu olusturuldu
create table ogrenci(
ogrenci_id int primary key,
ogrenci_adi varchar(50),
dogum_tarihi DATE,
bolumler_id int foreign key references bolumler(bolumler_id)
)


--ogrenci ders kayit tablosu olusturuldu
create table ogderskayit(   
ogderskayit_id int primary key,
ogderskayit_tarih DATE,
ogrenci_id int foreign key references ogrenci(ogrenci_id),
ders_id int foreign key references ders(ders_id)
)


--notlar tablosu olusturuldu
create table notlar(
notlar_id int primary key,
notlar char(1),
ogderskayit_id int foreign key references ogderskayit(ogderskayit_id)
)


--ders programi tablosu olusturuldu
create table dersprogrami(
dersprogrami_id int primary key,
haftanin_gunleri varchar(10),
baslama_tarihi TIME,
bitis_tarihi TIME,
ders_id int foreign key references ders(ders_id),
sinif_id int foreign key references sinif(sinif_id)
)


--kulup tablosu olusturuldu
create table kulup(
kulup_id int primary key,
kulup_ismi varchar(100),
kulup_baskani varchar(30),
kurulus_tarihi DATE
)


--kulup uyeligi tablosu olusturuldu
create table kulup_uyeligi(
kulup_uyeligi_id int primary key,
uyelik_tarihi DATE,
ogrenci_id int foreign key references ogrenci(ogrenci_id),
kulup_id int foreign key references kulup(kulup_id)
)

--odevler tablosu olusturuldu
create table odevler(
odevler_id int primary key,
odevaciklamasi TEXT,
son_tarih DATE,
ders_id int foreign key references ders(ders_id)
)


--odev teslimi tablosu olusturuldu
create table odev_teslimi(
odev_teslimi_id int primary key,
teslim_tarihi DATE,
odevler_id int foreign key references odevler(odevler_id),
ogrenci_id int foreign key references ogrenci(ogrenci_id)
)