/*
1132. Reported Posts II
Medium
 SQL Schema
Table: Actions

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| user_id       | int     |
| post_id       | int     |
| action_date   | date    |
| action        | enum    |
| extra         | varchar |
+---------------+---------+
There is no primary key for this table, it may have duplicate rows.
The action column is an ENUM type of ('view', 'like', 'reaction', 'comment', 'report', 'share').
The extra column has optional information about the action such as a reason for report or a type of reaction. 
Table: Removals

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| post_id       | int     |
| remove_date   | date    | 
+---------------+---------+
post_id is the primary key of this table.
Each row in this table indicates that some post was removed as a result of being reported or as a result of an admin review.
 

Write an SQL query to find the average for daily percentage of posts that got removed after being reported as spam, rounded to 2 decimal places.

The query result format is in the following example:

Actions table:
+---------+---------+-------------+--------+--------+
| user_id | post_id | action_date | action | extra  |
+---------+---------+-------------+--------+--------+
| 1       | 1       | 2019-07-01  | view   | null   |
| 1       | 1       | 2019-07-01  | like   | null   |
| 1       | 1       | 2019-07-01  | share  | null   |
| 2       | 2       | 2019-07-04  | view   | null   |
| 2       | 2       | 2019-07-04  | report | spam   |
| 3       | 4       | 2019-07-04  | view   | null   |
| 3       | 4       | 2019-07-04  | report | spam   |
| 4       | 3       | 2019-07-02  | view   | null   |
| 4       | 3       | 2019-07-02  | report | spam   |
| 5       | 2       | 2019-07-03  | view   | null   |
| 5       | 2       | 2019-07-03  | report | racism |
| 5       | 5       | 2019-07-03  | view   | null   |
| 5       | 5       | 2019-07-03  | report | racism |
+---------+---------+-------------+--------+--------+

Removals table:
+---------+-------------+
| post_id | remove_date |
+---------+-------------+
| 2       | 2019-07-20  |
| 3       | 2019-07-18  |
+---------+-------------+

Result table:
+-----------------------+
| average_daily_percent |
+-----------------------+
| 75.00                 |
+-----------------------+
The percentage for 2019-07-04 is 50% because only one post of two spam reported posts was removed.
The percentage for 2019-07-02 is 100% because one post was reported as spam and it was removed.
The other days had no spam reports so the average is (50 + 100) / 2 = 75%
Note that the output is only one number and that we do not care about the remove dates.
















select round(avg(num_remove / num_spam) * 100, 2) as average_daily_percent
from
(
    select action_date, 
           count(distinct a.post_id) as num_spam,
           count(distinct case 
                               when remove_date is not null then a.post_id 
                               else null 
                          end) as num_remove
    from Actions a left join Removals r
    on a.post_id = r.post_id
    where extra = 'spam'
    group by action_date
    having num_spam > 0
) t







select distinct round(avg(d)*100,2) average_daily_percent from
(select distinct action_date,b*1.0/a*1.0 d from
(select distinct count(  action_date)over(partition by action_date) a,
	   count(  remove_date)over(partition by action_date)b , 
remove_date,action_date 
from
(SELECT distinct user_id
      ,a.post_id
      ,action_date
      ,action,sum(case when remove_date is not null then 1 else 0 end)a
      ,[extra],[remove_date]
  FROM Actions a
  left join Removals r
  on a.[post_id]=r.[post_id]
  where [action] ='report' and [extra]='spam'
  group by  [user_id]
      ,a.[post_id]
      ,[action_date]
      ,[action] 
      ,[extra],[remove_date])
	   c)h)r
       
       
       
       
       
       
       
       First calculate the daily percentage by joining the Actions table and the Removels table after we filtered out the posts that have been reported as 'spam'.
And then we can calculate the general average based on the daily average we calculated from the subquery.

select round(sum(percent)/count(distinct action_date),2) as average_daily_percent
from
    (select a.action_date,
    count(distinct r.post_id)/count(distinct a.post_id)*100 as percent
    from actions a left join removals r
    on a.post_id = r.post_id
    where a.extra='spam'
    group by 1) temp;
    
    
    
    
    SELECT ROUND(AVG(cnt), 2) AS average_daily_percent FROM
(
    SELECT (COUNT(DISTINCT r.post_id)/ COUNT(DISTINCT a.post_id))*100  AS cnt
FROM Actions a
LEFT JOIN Removals r
ON a.post_id = r.post_id
WHERE extra='spam' and action = 'report'
GROUP BY action_date)tmp









Basically we need a table with 3 columns: action_date, num_spam, num_remove.
Note that when counting numbers of spams and removals for each action_date, we need to use distinct to deal with duplicates.
select round(avg(num_remove / num_spam) * 100, 2) as average_daily_percent
from
(
    select action_date, 
           count(distinct a.post_id) as num_spam,
           count(distinct case 
                               when remove_date is not null then a.post_id 
                               else null 
                          end) as num_remove
    from Actions a left join Removals r
    on a.post_id = r.post_id
    where extra = 'spam'
    group by action_date
    having num_spam > 0
) t