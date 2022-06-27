use Northwind
GO

--1.      Create a view named ¡°view_product_order_[your_last_name]¡±, list all products and total ordered quantity for that product.
CREATE VIEW view_product_order_LIU AS
SELECT p.ProductID, SUM(od.Quantity) as [total ordered quantity]
FROM [Order Details] od join Orders o on od.OrderID = o.OrderID join Products p on od.ProductID = p.ProductID
GROUP BY p.ProductID


SELECT * 
FROM view_product_order_LIU

-- 2.      Create a stored procedure ¡°sp_product_order_quantity_[your_last_name]¡± that accept product id as an input and total quantities of order as output parameter.

DROP PROCEDURE sp_product_order_quantity_LIU;  
CREATE PROC sp_product_order_quantity_LIU
@prodID int
AS
BEGIN
SELECT SUM(od.Quantity) as totalquantitiey
FROM [Order Details] od
WHERE od.ProductID = @prodID
END


exec sp_product_order_quantity_LIU 14


--3.      Create a stored procedure ¡°sp_product_order_city_[your_last_name]¡± that accept product name as an input and top 5 cities that ordered most that product combined with the total quantity of that product ordered from that city as output.

DROP PROCEDURE sp_product_order_city_LIU;  
CREATE PROC sp_product_order_city_LIU
@prodName nvarchar(40)
AS
BEGIN
SELECT TOP 5 o.ShipCity, SUM(od.Quantity) as nbCity
FROM [Order Details] od join Orders o on od.OrderID = o.OrderID join Products p on od.ProductID = p.ProductID
WHERE p.ProductName = @prodName
GROUP BY o.ShipCity
ORDER BY nbCity desc
END


exec sp_product_order_city_LIU 'Tofu'


-- 4.      Create 2 new tables ¡°people_your_last_name¡± ¡°city_your_last_name¡±. City table has two records: {Id:1, City: Seattle}, {Id:2, City: Green Bay}. People has three records: {id:1, Name: Aaron Rodgers, City: 2}, {id:2, Name: Russell Wilson, City:1}, {Id: 3, Name: Jody Nelson, City:2}. Remove city of Seattle. If there was anyone from Seattle, put them into a new city ¡°Madison¡±. Create a view ¡°Packers_your_name¡± lists all people from Green Bay. If any error occurred, no changes should be made to DB. (after test) Drop both tables and view.



DROP TABLE city_LIU
CREATE TABLE city_LIU(Id int primary key, City varchar(40))

DROP TABLE people_LIU
CREATE TABLE people_LIU(id int primary key, Name varchar(40), City int foreign key references city_LIU(Id) on  delete cascade)

--DROP TABLE city_LIU
INSERT INTO city_LIU VALUES(1, 'Seattle')
INSERT INTO city_LIU VALUES(2,  'Green Bay')

--TRUNCATE TABLE people_LIU
INSERT INTO people_LIU VALUES(1,  'Aaron Rodgers', 2)
INSERT INTO people_LIU VALUES(2,  'Russell Wilson', 1)
INSERT INTO people_LIU VALUES(3,  'Jody Nelson', 2)

SELECT * FROM city_LIU
SELECT * FROM people_LIU

--DELETE FROM city_LIU WHERE City='Seattle'

BEGIN TRAN
--CREATE TABLE people_LIU_backup(id int primary key, Name varchar(40), City int foreign key references city_LIU(Id) on  delete cascade)
--INSERT INTO people_LIU_backup(id, Name,City)
IF OBJECT_ID('tempdb..#Temppeople_LIU_backup') IS NOT NULL
DROP TABLE #Temppeople_LIU_backup

    SELECT p1.id, p1.Name,p1.City
    INTO #Temppeople_LIU_backup
    FROM people_LIU p1 join city_LIU on p1.City = city_LIU.Id 
    WHERE city_LIU.City = 'Seattle'

IF OBJECT_ID('tempdb..#Tempcity_LIU') IS NOT NULL
DROP TABLE #Tempcity_LIU

SELECT Id, 'Madison' as City
    INTO #Tempcity_LIU
    FROM city_LIU 
    WHERE city_LIU.City = 'Seattle'

DELETE FROM city_LIU WHERE City='Seattle'

INSERT INTO city_LIU(id, City)
   SELECT * FROM #Tempcity_LIU

INSERT INTO people_LIU(id,Name, City)
    SELECT * FROM #Temppeople_LIU_backup

commit

SELECT * FROM city_LIU
SELECT * FROM people_LIU


CREATE VIEW Packers_LIU
AS 
SELECT p1.Name FROM people_LIU p1 join city_LIU c1 on p1.City=c1.Id WHERE c1.City='Green Bay'

SELECT * FROM Packers_LIU

-- 5.       Create a stored procedure ¡°sp_birthday_employees_[you_last_name]¡± that creates a new table ¡°birthday_employees_your_last_name¡± and fill it with all employees that have a birthday on Feb. (Make a screen shot) drop the table. Employee table should not be affected.

DROP PROCEDURE sp_birthday_employees_LIU

CREATE PROC sp_birthday_employees_LIU
AS
BEGIN
CREATE TABLE birthday_employees_LIU(eid int)

INSERT INTO birthday_employees_LIU(eid)
    SELECT e.EmployeeID FROM  Employees e WHERE MONTH(e.BirthDate)=2
END


exec sp_birthday_employees_LIU

SELECT * FROM birthday_employees_LIU

SELECT * FROM  Employees 

DROP TABLE birthday_employees_LIU

SELECT * FROM  Employees 

-- 6.      How do you make sure two tables have the same data?

-- Using union, select * from two tables and then check if the row number after union is greater than the max number of rows of the two tables
