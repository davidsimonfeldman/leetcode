/* 
1355. Activity Participants
Medium

SQL Schema
Table: Friends

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| name          | varchar |
| activity      | varchar |
+---------------+---------+
id is the id of the friend and primary key for this table.
name is the name of the friend.
activity is the name of the activity which the friend takes part in.
Table: Activities

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| name          | varchar |
+---------------+---------+
id is the primary key for this table.
name is the name of the activity.
 

Write an SQL query to find the names of all the activities with neither maximum, nor minimum number of participants.

Return the result table in any order. Each activity in table Activities is performed by any person in the table Friends.

The query result format is in the following example:

Friends table:
+------+--------------+---------------+
| id   | name         | activity      |
+------+--------------+---------------+
| 1    | Jonathan D.  | Eating        |
| 2    | Jade W.      | Singing       |
| 3    | Victor J.    | Singing       |
| 4    | Elvis Q.     | Eating        |
| 5    | Daniel A.    | Eating        |
| 6    | Bob B.       | Horse Riding  |
+------+--------------+---------------+

Activities table:
+------+--------------+
| id   | name         |
+------+--------------+
| 1    | Eating       |
| 2    | Singing      |
| 3    | Horse Riding |
+------+--------------+

Result table:
+--------------+
| activity     |
+--------------+
| Singing      |
+--------------+

Eating activity is performed by 3 friends, maximum number of participants, (Jonathan D. , Elvis Q. and Daniel A.)
Horse Riding activity is performed by 1 friend, minimum number of participants, (Bob B.)
Singing is performed by 2 friends (Victor J. and Jade W.)







select
activity
from friends
group by activity
having count(id) not in
(
    select
        max(cnt) as cnt
        from
        (select
    activity,
    count(id) as cnt
    from friends
    group by activity) tmp1
    
    union
    
      select
        min(cnt) as cnt
        from
        (select
    activity,
    count(id) as cnt
    from friends
    group by activity) tmp2

)
;







select activity 
from friends
group by activity
having count(*)> (select count(*) from friends group by activity order by 1 limit 1)
and count(*)< (select count(*) from friends group by activity order by 1 desc limit 1)





with a as (select distinct f.activity activity,count(f.id)over(partition by activity) c 
from Friends f
join Activities a
on f.activity=a.name
order by 2 desc)

select a.activity from a where 
a.c not in (select  max(a.c) from a)
and  a.c not in (select  min(a.c) from a)
 
 
 
 
 WITH temp as
(
select f.activity, count(f.name) as cnt
from Friends f right join Activities a on f.activity = a.name
group by a.name
)

select activity
from temp
where cnt <> (select max(cnt) from temp)
and cnt <> (select min(cnt) from temp);