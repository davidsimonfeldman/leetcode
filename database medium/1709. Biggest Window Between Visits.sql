/* 
1709. Biggest Window Between Visits
Medium
 SQL Schema
Table: UserVisits

+-------------+------+
| Column Name | Type |
+-------------+------+
| user_id     | int  |
| visit_date  | date |
+-------------+------+
This table does not have a primary key.
This table contains logs of the dates that users vistied a certain retailer.
 

Assume today's date is '2021-1-1'.

Write an SQL query that will, for each user_id, find out the largest window of days between each visit and the one right after it (or today if you are considering the last visit).

Return the result table ordered by user_id.

The query result format is in the following example:

 

UserVisits table:
+---------+------------+
| user_id | visit_date |
+---------+------------+
| 1       | 2020-11-28 |
| 1       | 2020-10-20 |
| 1       | 2020-12-3  |
| 2       | 2020-10-5  |
| 2       | 2020-12-9  |
| 3       | 2020-11-11 |
+---------+------------+
Result table:
+---------+---------------+
| user_id | biggest_window|
+---------+---------------+
| 1       | 39            |
| 2       | 65            |
| 3       | 51            |
+---------+---------------+
For the first user, the windows in question are between dates:
    - 2020-10-20 and 2020-11-28 with a total of 39 days. 
    - 2020-11-28 and 2020-12-3 with a total of 5 days. 
    - 2020-12-3 and 2021-1-1 with a total of 29 days.
Making the biggest window the one with 39 days.
For the second user, the windows in question are between dates:
    - 2020-10-5 and 2020-12-9 with a total of 65 days.
    - 2020-12-9 and 2021-1-1 with a total of 23 days.
Making the biggest window the one with 65 days.
For the third user, the only window in question is between dates 2020-11-11 and 2021-1-1 with a total of 51 days.

SELECT user_id, MAX(diff) AS biggest_window
FROM
(
	SELECT user_id, 
	   DATEDIFF(LEAD(visit_date, 1, '2021-01-01') OVER (PARTITION BY user_id ORDER BY visit_date), visit_date) AS diff
	FROM userVisits
) a
GROUP BY user_id
ORDER BY user_id








select
    user_id,
    max(window1) biggest_window
from
(
select
    user_id,
    abs(datediff( visit_date, ifnull( lead(visit_date) over(partition by user_id order by visit_date), '2021-1-1'))) window1
from UserVisits 
) t    
group by user_id
order by 1



Step 1: Calculate the Next Visit Date "lead(visit_date) over(partition by user_id order by visit_date)"
Step 2: If this returns NULL this means we need to use today's date which is '2021-1-1'
Step 3: Subtract Next Visit Date with Given Visit Date.
Step 4: If you care less about the datediff syntax use abs function which will always return positive value (here it makes more sense as we need to return the biggest value anyways).
Step 5: Get the max value max(window1) for each user_id

Note: I have used column name as window1 because "window" is a reserved word for MYSQL, so it throws error.

MYSQL:

select
    user_id,
    max(window1) biggest_window
from
(
select
    user_id,
    abs(datediff( visit_date, ifnull( lead(visit_date) over(partition by user_id order by visit_date), '2021-1-1'))) window1
from UserVisits 
) t    
group by user_id
order by 1
SQL Server:

select
    user_id,
    max(window1) biggest_window
from
(
select
    user_id,
    abs(datediff( dd, visit_date, isnull( lead(visit_date) over(partition by user_id order by visit_date), '2021-1-1'))) window1
from UserVisits 
) t    
group by user_id
order by 1