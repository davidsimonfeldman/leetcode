/* Write your T-SQL query statement below  
1204. Last Person to Fit in the Elevator
Medium
 
SQL Schema
Table: Queue

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| person_id   | int     |
| person_name | varchar |
| weight      | int     |
| turn        | int     |
+-------------+---------+
person_id is the primary key column for this table.
This table has the information about all people waiting for an elevator.
The person_id and turn columns will contain all numbers from 1 to n, where n is the number of rows in the table.
 

The maximum weight the elevator can hold is 1000.

Write an SQL query to find the person_name of the last person who will fit in the elevator without exceeding the weight limit. It is guaranteed that the person who is first in the queue can fit in the elevator.

The query result format is in the following example:

Queue table
+-----------+-------------------+--------+------+
| person_id | person_name       | weight | turn |
+-----------+-------------------+--------+------+
| 5         | George Washington | 250    | 1    |
| 3         | John Adams        | 350    | 2    |
| 6         | Thomas Jefferson  | 400    | 3    |
| 2         | Will Johnliams    | 200    | 4    |
| 4         | Thomas Jefferson  | 175    | 5    |
| 1         | James Elephant    | 500    | 6    |
+-----------+-------------------+--------+------+

Result table
+-------------------+
| person_name       |
+-------------------+
| Thomas Jefferson  |
+-------------------+

Queue table is ordered by turn in the example for simplicity.
In the example George Washington(id 5), John Adams(id 3) and Thomas Jefferson(id 6) will enter the elevator as their weight sum is 250 + 350 + 400 = 1000.
Thomas Jefferson(id 6) is the last person to fit in the elevator because he has the last turn in these three people.




with cs as (
  select *,
    sum(weight) over(order by turn) as cum_sum
  from queue
)
select person_name from cs
where cum_sum <= 1000
order by cum_sum desc
limit 1

The steps:
(1) Get cumulative sum weight using Join with condition q1.turn >= q2.turn and Group By q1.turn
(2) Filter the groups with cum sum <=1000
(3) Order by cum sum with Desc order, select the 1st.

SELECT q1.person_name
FROM Queue q1 JOIN Queue q2 ON q1.turn >= q2.turn
GROUP BY q1.turn
HAVING SUM(q2.weight) <= 1000
ORDER BY SUM(q2.weight) DESC
LIMIT 1


with cs as (
  select *,
    sum(weight) over(order by turn) as cum_sum
  from queue
)
select person_name from cs
where cum_sum = (select max(cum_sum) from cs where cum_sum <= 1000)








with cte as (
SELECT person_name,weight,sum(weight) over(order by turn asc) as cumulative_weight 
from queue
group by person_name,weight)

select person_name from cte
WHERE cumulative_weight<=1000
order by cumulative_weight desc
limit 1




