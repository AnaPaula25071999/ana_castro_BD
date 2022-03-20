USE `classicmodels`;

##1 -> uma pesquisa simples, buscando o campo status da tabela orders

SELECT 
status 
FROM orders;

##2 -> pesquisando os campos firstName, LastName e email da tabela employees

SELECT 
    firstName, 
    lastName, 
    email
FROM
    employees;
    
##3 -> pesquisando os campos Codigo do produto, do nome do produto e do preço de compra que estão localizado

SELECT 
    productCode, 
    productName, 
    buyPrice
FROM
    products;
    
##4 -> pesquisando os do numero do pedido, a data do envio e codigo do produto

SELECT 
    orderNumber, 
    shippedDate, 
    productCode
FROM
    orders
INNER JOIN orderdetails USING (orderNumber);

##5 -> pesquisa que junta itens de duas tabelas a orders e a customers
SELECT 
    customers.customerNumber, 
    customerName, 
    country,
	shippedDate
FROM
    customers
LEFT JOIN orders ON 
    orders.customerNumber = customers.customerNumber;

##6 -> Pesquisar os cargos e a quantidade de funconarios em cada um deles
SELECT 
    jobTitle, COUNT(*)
    
FROM
    employees
GROUP BY jobTitle;

##7 -> Pesquisa alguns campos na tabela employees
SELECT 
	officecode,
    firstName, 
    lastName, 
    jobTitle
FROM
    employees;
##8 -> Conta quantas pessoas tem o mesmo nome e agrupa elas pelo o primeiro nome
SELECT 
    firstName, COUNT(*)
    
FROM
    employees
GROUP BY firstName;
##9 -> pesquisa o numero de produtos por linha, pegando as linhas com menos de 20 tipos de produtos. No final ordena de forma ascendente

SELECT 
    productLine, 
    COUNT(*)
FROM
    products
GROUP BY productLine
HAVING COUNT(*) <20
ORDER BY COUNT(*) ASC;

##10 -> pesquisa a quantidade de produtos com o preço menor que 50

SELECT 
count(*) 
FROM products
WHERE buyPrice < 50;
##11 -> pesquisa dados de duas tabelas e liga por meio do item productCode que ambas tem igual. 
##Pesquisa focando o dado do produto, os orderNumber dele.

SELECT 
    products.productCode, 
    productName, 
    productDescription, 
    orderNumber
FROM
    products
LEFT JOIN orderdetails ON 
    products.productCode = orderdetails.productCode;
##12 ->conta a quantidade de produtos existentes

SELECT COUNT(*) FROM
    products p
LEFT JOIN orderdetails o ON 
    p.productCode = o.productCode;
##13-> Pesquisa q mostra a quantidade de produtos existentes com preço de compra maior que 80

SELECT COUNT(*) FROM
    products p
LEFT JOIN orderdetails o ON 
    p.productCode = o.productCode
WHERE p.buyPrice>80;
##14-> Pesquisa que mostra com mais detalhes os produtos que foram pedidos em cada order,
## junto com os dados do cliente e a data q foi feita o pedido

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
##15-> Essa pesquisa mostra a quantidade em estoque do produto com o nome do produto , o codigo do produto e o numero da order do produto
##se espera que se o produto foi pedido a quantidade do stock diminuisse

SELECT
	products.productCode,
    orderNumber,
	productName,
    quantityInStock
FROM 
	products
LEFT JOIN orderdetails ON
	orderdetails.productCode = products.productCode;
##16 -> pesquisa o numero do cliente, seu nome, o limite do credito e a data de pagamento(que o dinheiro vai entrar na empresa)

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

##17-> Consultar o pelo numero do consumidor a data de entrega e a localização para realizar a entrega

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
##18 ->  Consulta o codigo do produdo, seu nome, sua linha e o valor total do produto no estoque(valor de compra) sendo este maior que 200000

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
##19 -> pesquisa os o número e o nome dos empregados que tenha reports maiores que 1100

SELECT 
    employeeNumber,
	firstName,
	LastName,
	jobTitle,
	officeCode,
    reportsTo
FROM employees
WHERE
   reportsTo> 1100;
##20 -> pesquisa um numero de pedido que tenha o maior peço unitário e sua orderLineNumber seja menor que 5

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
##21 -> Pesqusa o numero do cliente, que esta´na frança e tem o numero de representante de vanda maior que 1350

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
##22 ->pesquisa os escritorios que tem o país registrado mas não consta o estado, 
##como não tem como no país ter um escritorio sem estar em um estado esse dado precisa ser acrescentado

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
##23 -> pesquisa os cliente com o nome que começa com o "b" e mostra o seu limite de credito

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
##24 -> pesquisa os pedidos feito com data de entrega no dia 11 e/ou mes 11 e tem seu status do pedido como entregue

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
##25 -> pesquisa o nome e o codigo dos produtos que o preço de compra deles(preço total) no estoque seja maior que 200000000, 
##desta vez agrupando para saber por produto

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
##26 -> pesquisa mostrando nome, telefone e numero do representante de venda de todos os clientes 
##que tiveram o pedido cancelado e tenham seu numero  maior que 300

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
##27 -> pesquisa todos os clientes da França que tem um limite de credito alto(100000), mostrando o numero do check e o valor

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
##28 => essa pesquisa mostra a linha e o nome do produto que tenha valor unitario menor que 50 e tenha vendido mais de 10 unidades

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
##29 -> pesquisa o nome do produto, a linha e o seu preço de compra

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

##30 -> pesquisa alguns dados de um cliente com um nome que inicia com "r", que está na França e que seu pedido já tenha sido enviado

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