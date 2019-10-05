--selecting database

Use AdventureWorks2008R2;

--Retrieve columns

select ProductID,name,SellStartDate,SellEndDate,Size,Weight
from Production.Product

-- Select all info for all orders with no credit card id

select * 
from Sales.SalesOrderHeader
where CreditCardID is null;

--Select all info for all products with size specified
select *
from Production.Product
where Size is not null;

--Select all information for products that started selling between January 1, 2007 and December 31, 2007
select *
from Production.Product
where SellStartDate between '1-January-2007' and '31-December-2007'


/*Select all info for all orders placed in June 2007 using date
functions, and include a column for an estimated delivery date
that is 7 days after the order date*/

select *, DATEADD(day,7,OrderDate) as [estimate delivery]
from sales.SalesOrderHeader
where DATEPART(month, OrderDate)=6 and DATEPART(year, OrderDate)=2007





/*Determine the date that is 30 days from today and display only
the date in mm/dd/yyyy format (4-digit year).*/

select FORMAT(GETDATE(),'MM/dd/yyyy') as date
select format(DATEADD(DAY,30,CURRENT_TIMESTAMP),'MM/dd/yyyy')


/* Determine the number of orders, overall total due,
average of total due, amount of the smallest amount due, and
amount of the largest amount due for all orders placed in May
2008. Make sure all columns have a descriptive heading. */

select  sum(SalesOrderID) as [number of orders], min(TotalDue) as [smallest amount due], max(TotalDue) as [largest amount due]
from Sales.SalesOrderHeader
where OrderDate between '1-may-2008' and '30-may-2008 '


/* Retrieve the Customer ID, total number of orders and overall total
due for the customers who placed more than one order in 2007
and sort the result by the overall total due in the descending
order. */
select CustomerID, count(SalesOrderID) [number of orders],sum(TotalDue) [number of due]
from sales.SalesOrderHeader
where  DATEPART(year, OrderDate)= 2007
group by CustomerID
Having count(SalesOrderID)>1
order by [number of due] asc;


/*
Provide a unique list of the sales person ids who have sold
the product id 777. Sort the list by the sales person id. */
select Distinct SalesPersonID
from sales.SalesOrderHeader 
inner join Sales.SalesOrderDetail 
on SalesOrderHeader.SalesOrderID=SalesOrderDetail.SalesOrderID
where ProductID=777
order by SalesPersonID desc



/*List the product ID, name, list price, size of products
Under the ‘Bikes’ category (ProductCategoryID = 1) and
Subcategory ‘Mountain Bikes’. */

select ProductID, Production.Product.Name, ListPrice,Size
from Production.Product
join Production.ProductSubcategory
on Production.product.ProductSubcategoryID= Production.ProductSubcategory.ProductSubcategoryID
where Production.ProductSubcategory.ProductCategoryID=1 and Production.Product.Name='MountsinBikes'

/* List the SalesOrderID and currency name for each order. */
select soh.SalesOrderID, crc.Name
from Sales.SalesOrderHeader soh
join Sales.CurrencyRate cr on soh.CurrencyRateID = cr.CurrencyRateID
join Sales.Currency crc on cr.ToCurrencyCode = crc.CurrencyCode;


