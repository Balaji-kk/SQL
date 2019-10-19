USe AdventureWorks2008R2;

/* Select product id, name and selling start date for all products
that started selling after 01/01/2007 and had a black color.
Use the CAST function to display the date only. Sort the returned
data by the selling start date.*/

select pp.ProductID, pp.Name, pp.SellStartDate 
from Production.Product pp
where cast(pp.SellStartDate as DATE)>'01/01/2007' and color='black'
order by pp.SellStartDate asc

/*Retrieve the customer ID, account number, oldest order date
and total number of orders for each customer.
Use column aliases to make the report more presentable.
Sort the returned data by the total number of orders in
the descending order.*/

select ss.CustomerID,ss.AccountNumber,cast(min(ss.OrderDate)as date) as [Oldest order date],count(ss.SalesOrderNumber) as [Total number of orders]
from Sales.SalesOrderHeader ss
inner join sales.SalesOrderHeader c
on c.CustomerID= ss.CustomerID
group by ss.CustomerID,ss.AccountNumber
order by [Total number of orders] desc



/* Write a query to select the product id, name, and list price
for the product(s) that have the highest list price.*/
select pp.ProductID, pp.Name, pp.ListPrice
from Production.Product pp
where pp.ListPrice=(select max(ListPrice) from Production.Product)
order by pp.ProductID 

/* Write a query to retrieve the total quantity sold for each product.
Include only products that have a total quantity sold greater than 3000. 
Sort the results by the total quantity sold in the descending order. 
Include the product ID,product name, and total quantity sold columns in the report*/

select pp.ProductID,pp.Name,sum(c.OrderQty) as [total quantity sold]
from Production.Product pp
inner join sales.SalesOrderDetail c
on pp.ProductID= c.productID
group by pp.ProductID,pp.Name
having sum(c.OrderQty)>3000
order by [total quantity sold] 

/* Write a SQL query to generate a list of customer ID's and
account numbers that have never placed an order before.
Sort the list by CustomerID in the ascending order. */

select sc.CustomerID, sc.AccountNumber
from sales.Customer sc
where  NOT EXISTS (SELECT 1 FROM Sales.SalesOrderHeader S WHERE sc.CustomerID = S.CustomerID)
ORDER BY sc.CustomerID ASC

/* Write a query to create a report containing customer id, first name, last name and email address for all customers.
Sort the returned data by CustomerID. */

select cs.CustomerID,p.firstname,p.LastName,e.EmailAddress
from sales.customer cs
inner join person.Person p
on cs.PersonID=p.BusinessEntityID
inner join Person.EmailAddress e
on cs.PersonID= e.BusinessEntityID
order by cs.CustomerID



