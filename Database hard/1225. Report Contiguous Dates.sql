/*
1225. Report Contiguous Dates
Hard

SQL Schema
Table: Failed

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| fail_date    | date    |
+--------------+---------+
Primary key for this table is fail_date.
Failed table contains the days of failed tasks.
Table: Succeeded

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| success_date | date    |
+--------------+---------+
Primary key for this table is success_date.
Succeeded table contains the days of succeeded tasks.
 

A system is running one task every day. Every task is independent of the previous tasks. The tasks can fail or succeed.

Write an SQL query to generate a report of period_state for each continuous interval of days in the period from 2019-01-01 to 2019-12-31.

period_state is 'failed' if tasks in this interval failed or 'succeeded' if tasks in this interval succeeded. Interval of days are retrieved as start_date and end_date.

Order result by start_date.

The query result format is in the following example:

Failed table:
+-------------------+
| fail_date         |
+-------------------+
| 2018-12-28        |
| 2018-12-29        |
| 2019-01-04        |
| 2019-01-05        |
+-------------------+

Succeeded table:
+-------------------+
| success_date      |
+-------------------+
| 2018-12-30        |
| 2018-12-31        |
| 2019-01-01        |
| 2019-01-02        |
| 2019-01-03        |
| 2019-01-06        |
+-------------------+


Result table:
+--------------+--------------+--------------+
| period_state | start_date   | end_date     |
+--------------+--------------+--------------+
| succeeded    | 2019-01-01   | 2019-01-03   |
| failed       | 2019-01-04   | 2019-01-05   |
| succeeded    | 2019-01-06   | 2019-01-06   |
+--------------+--------------+--------------+

The report ignored the system state in 2018 as we care about the system in the period 2019-01-01 to 2019-12-31.
From 2019-01-01 to 2019-01-03 all tasks succeeded and the system state was "succeeded".
From 2019-01-04 to 2019-01-05 all tasks failed and system state was "failed".
From 2019-01-06 to 2019-01-06 all tasks succeeded and system state was "succeeded".




SELECT stats AS period_state, MIN(day) AS start_date, MAX(day) AS end_date
FROM (
    SELECT 
        day, 
        RANK() OVER (ORDER BY day) AS overall_ranking, 
        stats, 
        rk, 
        (RANK() OVER (ORDER BY day) - rk) AS inv
    FROM (
        SELECT fail_date AS day, 'failed' AS stats, 
            RANK() OVER (ORDER BY fail_date) AS rk
        FROM Failed
        WHERE fail_date BETWEEN '2019-01-01' AND '2019-12-31'
        UNION 
        SELECT success_date AS day, 'succeeded' AS stats, 
            RANK() OVER (ORDER BY success_date) AS rk
        FROM Succeeded
        WHERE success_date BETWEEN '2019-01-01' AND '2019-12-31') t
    ) c
GROUP BY inv, stats
ORDER BY start_date










day   | overall_ranking| stats | rk | inv          
| 2019-01-01 | 1 | success | 1 | 0
| 2019-01-02 | 2 | success | 2 | 0
| 2019-01-03 | 3 | success | 3 | 0
| 2019-01-04 | 4 | fail | 1 | 3
| 2019-01-05 | 5 | fail | 2 | 3
| 2019-01-06 | 6 | success | 4 | 2
| 2019-01-07 | 7 | success | 5 | 2
| 2019-01-08 | 8 | fail | 3 | 5
| 2019-01-09 | 9 | fail | 4 | 5

SELECT stats AS period_state, MIN(day) AS start_date, MAX(day) AS end_date
FROM (
    SELECT 
        day, 
        RANK() OVER (ORDER BY day) AS overall_ranking, 
        stats, 
        rk, 
        (RANK() OVER (ORDER BY day) - rk) AS inv
    FROM (
        SELECT fail_date AS day, 'failed' AS stats, RANK() OVER (ORDER BY fail_date) AS rk
        FROM Failed
        WHERE fail_date BETWEEN '2019-01-01' AND '2019-12-31'
        UNION 
        SELECT success_date AS day, 'succeeded' AS stats, RANK() OVER (ORDER BY success_date) AS rk
        FROM Succeeded
        WHERE success_date BETWEEN '2019-01-01' AND '2019-12-31') t
    ) c
GROUP BY inv, stats
ORDER BY start_date









WITH combined as 
(
     SELECT 
        fail_date as dt, 
        'failed' as period_state,
        DAYOFYEAR(fail_date) - row_number() over(ORDER BY fail_date) as period_group 
     FROM 
        Failed
     WHERE fail_date BETWEEN '2019-01-01' AND '2019-12-31'
     UNION ALL
     SELECT 
        success_date as dt, 
        'succeeded' as period_state,
        DAYOFYEAR(success_date) - row_number() over(ORDER BY success_date) as period_group 
     FROM Succeeded
     WHERE success_date BETWEEN '2019-01-01' AND '2019-12-31'  
)

SELECT 
    period_state,
    min(dt) as start_date,
    max(dt) as end_date
FROM
        combined
GROUP BY period_state,period_group
ORDER BY start_date








The idea here is to use row_number to get a unique grouping label for each continous sequence.
We can then easily find the min/max dates in each group

with a  as (
(select fail_date as date,
       'failed' as period_state
       from failed)
union all
 
 (select success_date as date,
         'succeeded' as period_state
         from succeeded)
    ),
    
  b as (    
select date,
       period_state,
       row_number() over (order by period_state, date asc) as seq
   from a where date between '2019-01-01' and '2019-12-31'
         ),

 c as (
select date, period_state,seq, dateadd(d, -seq, date) as seqStart from b
)

select period_state, min(date) as start_date, max(date) as end_date from c
group by seqStart,period_state
order by start_date asc








SELECT stats AS period_state, MIN(day) AS start_date, MAX(day) AS end_date
FROM (
    SELECT 
        day, 
        RANK() OVER (ORDER BY day) AS overall_ranking, 
        stats, 
        rk, 
        (RANK() OVER (ORDER BY day) - rk) AS inv
    FROM (
        SELECT fail_date AS day, 'failed' AS stats, RANK() OVER (ORDER BY fail_date) AS rk
        FROM Failed
        WHERE fail_date BETWEEN '2019-01-01' AND '2019-12-31'
        UNION 
        SELECT success_date AS day, 'succeeded' AS stats, RANK() OVER (ORDER BY success_date) AS rk
        FROM Succeeded
        WHERE success_date BETWEEN '2019-01-01' AND '2019-12-31') t
    ) c
GROUP BY inv, stats
ORDER BY start_date


/* Write your T-SQL query statement below */
with a  as (
(select fail_date as date,
       'failed' as period_state
       from failed)
union all 
 (select success_date as date,
         'succeeded' as period_state
         from succeeded)
    ),
    
  b as (    
select date,
       period_state,
       row_number() over (order by period_state, date asc) as seq
   from a where year(date)='2019'  
         )

select period_state, min(date) as start_date, max(date) as end_date from b
group by dateadd(d, -seq, date),period_state
order by start_date asc