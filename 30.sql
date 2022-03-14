USE `classicmodels`;
##1

SELECT 
status 
FROM orders;
##2

SELECT 
    firstName, 
    lastName, 
    email
FROM
    employees;
##3

SELECT 
    productCode, 
    productName, 
    buyPrice
FROM
    products;
##4

SELECT 
    orderNumber, 
    shippedDate, 
    productCode
FROM
    orders
INNER JOIN orderdetails USING (orderNumber);

##5
SELECT 
    customers.customerNumber, 
    customerName, 
    country,
	shippedDate
FROM
    customers
LEFT JOIN orders ON 
    orders.customerNumber = customers.customerNumber;

##6
SELECT 
    jobTitle, COUNT(*)
    
FROM
    employees
GROUP BY jobTitle;

##7
SELECT 
	officecode,
    firstName, 
    lastName, 
    jobTitle
FROM
    employees;
##8
SELECT 
    firstName, COUNT(*)
    
FROM
    employees
GROUP BY firstName;
##9

SELECT 
    productLine, 
    COUNT(*)
FROM
    products
GROUP BY productLine
HAVING COUNT(*) <20
ORDER BY COUNT(*) ASC;

##10

SELECT 
count(*) 
FROM products
WHERE buyPrice < 50;
##11

SELECT 
    products.productCode, 
    productName, 
    productDescription, 
    orderNumber
FROM
    products
LEFT JOIN orderdetails ON 
    products.productCode = orderdetails.productCode;
##12

SELECT COUNT(*) FROM
    products p
LEFT JOIN orderdetails o ON 
    p.productCode = o.productCode;
##13

SELECT COUNT(*) FROM
    products p
LEFT JOIN orderdetails o ON 
    p.productCode = o.productCode
WHERE p.buyPrice>80;
##14

SELECT 
    orderNumber,
    orderDate,
	customerNumber,
	customerName,
	productCode

FROM
    orderdetails 
INNER JOIN
    orders USING (orderNumber)
INNER JOIN
    customers USING (customerNumber)
ORDER BY 
    orderNumber;
##15

SELECT
	products.productCode,
    orderNumber,
	productName,
    quantityInStock
FROM 
	products
LEFT JOIN orderdetails ON
	orderdetails.productCode = products.productCode;
##16

SELECT 
payments.customerNumber,
customerName,
creditLimit,
paymentDate
FROM 
	payments 
RIGHT JOIN customers  ON
	payments.customerNumber = customers.customerNumber
ORDER BY
paymentDate;

##17

SELECT 
	customers.customerNumber,
	requiredDate
	shippedDate,
	city,
	state,
	postalCode,
	country,
	status
FROM 
	orders
RIGHT JOIN customers  ON
	orders.customerNumber = customers.customerNumber
ORDER BY
shippedDate,
country;
##18

SELECT 
    productCode,
	productName,
	productLine,
	SUM(buyPrice*quantityInStock) AS precoTotal
FROM products
GROUP BY 
   productName
HAVING 
   precoTotal > 200000;
##19

SELECT 
    employeeNumber,
	firstName,
	LastName,
	jobTitle,
	officeCode,
    reportsTo
FROM employees
GROUP BY 
   employeeNumber
HAVING 
   reportsTo> 1100;
##20

SELECT 
    orderNumber, 
    orderLineNumber, 
    priceEach
FROM
    orderdetails
WHERE
    priceEach = (SELECT MAX(priceEach) FROM orderdetails)
HAVING
	orderLineNumber < 5;
##21

SELECT 
    customerNumber,
	country,
	salesRepEmployeeNumber
FROM
    customers
GROUP BY customerNumber
HAVING 
    country = 'France' AND 
   salesRepEmployeeNumber > 1350;
##22

SELECT DISTINCT
    country,
	state
FROM
    offices
WHERE
    country IS NOT NULL
HAVING
    state IS NULL
ORDER BY 
    country,
	state;
##23

SELECT 
    customerNumber, 
  	customerName, 
	creditLimit
FROM
    customers
WHERE
    customerName LIKE 'b%'
ORDER BY 
	customerNumber ;
##24

SELECT 
	shippedDate,
	status,
    orderNumber 
FROM
    orders
WHERE
    shippedDate LIKE '%$11%' ESCAPE '$'
ORDER BY 
	shippedDate;
##25

SELECT 
	productName,
    productCode
	
FROM products
WHERE EXISTS( SELECT
	orderNumber, SUM(buyPrice*quantityInStock) AS precoTotal
FROM 
	orderdetails
GROUP BY 
   productName
HAVING 
   precoTotal > 200000000);
##26

SELECT 
    customerName,
	phone,
salesRepEmployeeNumber
FROM
    customers
WHERE
    customerNumber IN (SELECT 
            customerNumber
        FROM
            orders
        WHERE
            status = 'Cancelled' AND customerNumber>300);
##27

SELECT 
    customerNumber,
	checkNumber,
	amount
FROM
    payments
WHERE
    customerNumber IN (SELECT 
            customerNumber
        FROM
           customers 
        WHERE
            creditLimit>100000 AND country='France');
##28

SELECT DISTINCT
    productLine,
	productName
FROM
    products
WHERE
    productCode IN (SELECT 
            productCode
        FROM
           orderdetails 
        WHERE
            quantityOrdered>10 AND priceEach<'50');
##29

SELECT DISTINCT
    productLine,
    productName,
    buyPrice
FROM
    products
WHERE 
	buyPrice<70
ORDER BY 
	productLine,
	buyPrice;

##30

SELECT 
    c.customerNumber, 
    c.customerName,
    c.phone,
    c.country,
    o.shippedDate,
    o.status
FROM
    customers c
LEFT JOIN orders o 
    ON c.customerNumber = o.customerNumber
WHERE
    c.customerName LIKE 'r%' AND o.status= 'Shipped' AND c.country='France'
ORDER BY
	c.customerNumber, 
    c.customerName,
    o.shippedDate;