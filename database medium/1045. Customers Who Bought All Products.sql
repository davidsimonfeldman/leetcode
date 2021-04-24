/*
1045. Customers Who Bought All Products
Medium
SQL Schema
Table: Customer

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| customer_id | int     |
| product_key | int     |
+-------------+---------+
product_key is a foreign key to Product table.
 

Table: Product

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| product_key | int     |
+-------------+---------+
product_key is the primary key column for this table.
 

Write an SQL query for a report that provides the customer ids from the Customer table that bought all the products in the Product table.

Return the result table in any order.

The query result format is in the following example:

 

Customer table:
+-------------+-------------+
| customer_id | product_key |
+-------------+-------------+
| 1           | 5           |
| 2           | 6           |
| 3           | 5           |
| 3           | 6           |
| 1           | 6           |
+-------------+-------------+

Product table:
+-------------+
| product_key |
+-------------+
| 5           |
| 6           |
+-------------+

Result table:
+-------------+
| customer_id |
+-------------+
| 1           |
| 3           |
+-------------+
The customers who bought all the products (5 and 6) are customers with id 1 and 3.


















select   distinct customer_id    
from Customer c
 group by  customer_id
  having count(distinct c.product_key)=(select count(distinct p.product_key) from Product p)
order by 1





select customer_id
from
(
select c.customer_id,p.product_key
from
customer c inner join product p
on c.product_key = p.product_key

) c_p
group by customer_id
having count(distinct product_key) =
(select count(distinct product_key) from product)