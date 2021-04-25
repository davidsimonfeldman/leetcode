/*
1479. Sales by Day of the Week
Hard
SQL Schema
Table: Orders

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| order_id      | int     |
| customer_id   | int     |
| order_date    | date    | 
| item_id       | varchar |
| quantity      | int     |
+---------------+---------+
(ordered_id, item_id) is the primary key for this table.
This table contains information of the orders placed.
order_date is the date when item_id was ordered by the customer with id customer_id.
 

Table: Items

+---------------------+---------+
| Column Name         | Type    |
+---------------------+---------+
| item_id             | varchar |
| item_name           | varchar |
| item_category       | varchar |
+---------------------+---------+
item_id is the primary key for this table.
item_name is the name of the item.
item_category is the category of the item.
 

You are the business owner and would like to obtain a sales report for category items and day of the week.

Write an SQL query to report how many units in each category have been ordered on each day of the week.

Return the result table ordered by category.

The query result format is in the following example:

 

Orders table:
+------------+--------------+-------------+--------------+-------------+
| order_id   | customer_id  | order_date  | item_id      | quantity    |
+------------+--------------+-------------+--------------+-------------+
| 1          | 1            | 2020-06-01  | 1            | 10          |
| 2          | 1            | 2020-06-08  | 2            | 10          |
| 3          | 2            | 2020-06-02  | 1            | 5           |
| 4          | 3            | 2020-06-03  | 3            | 5           |
| 5          | 4            | 2020-06-04  | 4            | 1           |
| 6          | 4            | 2020-06-05  | 5            | 5           |
| 7          | 5            | 2020-06-05  | 1            | 10          |
| 8          | 5            | 2020-06-14  | 4            | 5           |
| 9          | 5            | 2020-06-21  | 3            | 5           |
+------------+--------------+-------------+--------------+-------------+

Items table:
+------------+----------------+---------------+
| item_id    | item_name      | item_category |
+------------+----------------+---------------+
| 1          | LC Alg. Book   | Book          |
| 2          | LC DB. Book    | Book          |
| 3          | LC SmarthPhone | Phone         |
| 4          | LC Phone 2020  | Phone         |
| 5          | LC SmartGlass  | Glasses       |
| 6          | LC T-Shirt XL  | T-Shirt       |
+------------+----------------+---------------+

Result table:
+------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+
| Category   | Monday    | Tuesday   | Wednesday | Thursday  | Friday    | Saturday  | Sunday    |
+------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+
| Book       | 20        | 5         | 0         | 0         | 10        | 0         | 0         |
| Glasses    | 0         | 0         | 0         | 0         | 5         | 0         | 0         |
| Phone      | 0         | 0         | 5         | 1         | 0         | 0         | 10        |
| T-Shirt    | 0         | 0         | 0         | 0         | 0         | 0         | 0         |
+------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+
On Monday (2020-06-01, 2020-06-08) were sold a total of 20 units (10 + 10) in the category Book (ids: 1, 2).
On Tuesday (2020-06-02) were sold a total of 5 units  in the category Book (ids: 1, 2).
On Wednesday (2020-06-03) were sold a total of 5 units in the category Phone (ids: 3, 4).
On Thursday (2020-06-04) were sold a total of 1 unit in the category Phone (ids: 3, 4).
On Friday (2020-06-05) were sold 10 units in the category Book (ids: 1, 2) and 5 units in Glasses (ids: 5).
On Saturday there are no items sold.
On Sunday (2020-06-14, 2020-06-21) were sold a total of 10 units (5 +5) in the category Phone (ids: 3, 4).
There are no sales of T-Shirt.



# Write your MySQL query statement below
with cte as 
(select item_category, 
DAYOFWEEK(order_date) as 'day_of_week', 
IFNULL(sum(quantity), 0) as 'category_quantity'
from 
Orders right outer join Items on (Orders.item_id = Items.item_id)
group by day_of_week, item_category)

select item_category as 'CATEGORY', 
sum(CASE WHEN day_of_week = '2' THEN category_quantity ELSE 0 END) as 'MONDAY', 
sum(CASE WHEN day_of_week = '3' THEN category_quantity ELSE 0 END) as 'TUESDAY', 
sum(CASE WHEN day_of_week = '4' THEN category_quantity ELSE 0 END) as 'WEDNESDAY', 
sum(CASE WHEN day_of_week = '5' THEN category_quantity ELSE 0 END) as 'THURSDAY', 
sum(CASE WHEN day_of_week = '6' THEN category_quantity ELSE 0 END) as 'FRIDAY', 
sum(CASE WHEN day_of_week = '7' THEN category_quantity ELSE 0 END) as 'SATURDAY', 
sum(CASE WHEN day_of_week = '1' THEN category_quantity ELSE 0 END) as 'SUNDAY'
from cte 
group by CATEGORY
order by CATEGORY





/* Write your T-SQL query statement below */
SELECT CATEGORY ,
COALESCE(MONDAY,0)MONDAY ,
COALESCE(TUESDAY,0)TUESDAY ,
COALESCE(WEDNESDAY,0) WEDNESDAY ,
COALESCE(THURSDAY,0) THURSDAY ,
COALESCE(FRIDAY,0) FRIDAY ,
COALESCE(SATURDAY,0) SATURDAY, 
COALESCE(SUNDAY,0) SUNDAY
FROM
(
SELECT ITEM_CATEGORY CATEGORY ,DATENAME(DW,ORDER_DATE) DAY ,QUANTITY FROM
ORDERS O
FULL OUTER JOIN
ITEMS I
ON O.ITEM_ID=I.ITEM_ID
) A
PIVOT
(
SUM(QUANTITY)
FOR DAY IN
([SUNDAY],[MONDAY],[TUESDAY],[WEDNESDAY],[THURSDAY],[FRIDAY],[SATURDAY])
) AS B
ORDER BY 1







 select 
 item_category as category,
 sum(case when day = 'Monday' then cnt else 0 end) as 'Monday',
 sum(case when day ='Tuesday' then cnt else 0 end) as 'Tuesday',
 sum(case when day ='Wednesday' then cnt else 0 end) as 'Wednesday',
 sum(case when day ='Thursday' then cnt else 0 end) as 'Thursday',
 sum(case when day ='Friday' then cnt else 0 end) as 'Friday',
 sum(case when day ='Saturday' then cnt else 0 end) as 'Saturday',
 sum(case when day ='Sunday' then cnt else 0 end) as 'Sunday' 
 from
 (
    select 
        i.item_category,
        sub.item_id,
        day,
        order_date,
        sum(quantity)over(partition by sub.item_id,order_date) as cnt 
from
(
        SELECT 
            order_id, 
            customer_id,
            order_date, 
            DAYNAME(order_date) AS day,
            item_id, 
            quantity from orders)sub
        right join items i on 
            sub.item_id = i.item_id
        order by sub.item_id)sub1
        group by sub1.item_category
        order by sub1.item_category
        
        
        
        
        
        
        
        select b.item_category as 'CATEGORY', sum(case when weekday(a.order_date) = 0 then a.quantity else 0 end) as 'MONDAY',
sum(case when weekday(a.order_date) = 1 then a.quantity else 0 end) as 'TUESDAY',
sum(case when weekday(a.order_date) = 2 then a.quantity else 0 end) as 'WEDNESDAY',
sum(case when weekday(a.order_date) = 3 then a.quantity else 0 end) as 'THURSDAY',
sum(case when weekday(a.order_date) = 4 then a.quantity else 0 end) as 'FRIDAY',
sum(case when weekday(a.order_date) = 5 then a.quantity else 0 end) as 'SATURDAY',
sum(case when weekday(a.order_date) = 6 then a.quantity else 0 end) as 'SUNDAY'
from orders a right join items b on a.item_id = b.item_id
group by b.item_category
order by b.item_category






  WITH cte AS 
  (
  	SELECT i.item_category, WEEKDAY(o.order_date) AS "day", SUM(o.quantity) AS "total"
  	FROM Orders o LEFT JOIN Items i ON i.item_id = o.item_id
  	GROUP BY 1, 2 ORDER BY 1, 2
  ),
  final AS 
  (
  	SELECT i.item_category AS "Category",
  	IFNULL(MAX(CASE WHEN c.day = 0 THEN c.total END), 0) AS "Monday",
  	IFNULL(MAX(CASE WHEN c.day = 1 THEN c.total END), 0) AS "Tuesday",
  	IFNULL(MAX(CASE WHEN c.day = 2 THEN c.total END), 0) AS "Wednesday",
  	IFNULL(MAX(CASE WHEN c.day = 3 THEN c.total END), 0) AS "Thursday",
  	IFNULL(MAX(CASE WHEN c.day = 4 THEN c.total END), 0) AS "Friday",
  	IFNULL(MAX(CASE WHEN c.day = 5 THEN c.total END), 0) AS "Saturday",
  	IFNULL(MAX(CASE WHEN c.day = 6 THEN c.total END), 0) AS "Sunday"
  	FROM Items i LEFT JOIN cte c ON i.item_category = c.item_category
  	GROUP BY 1 ORDER BY 1
  )

  SELECT * FROM final