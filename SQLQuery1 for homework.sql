-----------------VERILER UZERINDE SELECT SORGULARI--------------------
-- 1-> Kargolar(Shippers) tablosunda yer alan KargoID (ShipperID), Firma Adi (CompanyName) ve Telefon Numarasi (Phone) bilgilerini raporlayiniz.
select ShipperID, CompanyName, Phone 
from shippers; 

-- 2-> Calisanlarimin (Employees) ID'lerini (EmployeeID), adlarini (FirstName) ve soyadlarini (LastName) raporlayiniz. Ancak adlar ve soyadlar tek bir kolonda toplansin ve kolon adi 'AdSoyad' olsun.
select EmployeeID, Concat(FirstName, ' ' ,LastName) as AdSoyad 
from Employees; 

-- 3-> Calisanlarimin Ad ve Soyadlariyla birlikte yaslarini raporlayiniz.
select FirstName as Ad, lastName as Soyad, DateDiff(year, BirthDate, getdate()) as Yaþ 
from Employees;

-- 4-> Urunlerimin(Products) ID'lerini (ProductID), adlarini (ProductName), stok miktarlarini (UnitsInStock), fiyatlarini (UnitPrice) ve fiyatlara %18 KDV eklenmis hallerini raporlayiniz.
select products.ProductID as ID, products.ProductName as [Ürün Ýsmi], products.UnitsInStock as [Stok Miktarý], products.UnitPrice as [Ürün Fiyatý], UnitPrice*1.18 as [KDV'li Ürün Fiyatý]
from Products;

-----------------VERILERIN FILTRELENDIRILMESI (WHERE)--------------------
-- 5-> Urun ucreti 30'dan yuksek olan urunleri raporlayiniz.
select * from products where products.UnitPrice>30;

-- 6-> Londra'da yasayan(City) personellerimi listeleyiniz.
select * from Employees where city='London'

-- 7-> CategoryID'si 5 olmayan urunlerimin adlarini ve CategoryID'lerini gosteriniz.
select Products.ProductName as [Ürün Adý], products.CategoryID as ID from products where CategoryID != 5;

-- 8-> '01.01.1993' tarihinden sonra ise girmis personellerimin Adini, soyadini ve ise giris tarihlerini(HireDate) raporlayiniz.
select Employees.FirstName as Adý, Employees.LastName as Soyadý, Employees.HireDate as [Ýþe Giriþ Tarihi] from Employees where HireDate > '01.01.1993';

-- 9-> 'March' ayinda alinmis olan siparislerin OrderID, OrderDate kolonundaki degerleri raporlayiniz. (Orders)
select OrderID, OrderDate from Orders where month(OrderDate) = 3;

-----------------MANTIKSAL OPERATORLER (AND - OR)--------------------
-- 10-> Urunlerim arasinda stok miktari 20 - 50 olan urunlerimin listesini raporlayiniz...
select * from products where products.UnitsInStock= 20 or UnitsInStock=50;

-- 11-> Yasi 50'den buyuk, Ingiltere'de oturmayan calisanlarimin adlarini ve yaslarini raporlayiniz. Ancak isimler su formatta olmalidir: A. Fuller
select concat(left(employees.firstname,1), '. ',Employees.LastName) as Adý, datediff(year, birthdate, getdate()) as Yaþ 
from Employees 
where datediff(year, birthdate, getdate())>50 and country!='England';

-- 12-> 1997(dahil) yilindan sonra (OrderDate) alinmis, kargo ucreti (Freight) 20'den buyuk ve Fransa'ya gonderilmemies(ShipCountry) siparislerin(Orders) 
-- OrderID, siparis tarihlerini, teslim tarihlerini(ShippedDate) ve kargo ucretlerini raporlayiniz..
select orderID as [Sipariþ Tarihi], ShippedDate as [Teslim Tarihi], Freight as [Kargo Ücreti] 
from Orders
where year(orderdate)>= 1997 and Freight>20 and shipcountry != 'France';

-----------------NULL IFADELERIN KONTROLU
-- 13-> Henuz musteriye ulasmamis siparisleri raporlayiniz...
select * from orders where ShippedDate is null;

-- 14-> Musteriye ulasmis olan siparisleri raporlayiniz...
select * from orders where ShippedDate is not null;

-- 15-> Kimseye rapor(Reportsto) vermeyen personelimin adi, soyadi ve unvani(Title) nedir?
select Employees.FirstName, Employees.LastName, Title from Employees where ReportsTo is null;

-- 16-> 'DUMON' ya da 'ALFKI' CustomerID'lerine sahip olan musteriler tarafindan alinmis, 1 nolu personelin onayladigi (EmployeeID), 
-- 3 nolu kargo firmasi tarafindan tasinmis (ShipVia) ve ShipRegion'ý null olan siparisleri gosteriniz.. 
select * from orders where (CustomerID ='DUMON' or CustomerID='ALFKI') and EmployeeID = 1 and ShipVia=3 and Shipregion is null;

-----------------SIRALAMA ISLEMLERI (ORDER BY)
-- 17-> Musterilerin ID'lerini (CustomerID), Sirket adlarini (CompanyName), ulkelerini (Country) listeleyiniz. 
--Ancak sirket Fransiz sirketi olacak ve CustomerID'lerine gore tersten siralanacak...
select CustomerID ID, CompanyName [Þirket Adý], Country Ülke from Customers where Country='France' order by CustomerID DESC;

-- 18-> Urlerimizin adlarini(ProductName), ucretlerini(UnitPrice), stok miktarlarini(UnitsInStock) gosteriniz. 
--stok miktari 50'den buyuk olacak ve urun ucretine gore ucuzdan pahaliya bir siralama gerceklestirilecek...
select ProductName [Ürün Adý], UnitPrice [Ürün Ücreti], UnitsInStock [Stok Adedi] from products where UnitsInStock>50 order by UnitPrice ASC;

-----------------KAYITLARDA BELÝRLÝ BÝR SAYIDA VERÝYÝ ALMA
-- 19-> En ucuz 10 urunu gosteriniz...
select top 10 * from products;

-- 20-> En son teslim edilen 5 siparisn detaylarini gosteriniz..
select top 5 * from orders order by shippeddate desc;

-- 21-> En fazla kargo ucreti odenene siparisin ID'sini ve odenen miktari gosteriniz...
select top 1 OrderID [Sipariþ ID], Freight [Ödenen Miktar] from orders order by Freight desc;

-----------------BETWEEN - AND KALIBI-----------------
-- 22-> Bas harfi C olan, stoklarda mevcut, 10 - 250 dolar arasi ucreti olan urunleri fiyatlarina gore listeleyiniz...
select unitprice as Fiyat from products where ProductName like 'c%' and (UnitPrice between 10 and 250) order by UnitPrice asc;

-- 23-> 'Wednesday' gunu alinan, kargo ucreti 20-75 arasinda olan, teslim tarihi null olmayan siparislerin bilgilerini raporlayiniz ve 
--OrderID'sine gore buyukten kucuge siralayiniz...
select * from Orders where DATEPART(weekday, orderdate)=4 and (Freight between 20 and 75)  and shippeddate is not null order by orderID desc;

-----------------ARAMA ISLEMLERI (LIKE)-----------------
-- 24-> CompanyName'leri A harfi ile baslayan musterileri listeleyelim...
select * from customers where Companyname like 'a%';

-- 25-> CompanyName'leri A harfi ile biten musterileri listeleyelim...
select * from customers where Companyname like '%a';

-- 26-> CompanyName'leri arasinda ltd gecen musterileri listeyelim...
select * from customers where Companyname like '%ltd%';

-- 27-> CustomerID'lerinden ilk iki harfi bilinmeyen ama son uc harfi "mon" olan musteriyi gosterelim...
select * from customers where CustomerID like '__MON';

-- 28-> CustomerID'lerinden ilk harfi A ya da S olan musterileri listeleyiniz...
select * from customers where CustomerID like 'a%' or CustomerID like 's%';

-- 29-> CustomerID'lerinden ilk harfi A olmayan musterileri listeleyiniz...
select * from customers where customerID not like 'a%';

-- 30-> Ulkesi Ingiltere olmayan, adi A ile baslayip soyadi R ile biten, dogum tarihi 1985'ten once olan calisanim kimdir?
select * from Employees where Country!='England' and Firstname like 'a%r' and year(birthdate)< 1985;

-- 31-> Japoncayi akici konusan personel kimdir?
select * from employees where country='japan';

-----------------AGGREGATE FUNCTIONS-----------------
-- 32-> Stokta bulunan kac tane urunumuz vardir?
select count(UnitsInStock) [Stok Adedi] from products;

-- 33-> 1996 yilindan sonra alinmis kac adet siparis vardir?
select count(OrderID) [Sipariþ Adedi] from orders where year(orderdate)>1996;

-- 34-> Kac ulkeden musterimiz bulunmaktadir?
select count(country) [Müþteri Sayýsý] from customers;

-- 35-> Her bir urunden bir adet alsam ne kadar oderim?
select sum(unitprice) from products;

-- 36-> Depoda ucret bazli olarak toplam ne kadarlik urunum kalmistir?
select sum(UnitsInStock * unitprice) [Toplam Ürünlerim] from Products where Discontinued != 0;

-- 37-> 1997 yilinda alinmis olan siparislerim icin toplam ne kadarlik kargo odemesi yaptik?
select sum(freight) from Orders where year(orderdate)='1997' 

-- 38-> Bu zaman dek odenmis ortalama kargo ucretimiz nedir? 
select avg(freight) from orders

-- 39-> Urunlerimin ortalama satis fiyati nedir?
select avg(unitprice) from products;

-- 40-> En yuksek kargo miktari nedir?
select max(freight) from orders;

-- 41-> MusteriID'leri A-K arasinda olanlarin vermis olduklari, siparis tarihi 01.01.1997 ile 06.06.1997 arasinda olan siparislere en az ne kadar karago ucreti odenmistir?
select min(freight) from orders where (CustomerID between 'A' and 'K') and (OrderDate between '01.01.1997' and '06.06.1997');

-----------------IN YAPISI-----------------
-- 42-> 2,4,5,7 nolu calisanlarin almis olduklari siparisleri gosteriniz..
select * from orders where EmployeeID in ('2','4','5','7');

-- 43-> 1 ya da 2 nolu kargo firmasi ile tasinmis, 1996 yilinda bir Persembe gunu alinmis siparisler icin odenen azami kargo bedeli nedir?
select min(freight) from orders o 
where (Shipvia= 1 or ShipVia= 2) and DATEPART(weekday, orderdate)=5 and year(orderdate)= '1996';

-- 44-> 'CACTU', 'DUMON' ya da 'PERIC' ID'li musteriler tarafindan istenmis, 2 nolu kargo firmasiyla tasinmamis, kargo ucreti 20 - 200 dolar arasi olan siparislere toplam ne kadarlik kargo odemesi yapilmistir?
select sum(freight) from orders where (CustomerID='cactu' or CustomerID='dumon' or CustomerID='peric') and shipvia!='2' and (Freight between '20' and '200');

-----------------WHEN - CASE YAPISI-----------------
-- 45-> Calisanlar tablosunda 'Mr.' gorulen yere 'Bay'; 'Ms.' ve 'Mrs.' gorunen yere 'Bayan'; onbilgi yoksa ya da harici herhangi bir durumsa 'On Bilgi Yok' yazdirilarak raporlansin...
select 
case
 when TitleOfCourtesy='Mr.' then 'Bay'
 when TitleOfCourtesy='Mrs.' then 'Bayan'
 else 'Ön Bilgi Yok.'
 end as 'title'
  from employees;

-- 46-> Urun adlarini, ucretlerini ve stok miktarlarini raporlayiniz. Eger stok miktari 50'den kucukse 'Kritik Durum', 50 - 75 arasi ise 'Normal Stok' 75'te fazla ise 'Stok Fazlasý' uyarisi veren ekstra bir kolonu rapora ekleyiniz... Raporunuz stok miktarlarina gore kucukten buyuge siralansin...
select productname, unitprice, UnitsInStock, case
 when UnitsInStock < 50 then 'kritik Durum'
 when unitsInstock between 50 and 75 then 'normal stok'
 else 'stok fazlasý'
 end as 'Stok Durumu' 
from products 
ORDER BY UnitsInStock asc;

-----------------GROUP BY YAPISI-----------------
-- 47-> Ulkelere gore calisan sayimiz nedir?
select count(employeeId) [Çalýþan Sayýsý], country from Employees group by Country

-- 48-> Hangi kategoride kac tane urunum var raporlayiniz?
select count(productID) [Ürün Sayýsý], categoryID from products group by CategoryID;

-- 49-> Calisanlara gore almis olduklari siparis sayilarini raporlayiniz...
select count(orderID) [Sipariþ Sayýsý], EmployeeID from orders group by EmployeeID 

-- 50-> Ulkelere gore siparis sayilarini raporlayiniz ve en cok siparis veren 3 ulkeyi listeleyiniz...
select top 3 count(orderID) [Sipariþ Sayýsý], ShipCountry from orders group by ShipCountry;

-----------------JOIN-----------------
-- 51-> Urunlerimizin adlarini ve kategorileri adlarini bir raporda gosteriniz..
select products.productname, categories.categoryname from products inner join categories on categories.CategoryID= products.CategoryID

-- 52-> Urunleri ve alindiklari toptancilarin sirket adlarini raporlayiniz...
select products.ProductID, suppliers.CompanyName from products inner join suppliers on suppliers.supplierID=products.supplierID

-- 53-> Beverages kategorisine ait, stoklarda bulunan urunleri raporlayiniz...
SELECT categories.CategoryName, products.UnitsInStock from products inner join categories on products.categoryID =Categories.CategoryID

-- 54-> Federal Shipping ile tasinmis ve Nancy'nin almis oldugu siparisleri gosteriniz (OrderID, FirstName, lastName, OrderDate, CompanyName)
select Shippers.CompanyName, orders.OrderDate, orders.OrderID, Employees.FirstName, Employees.LastName 
from ((orders inner join Employees on orders.EmployeeID= Employees.EmployeeID)
inner join Shippers on shippers.ShipperID=Orders.ShipVia)
where shippers.ShipperID=3 and employees.EmployeeID=1

-- 55-> CompanyName'leri arasinda a gecen musterilerin vermis oldugu, Nancy; Andrew ya da Janet tarafindan alinmis, 
--Speedy Express ile tasinmamis siparislere toplam ne kadarlik kargo odemesi yapilmistir?
select sum(orders.freight) [Toplam Kargo Bedeli]
from (((orders inner join shippers on shippers.ShipperID = orders.ShipVia) 
inner join Employees on orders.EmployeeID=Employees.EmployeeID)
inner join Customers on customers.CustomerID=orders.CustomerID)
where customers.CompanyName like '%a%' and (employees.EmployeeID = 1 or Employees.EmployeeID = 2 or employees.EmployeeID = 3) and ShipperID!=1;

-- 56-> En cok urun aldigimiz 3 toptanciyi, almis oldugumuz urun miktarlarina gore raporlayiniz...
select top 3 suppliers.CompanyName, sum(products.unitsInStock + products.unitsonorder) as [Toplam satýþ miktarý] 
from suppliers inner join products on suppliers.supplierID = products.SupplierID 
group by Suppliers.CompanyName 
order by [Toplam satýþ miktarý] desc

-- 57-> Her bir urunden toplam ne kadarlik satis yapilmistir ve o urunler hangi kategoriye aittir?
select Categories.CategoryID Kategori, sum(products.UnitsOnOrder) [toplam satýþ]
from Categories inner join products on Categories.CategoryID=products.CategoryID
group by categories.CategoryID

-- 58-> Urunleri ve bagli bulunduklari kategorileri listeleyiniz. Ancak urunu olmayan kategoriler de sorgu sonucuna dahil edilsin...
select products.ProductID, products.productname, categories.CategoryID, Categories.CategoryName 
from categories left join products on Categories.CategoryID=products.CategoryID

-- 59-> Urunleri ve bagli bulunduklari kategorileri listeleyiniz. Ancak kategorisi olmayan urunler de sorgu sonucuna dahil edilsin...
select products.ProductID, products.productname, categories.CategoryID, Categories.CategoryName 
from categories right join products on Categories.CategoryID=products.CategoryID

-- 60-> Urunleri ve bagli bulunduklari kategorileri listeleyiniz. Ancak kategorisi olmayan urunler ve urunleri olmayan kategoriler de sorgu sonucuna dahil edilsin...
select products.ProductID, products.productname, categories.CategoryID, Categories.CategoryName 
from categories full join products on Categories.CategoryID=products.CategoryID

-----------------HAVING YAPISI-----------------
-- 61-> Toplam siparis miktari 1200'un uzerinde olan urunlerin adlarini ve siparis miktarlarini gosteriniz...
select products.ProductName [ürün adý], sum([Order Details].quantity) [sipariþ miktarý] 
from products inner join [order details] on products.ProductID= [Order Details].ProductID group by products.ProductName having sum([Order Details].quantity)>1200

-- 62-> 250'den fazla siparis tasimis olan kargo firmalarinin adlarini, telefon numaralarini ve siparis miktarlarini raporlayiniz...
select count(orders.orderId) [sipariþ sayýsý], shippers.CompanyName [Kargo Firmasý Adý], shippers.Phone [Kargo Firmasý No'su],Shippers.ShipperID
from orders inner join shippers on orders.shipvia=shippers.ShipperID 
group by shippers.CompanyName, shippers.Phone, shippers.ShipperID  
having count(orders.orderId) > 250

-----------------SUBQUERY YAPISI-----------------
-- 63-> Ortalama ucretin uzerinde yer alan urunleri gosteriniz..
select * from products where unitprice > (select avg(unitprice) from Products)

-- 64-> Nancy'nin almis oldugu siparislerin ID'lerini subquery ile raporlayiniz...
select orders.orderID from orders where EmployeeID=(select employeeID from Employees where EmployeeID =1)

-- 65-> Nancy; Andrew ya da Janet tarafindan alinmis ve Speedy Express ile tasinmamis siparisleri listeleyiniz...
select EmployeeID, shipvia,orderID 
from orders 
where(EmployeeID =(select employeeID from Employees where EmployeeID =1) or EmployeeID =(select employeeID from Employees where EmployeeID =2) or EmployeeID =(select employeeID from Employees where EmployeeID =3)) and
ShipVia=( select shipperID from shippers where shipperID=1)

-----------------INSERT ISLEMLERI-----------------
-- 66-> Kargolar tablosuna yeni bir kargo kaydi ekleyiniz...
INSERT INTO  Orders(CustomerID,EmployeeID,ShipVia) values ('ERNSH', 3,1)

-- 67-> Kendinizi bir calisan olarak Employees tablosuna ekleyiniz...
INSERT INTO Employees values('Topdal', 'Kamer', 'Junior Full-Stack Developer', 'Mrs.', '2003-01-20', '2023-03-02',  
'Reþitpaþa Street, Istanbul Technical University', 'Istanbul', 'Marmara', '34000','Turkey', '(544)8500858', '4748', '<No Binary Data>',
'She is a control engineer.', 5,'http://accweb/emmployees/davolio.bmp')

-----------------UPDATE YAPISI-----------------
-- 68-> 6 nolu kargo firmasinin telefon numarasýný (212) 888-4477 olarak guncelelyiniz.
update shippers set phone= '(212) 888-4477' where ShipperID=6

-----------------DELETE YAPISI-----------------
-- 70-> Kargolar tablosundaki KargoID'si 3ten buyuk butun kayitlar silinsin...
delete from orders where shipvia >3

-----------------VIEW OLUÞTURMA-----------------
-- 71-> Beverages kategorisine ait, Amerikali toptancilar tarafindan alinmis, stoklarimda mevcut urunlerin adlarini, ucretlerini, 
--KDV'li ucretlerini gosteren bir view tasarlayiniz.
CREATE VIEW [My view] as 
select productname [Ürün Ýsmi], unitprice Fiyatý, unitprice*1.18 [KDV' li Fiyatý] 
from (products inner join Categories on Products.CategoryID=Categories.CategoryID) inner join Suppliers on Suppliers.SupplierID= Products.SupplierID
where Categories.CategoryName='Beverages' and Suppliers.Country ='USA' and products.UnitsInStock is not null

select * from [My view]

-----------------STORED PROCEDURE-----------------
-- 72-> Disaridan girilen deger kadar urunlere zam yapan bir procedure tasarlayiniz...
Create Procedure zam_yap(@zam_miktari decimal(10,2))
as
begin
update products set UnitPrice = UnitPrice + (UnitPrice*@zam_miktari/100)
end

-- 73-> Disaridan girilen kategori adina ait urunleri listeleyen bir procedure tasarlayiniz...
create procedure listele(@CategoryName nvarchar(15))
as
select * from products inner join Categories on products.CategoryID=Categories.CategoryID where categoryname=@CategoryName

exec listele @categoryname='beverages'

-- 74-> Stok miktari disaridan girilen iki deger arasinda olan, urun ucreti disaridan girilen iki deger arasinda olan, 
--toptanci firma adi disaridan girilen harfi barindiran urunlerin adlarini, fiyatlarin, 
--toptanci sirket adlarini ve fiyatlarinin KDV eklenmis hallerini gosteren bir procedure tasarlayiniz...
create procedure GetData( @unitsInstockmax INT, @unitsInstockmin INT, @unitpricemax decimal(10,2), @unitpricemin decimal(10,2), @companyname nvarchar(40))
as
begin
select productname,unitprice,companyname,unitprice*1.18 as [KDV'li fiyat] 
from products inner join Suppliers on products.SupplierID= suppliers.SupplierID
where (products.unitsInstock between @unitsInstockmax and @unitsInstockmin) and (products.UnitPrice between @unitpricemax and @unitpricemin) 
and (suppliers.companyname like '%'+@companyname+'%')
end
EXEC GetData @unitsInstockmin = 10, @unitsInstockmax = 50,
@unitpricemin  = 10,  @unitpricemax = 100,
@companyname= 'A'

-- 75-> Disaridan kategori adi ve urun adi alan bir procedure tasarlayiniz. 
--Eger boyle bir kategori varsa, urun o kategoriye eklensin. Yoksa once baska bir procedure yardimiyla kategori eklesin, daha sonra o kategoriye urun eklensin...
 create procedure add_new_category @category_name nvarchar(15)
 as begin 
 insert into Categories (CategoryName) values (@category_name)
 print 'new category added' end

CREATE PROCEDURE add_product_to_category
    @category_name NVARCHAR(50),
    @product_name NVARCHAR(50)
AS
BEGIN
    -- Check if the category exists in the database
    IF EXISTS(SELECT * FROM Categories WHERE CategoryName = @category_name)
    BEGIN
        -- If the category exists, add the product to that category
        DECLARE @category_id INT
        SELECT @category_id = CategoryID FROM Categories WHERE CategoryName = @category_name
        
        INSERT INTO Products (ProductName, CategoryID)
        VALUES (@product_name, @category_id)
        
        PRINT 'Product added to the existing category.'
    END
    ELSE
    BEGIN
        -- If the category doesn't exist, call a different procedure to add the category
        EXEC add_new_category @category_name
        
        
        SELECT @category_id = CategoryID FROM Categories WHERE CategoryName = @category_name
        
        INSERT INTO Products (ProductName, CategoryID)
        VALUES (@product_name, @category_id)
        
        PRINT 'New category and product added.'
    END
END



-- 76-> Bir stored procedure tasarlayiniz. Bu procedure disaridan kategori adi ve aciklamasi alsin. 
--Eger boyle bir kategori yoksa eklesin, varsa bu kategori zaten var uyarisini kullaniciya iletsin!
create procedure storedProcedure @categoryname NVARCHAR(15), @description NTEXT 
as begin
if EXISTS(select * from categories where categoryname=@categoryname)
BEGIN 
print 'Bu kategori zaten var!'
END 
else 
BEGIN
insert into Categories (CategoryName, Description) values (@categoryname,@description)
end
end

-----------------FUNCTION (FONKSÝYONLAR)-----------------
-- 77-> Disaridan girilen iki degeri toplayan ve bize geri donduren bir fonksiyon yazalim...
create function sum_two_numbers ( 
@number1 Decimal(10,2), @number2 Decimal(10,2) 
)
returns decimal(10,2)
as
begin
declare @result decimal(10,2)
set @result = @number1+@number2 
return @result
end


-- 78-> Parametre olarak ad ve soyad bilgisini alan bir fonksiyon tasarlayiniz. Bu fonksiyon adin ilk harfini, soyadin sonuna ekleyerek @itu.edu.tr  uzantýlý tamamini kucuk harf yaparak geri dondursun...
create function getNameSurname (
@name nvarChar(20),
@surname nvarchar(20)
)
returns nvarchar(20)
as
begin
declare @completedName nvarchar(100)
set @completedName = lower(@surname+left(@name,1)+'@itu.edu.tr')
return @completedName
end

-- 79-> Disaridan bir tarih alan ve bu tarihe gore yas hesaplayan bir fonksiyon tasarlayiniz. Bu fonksiyonu Employees tablosunda bulunan personeller tablosuna uygulayarak personellerin yaþlarýný görüntüleyiniz. (Fonksiyon personel tablosundan baðýmsýz olarak tekil çalýþtýrýlabilmeli.) (FirstName, LastName, Yasi)
create function dbo.getAge(
@firstname nvarchar(10),
@lastname nvarchar(20),
@birthdate datetime
)
returns int
-- returns age
as 
begin
declare @age int
set @age=DATEDIFF(year,@birthdate, getdate())
if(month(@birthdate) > month(getdate())) or (month(@birthdate)=month(getdate()) and day(@birthdate)> day(getdate()))
set @age=@age-1
return @age
end 
--We can view the age of the employees.
SELECT EmployeeID, FirstName, LastName, dbo.getAge(FirstName, LastName,BirthDate) AS Age
FROM Employees
--We can also calculate the age with the data imported from user
declare @firstname nvarchar(10)= 'Burcu'
declare @lastname nvarchar(20)='Yýldýz'
declare @birthdate datetime ='2003-04-25'
select dbo.getAge(@firstname, @lastname, @birthdate) as Yaþ

