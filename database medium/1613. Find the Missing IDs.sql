/*
1613. Find the Missing IDs
Medium
 
SQL Schema
Table: Customers

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| customer_id   | int     |
| customer_name | varchar |
+---------------+---------+
customer_id is the primary key for this table.
Each row of this table contains the name and the id customer.
 

Write an SQL query to find the missing customer IDs. The missing IDs are ones that are not in the Customers table but are in the range between 1 and the maximum customer_id present in the table.

Notice that the maximum customer_id will not exceed 100.

Return the result table ordered by ids in ascending order.

The query result format is in the following example.

 

Customers table:
+-------------+---------------+
| customer_id | customer_name |
+-------------+---------------+
| 1           | Alice         |
| 4           | Bob           |
| 5           | Charlie       |
+-------------+---------------+

Result table:
+-----+
| ids |
+-----+
| 2   |
| 3   |
+-----+
The maximum customer_id present in the table is 5, so in the range [1,5], IDs 2 and 3 are missing from the table.


SELECT 0 AS value UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3;




WITH RECURSIVE seq AS (
    SELECT 0 AS value UNION ALL SELECT value + 1 FROM seq WHERE value < 100
    )

SELECT * FROM seq;



WITH RECURSIVE cte AS 
(SELECT 1 AS VALUE UNION ALL SELECT VALUE +1 FROM cte WHERE VALUE<100)

SELECT VALUE AS ids FROM cte WHERE 
VALUE NOT IN (SELECT CUSTOMER_ID FROM Customers) 
AND VALUE < (SELECT MAX(customer_id) FROM Customers)