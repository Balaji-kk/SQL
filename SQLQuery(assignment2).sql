use AdventureWorks2008R2;

/* Modify the following query to add a column that identifies the
frequency of repeat customers and contains the following values
based on the number of orders during 2007:
'No Orders' for count = 0
'One Time' for count = 1
'Regular' for count range of 2-5
'Often' for count range of 6-12
'Very Often' for count greater than 12
Give the new column an alias to make the report more readable. */

SELECT c.CustomerID, c.TerritoryID,
COUNT(o.SalesOrderid) [Total Orders],
CASE 
WHEN COUNT(o.SalesOrderid) = 0
THEN ' No Orders'
WHEN COUNT(o.SalesOrderid) = 1
THEN ' One time'
WHEN COUNT(o.SalesOrderid) >= 2 AND COUNT(o.SalesOrderid) <= 5
THEN 'Regular'
WHEN COUNT(o.SalesOrderid) >= 6 AND COUNT(o.SalesOrderid) <= 12
THEN 'Often'
ELSE 'Very Often' 
END AS [Order Frequency]
FROM Sales.Customer c
LEFT OUTER JOIN Sales.SalesOrderHeader o
ON c.CustomerID = o.CustomerID 
WHERE DATEPART(year, OrderDate) = 2007
GROUP BY c.TerritoryID, c.CustomerID;

/* Modify the following query to add a rank without gaps in the
ranking based on total orders in the descending order. Also
partition by territory.*/

SELECT c.CustomerID, c.TerritoryID,
Dense_RANK() OVER (PARTITION BY c.TerritoryID ORDER BY COUNT(o.SalesOrderid) DESC) [Total Orders]
FROM Sales.Customer c
LEFT OUTER JOIN Sales.SalesOrderHeader o
 ON c.CustomerID = o.CustomerID
WHERE DATEPART(year, OrderDate) = 2007
GROUP BY c.TerritoryID, c.CustomerID;

/* Write a query that returns the highest bonus amount
ever received by male sales people in Canada. */

SELECT * FROM (SELECT a.BusinessEntityID,a.FirstName,a.LastName,b.Bonus,DENSE_RANK() OVER (ORDER BY b.Bonus DESC) rnk 
FROM Person.Person as a 
INNER JOIN Sales.SalesPerson as b 
ON a.BusinessEntityID = b.BusinessEntityID
INNER JOIN Sales.SalesTerritory as c 
ON b.TerritoryID = c.TerritoryID
WHERE c.CountryRegionCode = 'CA' 
GROUP BY a.BusinessEntityID,a.FirstName,a.LastName,b.Bonus)  rnk wHERE rnk = 1

/* Write a query to list the most popular product color for each month of 2007, 
considering all products sold in each month. 
The most popular product color had the highest total quantity sold for all products in that color. 
Return the most popular product color and the total quantity of the sold products in that color for each month in the result set.
Sort the returned data by month.Exclude the products that don't have a specified color. */

SELECT* FROM(SELECT  Month(a.OrderDate) Mnth,RANK() OVER (PARTITION BY Month(a.OrderDate) ORDER BY SUM(od.OrderQty) DESC) Rank,p.color,SUM(od.OrderQty) AS OrderQty
FROM Sales.SalesOrderHeader a 
INNER JOIN Sales.SalesOrderDetail od
ON a.SalesOrderID = od.SalesOrderID
INNER JOIN Production.Product as p
ON od.ProductID = p.ProductID
WHERE  DATEPART(year, OrderDate) = 2007 AND p.Color IS NOT NULL
GROUP BY MONTH(a.OrderDate), p.color) Rank WHERE Rank = 1
ORDER BY Mnth 

/* Write a query to retrieve the distinct customer id's and
account numbers for the customers who have placed an order
before but have never purchased the product 708. Sort the
results by the customer id in the ascending order. */

SELECT CustomerID,AccountNumber FROM Sales.Customer
WHERE CustomerID IN (Select CustomerID From Sales.SalesOrderHeader)EXCEPT (SELECT c.CustomerID, c.AccountNumber FROM Sales.Customer c
INNER JOIN Sales.SalesOrderHeader o
ON c.CustomerID = o.CustomerID
AND o.SalesOrderID  IN (SELECT DISTINCT(SalesOrderID) FROM Sales.SalesOrderDetail WHERE PRODUCTID = '708'))