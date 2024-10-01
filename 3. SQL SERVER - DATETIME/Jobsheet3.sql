SELECT 
	GETDATE() AS currentdatetime,
	CAST(GETDATE() AS DATE) AS currentdate,
	CONVERT(TIME, GETDATE()) AS currenttime,
	YEAR(GETDATE()) AS currentyear,
	MONTH(GETDATE()) AS currentmonth,
	DAY(GETDATE()) AS currentday,
	DATEPART(WEEK, GETDATE()) AS currentweeknumber,
	DATENAME(MONTH, GETDATE()) AS currentmonthname;
GO

SELECT
	CAST(GETDATE() AS DATE) AS todaysdate;
GO

SELECT
	LEFT(DATENAME(MONTH, GETDATE()), 3) + ' ' +
	CAST(DATEPART(DAY, GETDATE()) AS VARCHAR (2)) + ', ' + 
	CONVERT(VARCHAR (4), DATEPART(YEAR, GETDATE())) AS todaysdate;
GO

SELECT
	FORMAT(GETDATE(), 'dd MMM yyyy') AS todaysdate;
GO

SELECT
	DATEADD(MONTH, 5, GETDATE()) AS fivemonths,
	DATEDIFF(DAY, GETDATE(), DATEADD(MONTH, 5, GETDATE())) AS diffdays,
	DATEDIFF(WEEK, '1945-08-17', '2022-08-17') AS diffweeks,
	CONVERT(DATETIME, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1)) AS firstday;
GO
	
USE TSQL;
GO

SELECT 
	CASE 
		WHEN ISDATE(isitdate) = 1 THEN CAST(isitdate AS DATE)
		ELSE NULL
	END AS converteddate
FROM Sales.Somedates;
GO

SELECT 
	custid,
	shipname,
	shippeddate
FROM Sales.Orders
WHERE 
	YEAR(shippeddate) = 2008 
	AND MONTH(shippeddate) = 3
ORDER BY
custid ASC;
GO

SELECT
	SYSDATETIME() AS currentdatetime,
	CONVERT(DATETIME, DATEFROMPARTS(YEAR(SYSDATETIME()), MONTH(SYSDATETIME()), 1)) AS firstdaythemonth,
	CAST(EOMONTH(SYSDATETIME()) AS DATETIME) AS endofthemonth;
GO

SELECT
	orderid,
	custid,
	orderdate,
	shipaddress
FROM Sales.Orders
WHERE 
	DAY(orderdate) > (DAY(EOMONTH(orderdate)) -5)
	AND
	DAY(orderdate) <= DAY(EOMONTH(orderdate));
GO

SELECT 
	contactname + ' (city: ' + city + ')' AS contactdetails
FROM Sales.Customers;
GO

SELECT 
	contactname,
	contacttitle
FROM Sales.Customers
WHERE 
	LEFT(contactname, 1) BETWEEN 'A' AND 'G';
GO

SELECT 
	REPLACE(contactname, ',',' ') AS contactname,
	SUBSTRING(contactname, 1, CHARINDEX(',', contactname) - 1) AS lastname
FROM
	Sales.Customers;
GO

SELECT
	custid,
	'C' + RIGHT('00000' + CAST(custid AS VARCHAR(4)), 4) AS newcustid
FROM Sales.Customers;
GO

SELECT 
	contactname,
	LEN(contactname) - LEN(REPLACE(contactname, 'a','')) AS numberofa
FROM Sales.Customers;
	