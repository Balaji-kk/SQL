/*Part A Step 1) Create a new database of the format: LASTNAME_FIRSTNAME_TEST*/


use Kothandaraman_Balaji_TEST;



/*Step 2) Within this database, experiment creating, altering, and dropping tables and columns. Put in sample data and play around with other kinds of queries. Write at least 20 SQL statements for this step*/

drop table dbo.customer_detail
drop table dbo.placed_order

insert dbo.units
values(1,'pounds'),(2,'kilograms'),(3,'gallons'),(4,'litres')

insert dbo.items
values ('Onions', 2.1,'organic',1),('Tomatoes',3.2,'organic',1),('Egg plant',1.1,'inorganic',1),('lemon',3.2,'organic',1),('apples',0.88,'inorgannic',1),('oranges',3.6,'organic',1)

insert dbo.order_items
values(1,3,12),(2,2,6.4),(3,3,3.3),(4,2,6.4),(5,2,1.64),(6,2,6.12)

alter table dbo.order_items drop column quantity

select * from dbo.units

select unit_id,unit_name
from dbo.units
where unit_id  between 1 and 3

select unit_id,unit_name
from dbo.units
where unit_name='kilograms'


create table dbo.customer_detail ( customer_id int identity not null);
 
alter table dbo.customer_detail add constraint pk_customer_detail primary key (customer_id) 

alter table dbo.customer_detail add  customer_first varchar(150) not null

alter table  dbo.customer_detail add customer_last varchar(150) not null

alter table  dbo.customer_detail add username varchar(150) not null

alter table  dbo.customer_detail ADD delivery_address varchar(100) not null

alter table  dbo.customer_detail add  confirmation_code varchar(150) not null


insert dbo.customer_detail 
values('balaji','kothandraman','kk','194th avenue bellevue',1071)

insert dbo.customer_detail
values('ashwin','raja sekar','ash','173th street seattle',120)

insert dbo.customer_detail
values('dheeraj','danger','dheera','163th street sammamish',1573)

select username from dbo.customer_detail

select customer_id from dbo.customer_detail

select * from dbo.customer_detail

alter table dbo.customer_detail drop column confirmation_code

select * from dbo.customer_detail

create table dbo.placed_order (placed_id int identity not null primary key)

alter table dbo.placed_order add customer_id int not null 

alter table dbo.placed_order add  delivery_address varchar(255) not null

alter table dbo.placed_order add constraint fk_placed_order foreign key (customer_id) references dbo.customer_detail(customer_id)

insert dbo.placed_order
values(1,'194th avenue bellevue'),(2,'173th street seattle'),(3,'163th street sammamish')

select delivery_address from dbo.placed_order

alter table dbo.placed_order drop column delivery_address

select * from dbo.placed_order


/*Step 3) Eventually, create 3 tables and the corresponding relationships to implement the ERD below in the database.
Note: 2 points for Step 3
Step 4) Keep track of all the code you write and submit it to Blackboard.*/

use Kothandaraman_Balaji_TEST;

drop table dbo.units
drop table dbo.items
drop table dbo.order_items


create table dbo.units(
unit_id int not null primary key,
unit_name varchar(50)
);


create table dbo.items
(
item_id int identity not null primary key,
item_name varchar(255) not null,
price money not null,
item_description text,
unit_id int not null
constraint fk_units foreign key (unit_id) references dbo.units(unit_id)
 );

 
 create table dbo.order_items(
 order_id int identity not null primary key,
 item_id int not null,
 quantity int not null,
 price money not null,
 constraint fk_items foreign key (item_id) references dbo.items(item_id)
 );
 


/* Using the content of AdventureWorks, write a query to retrieve
all unique customers with all salespeople they have dealt with.
If a customer has never worked with a salesperson, make the
'Salesperson ID' column blank instead of displaying NULL.
Sort the returned data by CustomerID in the descending order.
The result should have the following format.*/


USE AdventureWorks2008R2
SELECT SOH.CustomerID,
STUFF ((SELECT distinct ', ' + isnull(convert(varchar(8),OH.SalesPersonID),'') 
FROM sales.SalesOrderHeader OH
WHERE OH.CustomerID = SOH.CustomerID
FOR XML PATH('')), 1, 1, '') as [Salesperson ID]
FROM sales.SalesOrderHeader SOH
GROUP BY SOH.CustomerID 
ORDER BY CustomerID desc

/* Bill of Materials - Recursive */
/* The following code retrieves the 
components required for manufacturing the "Mountain-500 Black, 48" (Product 992). 
Use it as the starter code for calculating the material cost reduction if the component 
815 is manufactured internally at the level 1 instead of purchasing it for use at the level 0. 
Use the list price of a component as the material cost for the component. */

use AdventureWorks2008R2;
WITH Parts(AssemblyID, ComponentID, PerAssemblyQty, EndDate, ComponentLevel) AS
(
 SELECT b.ProductAssemblyID, b.ComponentID, b.PerAssemblyQty,
 b.EndDate, 0 AS ComponentLevel
 FROM Production.BillOfMaterials AS b
 WHERE b.ProductAssemblyID = 992 AND b.EndDate IS NULL
 UNION ALL
 SELECT bom.ProductAssemblyID, bom.ComponentID, p.PerAssemblyQty,
 bom.EndDate, ComponentLevel + 1
 FROM Production.BillOfMaterials AS bom
 INNER JOIN Parts AS p
 ON bom.ProductAssemblyID = p.ComponentID AND bom.EndDate IS NULL
)
SELECT((SELECT ListPrice
FROM Production.Product
WHERE ProductID = 815)-(SUM(pr.ListPrice))) As [Cost_Reduction]
FROM Parts AS p
INNER JOIN Production.Product AS pr
ON p.ComponentID = pr.ProductID
WHERE p.AssemblyID = 815;