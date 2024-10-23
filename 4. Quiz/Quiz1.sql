USE tokosepeda;
GO

INSERT INTO 
	sales.customers
	(first_name, last_name, 
	phone, email, street, city, state, zip_code) 
	VALUES
	('Moch. Haikal', 'Putra Muhajir',
	'0881036043991', 'haikal.muhajir10@gmail.com',
	'Jalan Gatutkaca', 'Kabupaten Malang', 'Jawa Timur', '65158'); 
GO

SELECT TOP 10 *
FROM
	sales.customers
WHERE 
	first_name LIKE 'M%'
ORDER BY 
	customer_id DESC;
GO

SELECT 
	p.product_id AS id_produk,
	p.product_name AS nama_produk,
	p.list_price AS harga,
	k.category_name AS kategori
FROM
	production.products AS p 
JOIN 
	production.categories AS k
ON 
	p.category_id = k.category_id
WHERE
	p.list_price >= 1000
ORDER BY
	p.product_id ASC;
GO

SELECT 
	p.product_id AS id_produk,
	p.product_name AS nama_produk,
	p.list_price AS harga,
	k.category_name AS kategori
FROM
	production.products AS p 
JOIN 
	production.categories AS k
ON 
	p.category_id = k.category_id
WHERE
	p.list_price >= 1000
ORDER BY
	p.product_id ASC
OFFSET 
	7 ROWS
FETCH NEXT 
	9 ROWS ONLY;
GO
