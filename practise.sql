use AdventureWorks2008R2;

/*List the product ID, name, list price, size of products
Under the ‘Bikes’ category (ProductCategoryID = 1) and
Subcategory ‘Mountain Bikes’. */

select ProductID,pp.Name,ListPrice,Size
from Production.Product as pp
inner join Production.ProductSubcategory as p
on pp.ProductSubcategoryID=p.ProductSubcategoryID
where p.ProductCategoryID='1' and pp.Name='bikes'

/* List the SalesOrderID and currency name for each order. */
select ss.SalesOrderID,s.ToCurrencyCode 
from sales.SalesOrderHeader as ss
inner join sales.CurrencyRate as s
on ss.CurrencyRateID=s.CurrencyRateID
inner join sales.Currency 
on s.ToCurrencyCode=Sales.Currency.CurrencyCode

--SELECT the order count for each customer
--WHERE the count > 20
--ORDER the counts in the descending order
select ss.CustomerID,c.PersonID,count(SalesOrderID) as ordercount
from Sales.SalesOrderHeader as ss
inner join sales.Customer as c
on ss.CustomerID=c.CustomerID
group by ss.CustomerID, c.PersonID
having count(SalesOrderID)>20

select pp.Name, ProductNumber
from Production.Product as pp
where pp.Name in ('blade','AWC Logo Cap')

select pp.name, pp.ProductNumber
from Production.Product as pp
where pp.name like '[ace]%'

/* retrive customer who never purcahsed 716*/

select distinct customerID
from sales.SalesOrderHeader 
where CustomerID not in (select distinct customerID
from sales.SalesOrderHeader as s  inner join sales.SalesOrderDetail as ss
on s.SalesOrderID=ss.SalesOrderID where ProductID =716)
order by CustomerID

/* calculate total sales for each territoriy*/
select sum(TotalDue) as total, s.TerritoryID,ss.Name
from Sales.SalesOrderHeader as s 
inner join Sales.SalesTerritory as ss  
on s.TerritoryID=ss.TerritoryID
group by s.TerritoryID,ss.Name

/* Select product id, name and selling start date for all products
that started selling after 01/01/2007 and had a black color.
Use the CAST function to display the date only. Sort the returned
data by the selling start date*/

select ProductID,Name,SellStartDate 
from Production.Product
where cast(SellStartDate as date) > '01/01/2007' and color='Black'
order by SellStartDate

/* Retrieve the customer ID, account number, oldest order date
and total number of orders for each customer.
Use column aliases to make the report more presentable.
Sort the returned data by the total number of orders in
the descending order.*/

select c.CustomerID,c.AccountNumber,count(c.SalesOrderNumber) as [total order],min(cast(c.OrderDate as date)) as [date]
from sales.SalesOrderHeader as c
inner join Sales.SalesOrderHeader as ss
on c.CustomerID=ss.CustomerID
group by c.CustomerID,c.AccountNumber,c.OrderDate
order by [total order] desc

/* Write a query to select the product id, name, and list price
for the product(s) that have the highest list price.*/

select pp.ProductID,pp.Name,ListPrice
from Production.Product as pp
where pp.ListPrice=( select max(listprice) from Production.Product)

/* Write a query to retrieve the total quantity sold for each product. 
Include only products that have a total quantity sold greater than 3000.
Sort the results by the total quantity sold in the descending order. 
Include the product ID, product name, and total quantity sold columns in the report.*/

select pp.ProductID,pp.Name,sum(ss.OrderQty)
from Production.Product as pp
inner join sales.SalesOrderDetail as ss
on pp.ProductID=ss.ProductID
group by pp.ProductID,pp.Name
having sum(OrderQty) > 3000 

/* Write a SQL query to generate a list of customer ID's and
account numbers that have never placed an order before.
Sort the list by CustomerID in the ascending order. */

select distinct(CustomerID),AccountNumber,count(ss.SalesOrderID)
from sales.SalesOrderHeader as s
inner join sales.SalesOrderDetail as ss
on s.SalesOrderID=ss.SalesOrderID
group by CustomerID,AccountNumber
having count(s.SalesOrderID)=1

/* Write a query to create a report containing customer id, first name, last name and email address for all customers.
Sort the returned data by CustomerID. */ 

select s.CustomerID,pp.FirstName,pp.LastName,pe.EmailAddress
from sales.Customer as s
inner join Person.Person as pp
on s.PersonID=pp.BusinessEntityID
inner join Person.EmailAddress as pe
on pp.BusinessEntityID=pe.BusinessEntityID
 
