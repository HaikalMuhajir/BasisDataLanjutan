
USE TSQL;

SELECT
    productid AS [ID PRODUK],
    productname AS [NAMA PRODUK],
    supplierid AS [ID SUPPLIER],
    unitprice AS [HARGA SATUAN],
    discontinued AS [BERLANJUT]
FROM Production.Products
WHERE categoryid = 1;
    GO

CREATE VIEW Production.ProductBeverages
AS
    SELECT
        productid,
        productname,
        supplierid,
        unitprice,
        discontinued
    FROM Production.Products
    WHERE categoryid = 1;
    GO

SELECT productid, productname
FROM Production.ProductBeverages
WHERE supplierid = 1;
    GO

ALTER VIEW Production.ProductBeverages
AS
    SELECT TOP(100) PERCENT
        productid, productname, supplierid, unitprice, discontinued
    FROM Production.Products
    WHERE categoryid = 1
    ORDER BY productname;
    GO

SELECT *
FROM Production.ProductBeverages;
    GO

ALTER VIEW Production.ProductBeverages
AS
    SELECT
        productid, productname, supplierid, unitprice, discontinued,
        CASE WHEN unitprice > 100. THEN N'high' ELSE N'normal'END AS pricecategory
    FROM Production.Products
    WHERE categoryid = 1;
    GO

IF OBJECT_ID(N'Production.ProductBeverages', N'V') IS NOT NULL
    DROP VIEW Production.ProductBeverages;
    GO

SELECT 
    p.productid,
    p.productname
FROM (
    SELECT productid, productname
    FROM Production.Products
    WHERE unitprice > 100 AND categoryid = 1
) AS p;
GO

SELECT 
    p.productid,
    p.productname
FROM (
    SELECT productid, productname
    FROM Production.ProductBeverages
    WHERE pricecategory = N'high'
) AS p;
GO

SELECT 
    d.custid,
    SUM(d.order_total) AS totalsalesamount,
    AVG(d.order_total) AS avgsalesamount
FROM (
    SELECT 
        o.custid,
        o.orderid,
        SUM(od.unitprice * od.qty) AS order_total  -- Menghitung total nominal per order
    FROM Sales.Orders AS o
    JOIN Sales.OrderDetails AS od ON o.orderid = od.orderid
    GROUP BY o.custid, o.orderid  -- Mengelompokkan berdasarkan custid dan orderid
) AS d
GROUP BY d.custid;  -- Mengelompokkan hasil akhir berdasarkan custid
GO



SELECT 
    cur.orderyear,
    cur.totalsales AS curtotalsales,
    ISNULL(prev.totalsales, 0) AS prevtotalsales,  -- Jika tidak ada data sebelumnya, atur ke 0
    CASE 
        WHEN ISNULL(prev.totalsales, 0) = 0 THEN NULL  -- Menghindari pembagian dengan nol
        ELSE ((cur.totalsales / prev.totalsales) * 100) 
    END AS percentgrowth
FROM (
    SELECT 
        YEAR(orderdate) AS orderyear,
        SUM(val) AS totalsales
    FROM Sales.OrderValues
    GROUP BY YEAR(orderdate)
) AS cur
LEFT JOIN (
    SELECT 
        YEAR(orderdate) AS orderyear,
        SUM(val) AS totalsales
    FROM Sales.OrderValues
    GROUP BY YEAR(orderdate)
) AS prev ON cur.orderyear = prev.orderyear + 1;  -- Mengaitkan tahun saat ini dengan tahun sebelumnya
GO

SELECT 
    p.productid,
    p.productname
FROM (
    SELECT productid, productname
    FROM Production.ProductBeverages
    WHERE pricecategory = N'high'
) AS p;
GO

WITH ProductBeverages AS (
	SELECT productid, productname,
	CASE
		WHEN unitprice > 100. 
		THEN N'high' 
		ELSE N'normal' END AS pricetype
	FROM Production.Products 
	WHERE categoryid = 1
) 

SELECT productid, productname
FROM ProductBeverages
WHERE pricetype = N'high';
GO 

WITH c2008 AS (
	SELECT custid, SUM(val) AS salesamt2008
	FROM Sales.OrderValues
	WHERE YEAR(orderdate) = 2008
	GROUP BY custid
),
c2007 AS (
	SELECT custid, SUM(val) AS salesamt2007
	FROM Sales.OrderValues
	WHERE YEAR(orderdate) = 2007
	GROUP BY custid
)
SELECT c.custid, c.contactname,salesamt2008, salesamt2007, (salesamt2008/salesamt2007) * 100 AS percentgrowth
	FROM Sales.Customers AS c
	JOIN c2008
	ON c.custid = c2008.custid
	LEFT JOIN c2007
	ON c.custid = c2007.custid
	ORDER BY percentgrowth DESC
GO