use AdventureWorks2019
GO

--1. retrieves the columns ProductID, Name, Color and ListPrice from the Production.Product table, with no filter. 
SELECT ProductID, Name, Color, ListPrice
FROM Production.Product

--2. retrieves the columns ProductID, Name, Color and ListPrice from the Production.Product table, excluding the rows that ListPrice is 0.
SELECT ProductID, Name, Color, ListPrice
FROM Production.Product
WHERE ListPrice != 0

--3. retrieves the columns ProductID, Name, Color and ListPrice from the Production.Product table, the rows that are not NULL for the Color column.
SELECT ProductID, Name, Color, ListPrice
FROM Production.Product
WHERE Color IS NOT NULL


--4. retrieves the columns ProductID, Name, Color and ListPrice from the Production.Product table, the rows that are not NULL for the Color columnr, and the column ListPrice has a value greater than zero..
SELECT ProductID, Name, Color, ListPrice
FROM Production.Product
WHERE Color IS NOT NULL and ListPrice>0


--5. Write a query that concatenates the columns Name and Color from the Production.Product table by excluding the rows that are null for color.
SELECT Name + Color
FROM Production.Product
WHERE Color IS NOT NULL 

--6. 
SELECT TOP 6 Name +' -- ' + Color
FROM Production.Product
WHERE Color IS NOT NULL 

--7. Write a query to retrieve the to the columns ProductID and Name from the Production.Product table filtered by ProductID from 400 to 500 using between

SELECT ProductID, Name
FROM Production.Product
WHERE ProductID between 400 and 500

--8. Write a query to retrieve the to the columns  ProductID, Name and color from the Production.Product table restricted to the colors black and blue
SELECT ProductID, Name, Color
FROM Production.Product
WHERE Color IN ('Black', 'Blue')

--9. Write a query to get a result set on products that begins with the letter S
SELECT Name
FROM Production.Product
WHERE Name like 'S%'

--10. Write a query that retrieves the columns Name and ListPrice from the Production.Product table. Your result set should look something like the following. Order the result set by the Name column. The products name should start with either 'A' or 'S'

SELECT Name, ListPrice
FROM Production.Product
WHERE Name like '[A|S]%' 
ORDER BY Name

--11.  retrieve rows that have a Name that begins with the letters SPO, but is then not followed by the letter K. After this zero or more letters can exists. Order the result set by the Name column.
SELECT Name, ListPrice
FROM Production.Product
WHERE Name like 'SPO[^K]%' 
ORDER BY Name



--12. retrieves the unique combination of columns ProductSubcategoryID and Color from the Production.Product table. We do not want any rows that are NULL.in any of the two columns in the result. (Hint: Use IsNull)
SELECT distinct ISNULL(p.ProductSubcategoryID, '0'), ISNULL(p.Color, 'No Color')
FROM Production.Product p




-------------------------------------------------------------------------------------------------------------


--please check the solution below:
USE [AdventureWorks2019] 
----- 1 ---- select productid,Name,Color,ListPrice from [Production].[Product]
----- 2 ----- select productid,Name,Color,ListPrice from [Production].[Product] where ListPrice 0
----- 3 -----select productid,Name,Color,ListPrice from [Production].[Product]  where color is null
----- 4 ----- select productid,Name,Color,ListPrice from [Production].[Product] where color is not null and ListPrice > 0
------ 5 ---- select Name+':'+color from production.Product where color is not null
----- 6 ----- select 'NAME: '+ name+' -- COLOR: '+ color from production.product where color is not null
------ 7 ------- select productid,Name from [Production].[Product] where productid between 400 and 500
----- 8 ------ select productid,Name,Color from [Production].[Product] where color in ('Black','Blue')
------ 9 ----- select productid,Name,Color,ListPrice from [Production].[Product] where name like 'S%' 

------ 10 ------ select Name,ListPrice from Production.Product where Name like 'S%' or Name like 'A%' 
----- 11 ------ SELECT [Name], ListPrice  FROM Production.Product WHERE [Name] LIKE 'spo[^k]%' ORDER BY [Name]

------ 12 ------ select distinct ProductSubcategoryID ,Color from Production.Product where Color is not null and ProductSubcategoryID is not null order by ProductSubcategoryID,Color


