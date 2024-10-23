USE TSQL;
GO

SELECT
    o.custid AS [Customer ID],
    c.contactname AS [Name]
FROM Sales.Orders AS o
    JOIN Sales.Customers AS C ON o.custid = c.custid
WHERE o.empid = 5
GROUP BY o.custid, c.contactname;
GO

SELECT
    o.custid AS [Customer ID],
    c.contactname AS Name,
    c.city AS Kota
FROM Sales.Orders AS o
    JOIN Sales.Customers AS C ON o.custid = c.custid
WHERE o.empid = 5
GROUP BY o.custid, c.contactname, c.city;
GO

SELECT
    c.categoryid AS [ID KATEGORI],
    c.categoryname AS [NAMA KATEGORI]
FROM Production.Categories AS c
WHERE c.categoryid IN (
    SELECT p.categoryid
FROM Production.Products AS p
WHERE p.productid IN (
        SELECT od.productid
FROM Sales.OrderDetails AS od
    JOIN Sales.Orders AS o ON od.orderid = o.orderid
    )
)
GROUP BY c.categoryid, c.categoryname;
GO

SELECT
    o.orderid,
    o.orderdate,
    SUM(od.qty * od.unitprice) AS [Total Sales Amount]
FROM Sales.Orders AS o
    JOIN Sales.OrderDetails AS od ON od.orderid = o.orderid
GROUP BY o.orderid, o.orderdate
ORDER BY SUM(od.qty * od.unitprice) DESC;
GO

SELECT
    o.orderid,
    o.orderdate,
    SUM(od.qty * od.unitprice) AS [Total Sales Amount],
    COUNT(o.orderid) AS nooforderlines,
    AVG(od.qty * od.unitprice) AS avgsalesamountperorderlines
FROM Sales.Orders AS o
    JOIN Sales.OrderDetails AS od ON od.orderid = o.orderid
GROUP BY o.orderid, o.orderdate
ORDER BY SUM(od.qty * od.unitprice) DESC;
GO

SELECT
    FORMAT(o.orderdate, 'yyyyMM') AS yearmonthno,
    SUM(od.qty * od.unitprice) AS saleamountpermonth
FROM
    Sales.Orders AS o
    JOIN
    Sales.OrderDetails AS od
    ON o.orderid = od.orderid
GROUP BY
FORMAT(o.orderdate, 'yyyyMM');
GO

SELECT
    c.custid,
    c.contactname,
    SUM(od.qty * od.unitprice) AS totalsalesamount,
    MAX(o.orderid) AS maxsalesamountperorderline,
    COUNT(*) AS numberofrows,
    COUNT(o.orderid) AS numberoforderlines
FROM
    Sales.Customers AS c
    LEFT JOIN Sales.Orders AS o ON c.custid = o.custid
    LEFT JOIN Sales.OrderDetails AS od ON o.orderid = od.orderid
GROUP BY c.custid, c.contactname
ORDER BY SUM(od.qty * od.unitprice) ASC;
GO

SELECT
    YEAR(orderdate) AS orderyear,
    COUNT(orderid) AS nooforders,
    COUNT(custid) AS noofcustomers
FROM Sales.Orders
GROUP BY YEAR(orderdate);
GO

SELECT
    YEAR(orderdate) AS orderyear,
    COUNT(orderid) AS nooforders,
    COUNT(DISTINCT custid) AS noofcustomers
FROM Sales.Orders
GROUP BY YEAR(orderdate);
GO

SELECT
    LEFT(c.contactname, 1) AS [FIRST LETTER],
    COUNT(c.custid),
    COUNT(o.orderid)
FROM Sales.Customers AS c
    JOIN Sales.Orders AS o ON c.custid = o.custid
GROUP BY LEFT(c.contactname, 1)
ORDER BY LEFT(c.contactname, 1);
GO

SELECT
    LEFT(c.contactname, 1) AS [FIRST LETTER],
    COUNT(c.custid),
    COUNT(o.orderid)
FROM Sales.Customers AS c
    JOIN Sales.Orders AS o ON c.custid = o.custid
GROUP BY LEFT(c.contactname, 1)
ORDER BY LEFT(c.contactname, 1);
GO

SELECT
    c.categoryid AS [ID KATEGORI],
    c.categoryname AS [NAMA KATEGORI],
    SUM(DISTINCT od.qty * od.unitprice) AS totalsalesamount,
    COUNT(DISTINCT o.orderid) AS nooforders,
    AVG(DISTINCT od.qty * od.unitprice) AS avgsalesamountperorder
FROM
    Production.Categories AS c
    JOIN Production.Products AS p ON c.categoryid = p.categoryid
    JOIN Sales.OrderDetails AS od ON p.productid = od.productid
    JOIN Sales.Orders AS o ON od.orderid = o.orderid
WHERE YEAR(o.orderdate) = 2008
GROUP BY 
    c.categoryid, c.categoryname
ORDER BY 
    c.categoryid ASC
;
GO

SELECT TOP 5
    o.custid,
    SUM(od.qty * od.unitprice) AS totalsalesamount
FROM Sales.Orders AS o
    JOIN Sales.OrderDetails AS od ON o.orderid = od.orderid
GROUP BY o.custid
HAVING SUM(od.qty * od.unitprice) > 10000
ORDER BY SUM(od.qty * od.unitprice) DESC


SELECT
    o.empid,
    o.orderid,
    SUM(od.qty * od.unitprice) AS totalsalesamount
FROM
    Sales.Orders AS o
    JOIN Sales.OrderDetails AS od ON o.orderid = od.orderid
WHERE 
    YEAR(o.orderdate) = 2008
GROUP BY 
    o.empid, o.orderid
HAVING SUM(od.qty * od.unitprice) > 10000;
GO

SELECT
    o.empid,
    o.orderid,
    SUM(od.qty * od.unitprice) AS totalsalesamount
FROM
    Sales.Orders AS o
    JOIN Sales.OrderDetails AS od ON o.orderid = od.orderid
WHERE 
    YEAR(o.orderdate) = 2008 AND o.empid = 3
GROUP BY 
    o.empid, o.orderid
HAVING SUM(od.qty * od.unitprice) > 10000;
GO

SELECT TOP 3
    o.custid,
    MAX(o.orderdate) AS lastorderdate,
    SUM(od.qty * od.unitprice) AS totalsalesamount
FROM Sales.Orders AS o
    JOIN Sales.OrderDetails AS od ON o.orderid = od.orderid
GROUP BY o.custid
HAVING COUNT(o.custid) > 25
ORDER BY SUM(od.qty * od.unitprice) DESC;

SELECT
    MAX(orderdate) AS lastorderdate
FROM Sales.Orders;


SELECT
    orderid,
    orderdate,
empid,
    custid
FROM Sales.Orders
WHERE orderdate = (
SELECT
    MAX(orderdate) AS lastorderdate
FROM Sales.Orders
);

SELECT
orderid, orderdate, empid, custid FROM Sales.Orders
WHERE
custid IN (
SELECT custid
FROM Sales.Customers
WHERE LEFT(contactname, 1) = 'B'
);

WITH TotalSales AS (
    SELECT 
        SUM(od.qty * od.unitprice) AS grandtotal
    FROM 
        Sales.Orders AS o
    JOIN 
        Sales.OrderDetails AS od ON o.orderid = od.orderid
    WHERE 
        o.orderdate >= '2008-05-01' AND o.orderdate < '2008-06-01'
)

SELECT 
    o.orderid,
    SUM(od.qty * od.unitprice) AS totalsalesamount, 
    SUM(od.qty * od.unitprice) * 100 / ts.grandtotal AS salespctoftotal
FROM 
    Sales.Orders AS o
JOIN 
    Sales.OrderDetails AS od ON o.orderid = od.orderid
CROSS JOIN 
    TotalSales AS ts
WHERE 
    o.orderdate >= '2008-05-01' AND o.orderdate < '2008-06-01'
GROUP BY 
    o.orderid, ts.grandtotal;
GO

SELECT
p.productid,
p.productname
FROM Production.Products AS p
WHERE p.productid IN (
    SELECT od.productid
    FROM Sales.OrderDetails AS od 
    JOIN Sales.Orders AS o ON od.orderid = o.orderid
    WHERE od.qty > 100
);
GO

SELECT 
c.custid,
c.contactname
FROM Sales.Customers AS c
WHERE c.custid NOT IN(
    SELECT o.custid
    FROM Sales.Orders AS o
    WHERE o.custid IS NOT NULL
)
GO

SELECT
c.custid,
c.contactname,
( SELECT MAX(o.orderdate)
FROM Sales.Orders AS o
WHERE o.custid = c.custid)
FROM Sales.Customers AS c
GO

SELECT 
    c.custid,
    c.contactname
FROM 
    Sales.Customers AS c
WHERE 
    NOT EXISTS (
        SELECT 1
        FROM Sales.Orders AS o
        WHERE o.custid = c.custid
    );
GO

SELECT 
c.custid,
c.contactname
FROM
Sales.Customers AS c
WHERE c.custid IN (
    SELECT 
    o.custid
    FROM Sales.Orders AS o
    WHERE o.orderdate >= '2008-04-01' AND o.orderid IN (
        SELECT od.orderid
        FROM Sales.OrderDetails AS od
        GROUP BY od.orderid
        HAVING SUM(od.qty * od.unitprice) > 100
    )
);
GO

SELECT 
    YEAR(o.orderdate) AS orderyear,
    SUM(od.qty * od.unitprice) AS totalsales,
    (
        SELECT 
            SUM(od_inner.qty * od_inner.unitprice)
        FROM 
            Sales.Orders AS o_inner
        JOIN 
            Sales.OrderDetails AS od_inner ON o_inner.orderid = od_inner.orderid
        WHERE 
            YEAR(o_inner.orderdate) <= YEAR(o.orderdate)
    ) AS runsales
FROM 
    Sales.Orders AS o
JOIN 
    Sales.OrderDetails AS od ON o.orderid = od.orderid
GROUP BY 
    YEAR(o.orderdate)
ORDER BY 
    orderyear;
GO


