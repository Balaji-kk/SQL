use Kothandaraman_Balaji_TEST;

drop function totalSale;
drop trigger tr_status_change;
DROP TABLE SaleOrderDetail;
DROP TABLE SaleOrder;
DROP TABLE Customer;
drop proc DateRangeTable1;
drop table daterange;

/* Create a function in your own database that takes two parameters: 1) A year parameter 
2) A month parameter The function then calculates and returns the total sale for the requested year and month. 
If there was no sale for the requested period, returns 0. Hints: 
a) Use the TotalDue column of the Sales.SalesOrderHeader table in an AdventureWorks database for calculating the total sale.
b) The year and month parameters should use the INT data type. 
c) Make sure the function returns 0 if there was no sale in the database for the requested period. */

GO
Create function totalsale
(  
    @month int,
    @year int
)
returns int
as 
     begin
     declare @sale money
     select @sale =(
                select sum(totaldue) 
                from AdventureWorks2008R2.Sales.SalesOrderHeader
                where DATEPART(YEAR,ShipDate)=@year 
				and DATEPART(month,ShipDate)=@month
				)
				if @sale is null
				return(0)
      return @sale;
	  end;

GO
SELECT dbo.totalsale(05,2007) AS totalmonthlysale


/*Lab 5-2 Create a table in your own database using the following statement.
CREATE TABLE DateRange
(DateID INT IDENTITY,
DateValue DATE,
Month INT,
DayOfWeek INT);
Write a stored procedure that accepts two parameters:
1) A starting date
2) The number of the consecutive dates beginning with the starting date
The stored procedure then populates all columns of the
DateRange table according to the two provided parameters.*/


CREATE TABLE DateRange
(DateID INT IDENTITY,
DateValue DATE,
Month INT,
DayOfWeek INT)

use Kothandaraman_Balaji_TEST;

GO
CREATE PROCEDURE DateRangeTable1
	@Startdate DATE,
	@NoofDates INT
AS
BEGIN
	DECLARE @Counter INT = 0;
	WHILE(@Counter < @NoofDates)
	BEGIN
	INSERT INTO dbo.DateRange VALUES (@Startdate, Month(DATEADD(day, @Counter, @Startdate)), DATEPART(Weekday,DATEADD(day, @Counter, @Startdate))); 
		SET @Counter = @Counter + 1;
	END;
	RETURN;
END;
exec DateRangeTable1 '2005-12-12',5
select * from DateRange




/* Lab 5-3  With three tables as defined below: 
Write a trigger to update the CustomerStatus column of Customer
based on the total of OrderAmountBeforeTax for all orders
placed by the customer. If the total exceeds 5,000, put Preferred
in the CustomerStatus column.*/
use Kothandaraman_Balaji_TEST;

CREATE TABLE Customer
(CustomerID VARCHAR(20) PRIMARY KEY,
CustomerLName VARCHAR(30),
CustomerFName VARCHAR(30),
CustomerStatus VARCHAR(10));

CREATE TABLE SaleOrder
(OrderID INT IDENTITY PRIMARY KEY,
CustomerID VARCHAR(20) REFERENCES Customer(CustomerID),
OrderDate DATE,
OrderAmountBeforeTax INT);

CREATE TABLE SaleOrderDetail
(OrderID INT REFERENCES SaleOrder(OrderID),
ProductID INT,
Quantity INT,
UnitPrice INT,
PRIMARY KEY (OrderID, ProductID))

go
create trigger tr_status_change
on SaleOrder
after insert,update
as
begin 
    declare @salebfrtax int;
	select @salebfrtax = (select sum(OrderAmountBeforeTax) from SaleOrder where CustomerID=(select CustomerID from inserted) group by CustomerID) 

if @salebfrtax>5000
begin
update Customer set CustomerStatus='preferred'
where CustomerID=(select CustomerID from inserted)
end
end;



/*Lab 5-4  Use the content of an AdventureWorks database. Write a query that returns the following columns.
1) Customer ID 2) Customer’s first name 3) Customer’s last name 4) Total of orders made by each customer 
5) Total of unique products ever purchased by each customer Sort the returned data by the customer ID. */
go
use AdventureWorks2008R2;

select ss.CustomerID,pp.FirstName,pp.LastName,count(distinct(ss.SalesOrderID))as [Total of orders],count(distinct(p.ProductID)) as [total of unique products]
from AdventureWorks2008R2.sales.SalesOrderHeader as ss
inner join AdventureWorks2008R2.Sales.Customer as sc
on ss.CustomerID=sc.CustomerID
inner join AdventureWorks2008R2.Person.Person as pp
on sc.PersonID=pp.BusinessEntityID
inner join AdventureWorks2008R2.Sales.SalesOrderDetail as s
on ss.SalesOrderID=s.SalesOrderID
inner join AdventureWorks2008R2.Production.Product as p
on p.ProductID=s.ProductID
group by ss.CustomerID,pp.FirstName,pp.LastName
order by CustomerID


