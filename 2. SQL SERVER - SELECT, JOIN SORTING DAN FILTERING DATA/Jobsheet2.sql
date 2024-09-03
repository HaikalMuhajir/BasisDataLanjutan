USE TSQL;
GO

SELECT  [custid],
		[companyname],
		[contactname],
		[contacttitle],
		[address],
		[city],
		[region],
		[postalcode],
		[country],
		[phone],
		[fax]
	FROM [Sales].[Customers];
GO

SELECT *
	FROM Sales.Customers;
GO

SELECT
		custid, companyname, contactname, contacttitle, address, city, region, postalcode,
		country, phone, fax
	FROM Sales.Customers;
GO

SELECT *
	FROM [Sales].[Customers];

GO

SELECT
	contactname, address, postalcode, city, country
	FROM Sales.Customers;
GO

SELECT country
	FROM Sales.Customers;
GO

SELECT DISTINCT
	country
FROM Sales.Customers;
GO

SELECT
	c.contactname, c.contacttitle
FROM Sales.Customers AS c;

GO

SELECT
	c.contactname AS Name, c.contacttitle AS Title, c.companyname AS [Company Name]
FROM Sales.Customers AS c;

GO

SELECT
	p.categoryid, p.productname
FROM Production.Products AS p;

GO

SELECT
	p.categoryid, p.productname,
	CASE
		WHEN p.categoryid = 1 THEN 'Beverages'
		WHEN p.categoryid = 2 THEN 'Condiments'
		WHEN p.categoryid = 3 THEN 'Confections'
		WHEN p.categoryid = 4 THEN 'Dairy Products'
		WHEN p.categoryid = 5 THEN 'Grains/Cereals'
		WHEN p.categoryid = 6 THEN 'Meat/Poultry'
		WHEN p.categoryid = 7 THEN 'Produce'
		WHEN p.categoryid = 8 THEN 'Seafood'
		ELSE 'Other'
	END AS categoryname
FROM Production.Products AS p;

GO

SELECT
	p.categoryid, p.productname,
	CASE
		WHEN p.categoryid = 1 THEN 'Beverages'
		WHEN p.categoryid = 2 THEN 'Condiments'
		WHEN p.categoryid = 3 THEN 'Confections'
		WHEN p.categoryid = 4 THEN 'Dairy Products'
		WHEN p.categoryid = 5 THEN 'Grains/Cereals'
		WHEN p.categoryid = 6 THEN 'Meat/Poultry'
		WHEN p.categoryid = 7 THEN 'Produce'
		WHEN p.categoryid = 8 THEN 'Seafood'
		ELSE 'Other'
	END AS categoryname,
	CASE
		WHEN p.categoryid IN (1,7,8) THEN 'Campaign Products'
		ELSE 'Non-Campaign Products'
	END AS iscampaign
FROM Production.Products AS p;

GO

SELECT
    p.categoryid AS ID_KATEGORI, 
    p.productname AS NAMA_PRODUK,
    'Seafood' AS NAMA_KATEGORI,
    'Campaign Products' AS STATUS
FROM 
    Production.Products AS p
WHERE 
    p.categoryid = 8;
GO

SELECT
	e.firstname AS FIRST_NAME,
	e.lastname AS LAST_NAME,
	e.city AS CITY,
	e.country AS COUNTRY
FROM
	HR.Employees AS e
WHERE
	e.city = 'Seattle' AND e.country = 'USA';

GO



SELECT  DISTINCT p.productname AS NAMA_PRODUK, c.categoryname AS KATEGORI_PRODUK
FROM Production.Products AS p
	INNER JOIN 
	Production.Categories AS c
	ON
	p.categoryid = c.categoryid;

GO

SELECT
Sales.Customers.custid, contactname, orderid
FROM Sales.Customers 
INNER JOIN Sales.Orders ON Sales.Customers.custid = Sales.Orders.custid;

GO

SELECT
    c.custid, 
    c.contactname, 
    o.orderid
FROM 
    Sales.Customers AS c
INNER JOIN 
    Sales.Orders AS o 
ON 
    c.custid = o.custid;
GO

SELECT 
	e.empid, e.lastname, e.firstname, e.title, e.mgrid
FROM 
	HR.Employees AS e
GO

SELECT
    e1.empid, 
    e1.lastname + ' ' + e1.firstname AS [Employee Name], 
    e1.title, 
    e1.mgrid, 
    e2.lastname + ' ' + e2.firstname AS [Manager Name]
FROM 
    HR.Employees AS e1
INNER JOIN
    HR.Employees AS e2 ON e1.mgrid = e2.empid
GO

SELECT 
	c.custid, c.contactname,o.orderid
FROM 
	Sales.Customers AS c
FULL JOIN
	Sales.Orders AS o ON c.custid = o.custid

GO

SET NOCOUNT ON;

IF OBJECT_ID('HR.Calendar') IS NOT NULL 
	DROP TABLE HR.Calendar;

CREATE TABLE HR.Calendar (
	calendardate DATE CONSTRAINT PK_Calendar PRIMARY KEY
);

DECLARE 
	@startdate DATE = DATEFROMPARTS(YEAR(SYSDATETIME()), 1, 1),
	@enddate DATE = DATEFROMPARTS(YEAR(SYSDATETIME()), 12, 31);

WHILE @startdate <= @enddate
BEGIN
	INSERT INTO HR.Calendar (calendardate)
	VALUES (@startdate);

	SET @startdate = DATEADD(DAY, 1, @startdate);
END;

SET NOCOUNT OFF;

GO
-- observe the HR.Calendar table
SELECT 
	calendardate
FROM HR.Calendar;

SELECT
	e.empid, e.firstname, e.lastname, c.calendardate
FROM
	HR.Employees AS e
CROSS JOIN
	HR.Calendar AS c

GO

DROP TABLE HR.Calendar;

GO

SELECT 
custid, companyname, contactname, address, city, country, phone
FROM Sales.Customers
WHERE
country = N'Brazil';

GO

SELECT
custid, companyname, contactname, address, city,country, phone
FROM
Sales.Customers
WHERE
country IN (N'Brazil', N'UK', N'USA');
GO

SELECT 
	c.custid, c.companyname, o.orderid
FROM Sales.Customers AS c
LEFT OUTER JOIN Sales.Orders AS o ON c.custid = o.custid 
where c.city LIKE 'paris'

GO

SELECT c.custid, c.contactname, o.orderid, o.orderdate
FROM Sales.Customers AS c
JOIN Sales.Orders AS o
ON c.custid = o.custid
WHERE o.orderdate >= '2008-04-1'
ORDER BY 
o.orderdate DESC,
c.custid ASC;

GO

SELECT
e.empid, e.lastname, e.firstname, e.title, e.mgrid,
m.lastname AS mgrlastname, m.firstname AS mgrfirstname
FROM HR.Employees AS e
INNER JOIN HR.Employees AS m ON e.mgrid = m.empid
WHERE 
m.lastname = N'Buck';

GO

SELECT
e.empid, e.lastname, e.firstname, e.title, e.mgrid,
m.lastname AS mgrlastname, m.firstname AS mgrfirstname
FROM HR.Employees AS e
INNER JOIN HR.Employees AS m ON e.mgrid = m.empid
ORDER BY
m.firstname ASC

GO

SELECT
productname, unitprice
FROM Production.Products
ORDER BY
unitprice DESC;

GO

SELECT TOP 10 PERCENT
productname, unitprice
FROM Production.Products
ORDER BY
unitprice DESC;

GO

SELECT
productname, unitprice
FROM Production.Products
ORDER BY
unitprice DESC
OFFSET 0 ROWS
FETCH NEXT 8 ROWS ONLY;

GO

SELECT
custid, orderid, orderdate
FROM Sales.orders
ORDER BY 
orderdate, orderid ASC
OFFSET 20 ROWS
FETCH NEXT 20 ROWS ONLY;


