use AdventureWorks2019
GO

--1. Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables. Join them and produce a result set similar to the following.
SELECT cr.Name as Country, sp.Name as Province
FROM person.CountryRegion cr JOIN person.StateProvince sp ON cr.CountryRegionCode = sp.CountryRegionCode

--2. Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables and list the countries filter them by Germany and Canada. Join them and produce a result set similar to the following.
SELECT cr.Name as Country, sp.Name as Province
FROM person.CountryRegion cr JOIN person.StateProvince sp ON cr.CountryRegionCode = sp.CountryRegionCode
WHERE cr.Name in ('Germany', 'Canada')


use Northwind
GO

--3. List all Products that has been sold at least once in last 25 years.
SELECT distinct p.ProductName
FROM [Order Details] od join Orders o on od.OrderID = o.OrderID join Products p on od.ProductID = p.ProductID
WHERE o.ShippedDate IS NOT NULL and  DATEDIFF(year, o.ShippedDate,  GETDATE())<=25



--4. List top 5 locations (Zip Code) where the products sold most in last 25 years. (different country may have same postalcode)
SELECT TOP 5 o.ShipPostalCode, COUNT(o.OrderID) as nbOrders
FROM [Order Details] od join Orders o on od.OrderID = o.OrderID join Products p on od.ProductID = p.ProductID
WHERE  DATEDIFF(year, o.ShippedDate,  GETDATE())<=25
GROUP BY o.ShipCountry, o.ShipPostalCode
ORDER BY nbOrders desc

--5. List all city names and number of customers in that city. (same city name ignored) 
SELECT City, COUNT(CustomerID)
FROM Customers 
GROUP BY City

--6. List city names which have more than 2 customers, and number of customers in that city
SELECT cnt.City, cnt.nbCustomer
FROM (SELECT City, COUNT(CustomerID) as nbCustomer
    FROM Customers 
    GROUP BY City) as cnt
WHERE cnt.nbCustomer > 2

--7. Display the names of all customers  along with the  count of products they bought
SELECT cu.ContactName, cnt.[count of products]
FROM Customers cu join (SELECT o.CustomerID, COUNT(o.OrderID) as [count of products]
    FROM Orders o
    GROUP BY o.CustomerID) cnt on cu.CustomerID = cnt.CustomerID

--8. Display the customer ids who bought more than 100 Products with count of products.
SELECT o.CustomerID
FROM Orders o
GROUP BY o.CustomerID
HAVING COUNT(o.OrderID)>100

--9. List all of the possible ways that suppliers can ship their products. Display the results as below
SELECT su.CompanyName as [ Supplier Company Name], sh.CompanyName as [Shipping Company Name]
FROM Shippers sh CROSS JOIN Suppliers su

--10. Display the products order each day. Show Order date and Product Name.
SELECT o.OrderDate, p.ProductName
FROM [Order Details] od join Orders o on od.OrderID = o.OrderID join Products p on od.ProductID = p.ProductID
GROUP BY o.OrderDate, p.ProductName


--11. Displays pairs of employees who have the same job title.
SELECT e1.FirstName +' ' +e1.LastName, e2.FirstName +' ' +e2.LastName, e1.Title
FROM Employees e1 join Employees e2 on e1.Title = e2.Title and e1.EmployeeID != e2.EmployeeID

--12. Display all the Managers who have more than 2 employees reporting to them.
SELECT m.FirstName+' '+m.LastName
FROM (SELECT e.ReportsTo, COUNT(e.EmployeeID) as nbRepoter
FROM Employees e
GROUP BY e.ReportsTo) as cnt join Employees m on cnt.ReportsTo = m.EmployeeID
WHERE cnt.nbRepoter > 2

--13. Display the customers and suppliers by city. The results should have the following columns
SELECT c.City as [City Name], c.ContactName as [Contact Name], c.ctype as Type 
FROM (SELECT City, ContactName, 'Customers' as ctype
       FROM Customers
       UNION
       SELECT City, ContactName, 'Suppliers'  as ctype
       FROM Suppliers) as c

--14. List all cities that have both Employees and Customers.
SELECT c.City as [City Name]
FROM (SELECT City,  'Customers' as ctype
       FROM Customers
       UNION
       SELECT City,  'Suppliers'  as ctype
       FROM Employees) as c
GROUP BY c.City
HAVING COUNT(c.ctype)>=2

--15a. List all cities that have Customers but no Employee.
SELECT c.City as [City Name]
FROM (SELECT City,  -1 as ctype
       FROM Customers
       UNION ALL
       SELECT City,  1  as ctype
       FROM Employees) as c
GROUP BY c.City
HAVING SUM(c.ctype)=-1

--15b. List all cities that have Customers but no Employee.
SELECT c.City as [City Name]
FROM Customers c left join Suppliers su on c.City = su.City
WHERE su.City is NULL


--16. List all products and their total order quantities throughout all orders.
SELECT p.ProductName, SUM(od.Quantity)
FROM Products p left join  [Order Details] od on od.ProductID = p.ProductID join Orders o on od.OrderID = o.OrderID  
GROUP BY p.ProductName


--17a. List all Customer Cities that have at least two customers.
SELECT distinct newc.City
FROM (SELECT c1.City, c1.ContactName as cc1, c2.ContactName as cc2
FROM Customers c1 left join Customers c2 on c1.City = c2.City and c1.CustomerID != c2.CustomerID
UNION 
SELECT c2.City, c1.ContactName as cc1, c2.ContactName as cc2
FROM Customers c1 right join Customers c2 on c1.City = c2.City and c1.CustomerID != c2.CustomerID
) as newc
WHERE newc.cc1 is not NULL and newc.cc2 is not NULL 


--17b. List all Customer Cities that have at least two customers.
SELECT c.City
FROM (SELECT City, COUNT(CustomerID) as cnt
FROM Customers
GROUP BY City) as c
WHERE c.cnt>=2

--18. List all Customer Cities that have ordered at least two different kinds of products.
SELECT c.City
FROM (SELECT City, COUNT(od.ProductID) as cnt
FROM Customers c join Orders o on c.CustomerID=o.CustomerID join [Order Details] od on od.OrderID = o.OrderID 
GROUP BY City) as c
WHERE c.cnt>=2

--19. List 5 most popular products, their average price, and the customer city that ordered most quantity of it.

--SELECT TOP 5 od.ProductID, COUNT(od.OrderID) as popular, AVG(od.UnitPrice  * (1-od.Discount)) AS Avgprice
--FROM (Customers c join Orders o on c.CustomerID=o.CustomerID join [Order Details] od on od.OrderID = o.OrderID )
--GROUP BY od.ProductID
--ORDER BY popular desc

--SELECT res.ProductID,  c1.City, COUNT(od1.ProductID) as cnt
--FROM (SELECT distinct TOP 5  od.ProductID, COUNT(od.OrderID) OVER(PARTITION BY od.ProductID) as popular, AVG(od.UnitPrice  * (1-od.Discount))  OVER(PARTITION BY od.ProductID) AS avgprice
--FROM (Customers c join Orders o on c.CustomerID=o.CustomerID join [Order Details] od on od.OrderID = o.OrderID )
--ORDER BY popular desc
--) res join [Order Details] od1 on od1.ProductID = res.ProductID join Orders o1 on od1.OrderID = o1.OrderID  join Customers c1 on c1.CustomerID=o1.CustomerID 
--GROUP BY res.ProductID, c1.City
--ORDER BY res.ProductID, cnt


--SELECT distinct TOP 5  od.ProductID, COUNT(od.OrderID) OVER(PARTITION BY od.ProductID) as popular, AVG(od.UnitPrice  * (1-od.Discount))  OVER(PARTITION BY od.ProductID) AS avgprice, c.City
--FROM (Customers c join Orders o on c.CustomerID=o.CustomerID join [Order Details] od on od.OrderID = o.OrderID )
--WHERE (SELECT TOP 1 COUNT(od.ProductID) OVER(PARTITION BY c.City) 
--        --FROM ( c join  o on c.CustomerID=o.CustomerID join [Order Details] od2 on od2.OrderID = o.OrderID )
--        ) = (SELECT distinct TOP 1  COUNT(od1.ProductID) OVER(PARTITION BY c.City) as cityconsumption
--            FROM ( c join  o on c.CustomerID=o.CustomerID join [Order Details] od1 on od1.OrderID = o.OrderID )
--             WHERE od.ProductID = od1.ProductID
--             ORDER BY cityconsumption desc)
--ORDER BY popular desc


--CREATE FUNCTION getTOPCity(@prodid int)
--returns  nvarchar(15) 
--AS
--BEGIN
--return City FROM 
--     (SELECT distinct  COUNT(c1.City) OVER(PARTITION BY od1.ProductID) as cityconsumption,od1.ProductID, c1.City
--         FROM Customers c1 join Orders o1 on c1.CustomerID=o1.CustomerID join [Order Details] od1 on od1.OrderID = o1.OrderID 
--            ) where ...
--END



--WITH temp_table AS (SELECT distinct  COUNT(od1.ProductID) OVER(PARTITION BY c1.City) as cityconsumption,od1.ProductID, c1.City
--            FROM Customers c1 join Orders o1 on c1.CustomerID=o1.CustomerID join [Order Details] od1 on od1.OrderID = o1.OrderID 
----             WHERE od.ProductID = od1.ProductID and  c.City = c1.City
--             ORDER BY cityconsumption desc
--             )

WITH temp_table AS (SELECT 
                        ROW_NUMBER() OVER (PARTITION BY od1.ProductID ORDER BY COUNT(c1.City) DESC) rn, 
                        od1.ProductID, c1.City, 
                        COUNT(c1.City) OVER (PARTITION BY od1.ProductID ) cnt
            FROM Customers c1 join Orders o1 on c1.CustomerID=o1.CustomerID join [Order Details] od1 on od1.OrderID = o1.OrderID
             GROUP BY od1.ProductID, c1.City
             )


--SELECT 
--                        --ROW_NUMBER() OVER (PARTITION BY od1.ProductID ORDER BY COUNT(c1.City) DESC) rn, 
--                        od1.ProductID, c1.City, 
--                        COUNT(c1.City) OVER (PARTITION BY od1.ProductID ) cnt
--            FROM Customers c1 join Orders o1 on c1.CustomerID=o1.CustomerID join [Order Details] od1 on od1.OrderID = o1.OrderID 
--             WHERE c1.City='London'
-------- not work when using outter where and PARTITION BY together-------------------


SELECT distinct TOP 5  od.ProductID, COUNT(od.OrderID) OVER(PARTITION BY od.ProductID) as popular, AVG(od.UnitPrice  * (1-od.Discount))  OVER(PARTITION BY od.ProductID) AS avgprice
, (SELECT tt.City FROM temp_table tt WHERE od.ProductID=tt.ProductID and tt.rn=1)
FROM Customers c join Orders o on c.CustomerID=o.CustomerID join [Order Details] od on od.OrderID = o.OrderID 
--WHERE cityconsumption = (SELECT MAX(tt1.cityconsumption) FROM temp_table  tt1 WHERE tt1.ProductID = tt.ProductID)
ORDER BY popular desc


--SELECT distinct TOP 5  od.ProductID, COUNT(od.OrderID) OVER(PARTITION BY od.ProductID) as popular, AVG(od.UnitPrice  * (1-od.Discount))  OVER(PARTITION BY od.ProductID) AS avgprice, c.City
--FROM Customers c join Orders o on c.CustomerID=o.CustomerID join [Order Details] od on od.OrderID = o.OrderID 
--WHERE EXISTS (SELECT distinct TOP 1  COUNT(od.ProductID) OVER(PARTITION BY c.City) as cityconsumption11
--            FROM (c join o on c.CustomerID=o.CustomerID join od on od.OrderID = o.OrderID )
--             ORDER BY cityconsumption11 desc) 









--20. List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is, and also the city of most total quantity of products ordered from. (tip: join  sub-query)

--WITH total_order AS (SELECT TOP 1 c.City,  COUNT(o.OrderID) cnt
--FROM Customers c join Orders o on c.CustomerID=o.CustomerID 
--GROUP BY c.City
--ORDER BY cnt desc
--)
DROP FUNCTION IF EXISTS dbo.totalorder;

CREATE FUNCTION totalorder()
returns TABLE
AS
return 
    SELECT TOP 1 c.City
    ,  COUNT(o.OrderID) cnt
    FROM Customers c join Orders o on c.CustomerID=o.CustomerID 
    GROUP BY c.City
    ORDER BY cnt desc
    


--SELECT City
--FROM dbo.totalorder()

DROP FUNCTION IF EXISTS dbo.totalquantity;

CREATE FUNCTION totalquantity()
returns TABLE
AS
return  (SELECT TOP 1 c.City,  SUM(od.Quantity) cnt
    FROM Customers c join Orders o on c.CustomerID=o.CustomerID join [Order Details] od on od.OrderID = o.OrderID 
    GROUP BY c.City
    ORDER BY cnt desc)

SELECT tq.City
FROM dbo.totalquantity() as tq
INTERSECT   
SELECT too.City
FROM dbo.totalorder() as too




--21. How do you remove the duplicates record of a table?
--using Group By and having clause, if having count > 1 then there's duplicate
--using row_number() e.g.
WITH dup_table AS (SELECT 
                        ROW_NUMBER() OVER (PARTITION BY od1.ProductID, c1.City ORDER BY COUNT(od1.ProductID) DESC) as duplicate_cnt,
                        od1.ProductID, c1.City
            FROM Customers c1 join Orders o1 on c1.CustomerID=o1.CustomerID join [Order Details] od1 on od1.OrderID = o1.OrderID
             GROUP BY od1.ProductID, c1.City
             )
DELETE FROM dup_table
WHERE duplicate_cnt > 1;


--using rank() e.g.
WITH dup_table AS (SELECT od1.ProductID, c1.City,
                        RANK() OVER (PARTITION BY od1.ProductID, c1.City ORDER BY COUNT(od1.ProductID) DESC) as duplicate_cnt
                        
            FROM Customers c1 join Orders o1 on c1.CustomerID=o1.CustomerID join [Order Details] od1 on od1.OrderID = o1.OrderID
             GROUP BY od1.ProductID, c1.City
             )
DELETE FROM dup_table
WHERE duplicate_cnt > 1;
