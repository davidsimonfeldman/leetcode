/*
180. Consecutive Numbers
Medium
SQL Schema
Table: Logs

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| num         | varchar |
+-------------+---------+
id is the primary key for this table.
 

Write an SQL query to find all numbers that appear at least three times consecutively.

Return the result table in any order.

The query result format is in the following example:

 

Logs table:
+----+-----+
| Id | Num |
+----+-----+
| 1  | 1   |
| 2  | 1   |
| 3  | 1   |
| 4  | 2   |
| 5  | 1   |
| 6  | 2   |
| 7  | 2   |
+----+-----+

Result table:
+-----------------+
| ConsecutiveNums |
+-----------------+
| 1               |
+-----------------+
1 is the only number that appears consecutively for at least three times.





select distinct num as consecutiveNums
from (select num,sum(c) over (order by id) as flag 
from (select id, num, case when LAG(Num) OVER (order by id)- Num = 0 then 0 else 1 end as c
from logs) a) b
group by num,flag
having count(*) >=3 --(could change 3 to any number)

select distinct num as ConsecutiveNums 
from (select num, id-row_number() over (order by num, id) rank from logs) a
group by num,rank
having count(*) >2




/* Write your T-SQL query statement below */
select distinct num as ConsecutiveNums from (
select num, lead(num, 1) over(order by id) as nxt1, 
            lead(num, 2) over(order by id) as nxt2 from logs
) t
where num = nxt1 and num = nxt2





Select DISTINCT l1.Num from Logs l1, Logs l2, Logs l3 
where l1.Id=l2.Id-1 and l2.Id=l3.Id-1 
and l1.Num=l2.Num and l2.Num=l3.Num


select distinct Num as ConsecutiveNums
from Logs
where (Id + 1, Num) in (select * from Logs) and (Id + 2, Num) in (select * from Logs)