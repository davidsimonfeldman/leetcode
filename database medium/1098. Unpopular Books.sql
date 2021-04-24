/*
1098. Unpopular Books
Medium
SQL Schema
Table: Books

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| book_id        | int     |
| name           | varchar |
| available_from | date    |
+----------------+---------+
book_id is the primary key of this table.
Table: Orders

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| order_id       | int     |
| book_id        | int     |
| quantity       | int     |
| dispatch_date  | date    |
+----------------+---------+
order_id is the primary key of this table.
book_id is a foreign key to the Books table.
 

Write an SQL query that reports the books that have sold less than 10 copies in the last year, excluding books that have been available for less than 1 month from today. Assume today is 2019-06-23.

The query result format is in the following example:

Books table:
+---------+--------------------+----------------+
| book_id | name               | available_from |
+---------+--------------------+----------------+
| 1       | "Kalila And Demna" | 2010-01-01     |
| 2       | "28 Letters"       | 2012-05-12     |
| 3       | "The Hobbit"       | 2019-06-10     |
| 4       | "13 Reasons Why"   | 2019-06-01     |
| 5       | "The Hunger Games" | 2008-09-21     |
+---------+--------------------+----------------+

Orders table:
+----------+---------+----------+---------------+
| order_id | book_id | quantity | dispatch_date |
+----------+---------+----------+---------------+
| 1        | 1       | 2        | 2018-07-26    |
| 2        | 1       | 1        | 2018-11-05    |
| 3        | 3       | 8        | 2019-06-11    |
| 4        | 4       | 6        | 2019-06-05    |
| 5        | 4       | 5        | 2019-06-20    |
| 6        | 5       | 9        | 2009-02-02    |
| 7        | 5       | 8        | 2010-04-13    |
+----------+---------+----------+---------------+

Result table:
+-----------+--------------------+
| book_id   | name               |
+-----------+--------------------+
| 1         | "Kalila And Demna" |
| 2         | "28 Letters"       |
| 5         | "The Hunger Games" |







SELECT book_id, 
       name
FROM Books
WHERE available_from < '2019-05-23'
AND book_id NOT IN
            (SELECT book_id
             FROM Orders
             WHERE dispatch_date BETWEEN '2018-06-23' AND '2019-06-23'
             GROUP BY book_id
             Having sum(quantity) >= 10) 
#some books available_from early than '2019-05-23', but no sales during '2018-06-23' and '2019-06-23', so the Group BY cannot reflect those book with no sales, however, they are book that have less than 10 copies sold. So, we have to use NOT IN (those books sold more than 10 copies), instead of IN (those books sold less than 10 copies (0 copy books not included))


solution has similiar logic with the second one. The major difference is that this one joined the tables first and then run the filter later to give us the information that we need.

select b.book_id, b.name
from books b left join orders o
on b.book_id = o.book_id and dispatch_date between '2018-06-23' and '2019-06-23'
where datediff('2019-06-23', available_from) > 30
group by b.book_id, b.name
having ifnull(sum(quantity),0) <10;




select b.book_id, b.name from
(select * from books where available_from < '2019-05-23') b
left join
(select * from Orders where dispatch_date > '2018-06-23') o
on b.book_id = o.book_id
group by b.book_id, b.name
having sum(o.quantity) is null or sum(o.quantity) <10;


 


SELECT DISTINCT B.book_id, B.name 
FROM Books B
LEFT JOIN Orders O 
ON O.book_id=B.book_id
WHERE B.available_from<'2019-05-23' 
GROUP BY book_id
HAVING SUM(CASE WHEN dispatch_date>= '2018-06-23' THEN quantity ELSE 0 END)<10;


SELECT DISTINCT B.book_id, B.name 
FROM Books B
LEFT JOIN Orders O 
ON O.book_id=B.book_id
WHERE B.available_from<'2019-05-23' 
GROUP BY book_id
HAVING SUM(CASE WHEN dispatch_date>=DATE_SUB('2019-06-23',interval 1 year) THEN quantity ELSE 0 END)<10;


select  b.book_id,b.name
from 
(select * from books where available_from <= "2019-05-23") b 
left join (select * from orders where dispatch_date >= "2018-06-23") o
on b.book_id=o.book_id 
group by b.book_id,b.name
having sum(o.quantity) is null or sum(quantity)<10

