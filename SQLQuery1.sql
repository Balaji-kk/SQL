-- selecting a database
use AdventureWorks2008R2;
-- selecting a table
select *
from Production.Product;
-- selecting a particular column  from table
select ProductID,Name,ProductNumber,ListPrice
from Production.Product
--Using filter to get particular name
select productID,Name,ProductNumber,ListPrice
from Production.Product
where Name= 'AWC logo Cap'
--using aggergate functions and using alias
select count(CreditCardID) 'total no of creditcards'
from Sales.SalesOrderHeader

select count( Distinct CreditCardID) 'unique credit cards'
from Sales.SalesOrderHeader;

select min(OrderQty) as [minimum quantity value], max(OrderQty) as [Maximum quantity value], AVG(OrderQty) as [Average Quantity], Sum(OrderQty)/count(OrderQty) /*not using alias*/, count(*) as [count]

from Sales.SalesOrderDetail

where orderqty between 30 and 50;

--Using groupby function
select customerID, AccountNumber, count(SalesOrderID) as "#no of orders"
from sales.SalesOrderHeader
Group by CustomerID, AccountNumber
order by CustomerID desc;