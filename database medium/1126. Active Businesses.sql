/*
1126. Active Businesses
Medium
SQL Schema
Table: Events

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| business_id   | int     |
| event_type    | varchar |
| occurences    | int     | 
+---------------+---------+
(business_id, event_type) is the primary key of this table.
Each row in the table logs the info that an event of some type occured at some business for a number of times.
 

Write an SQL query to find all active businesses.

An active business is a business that has more than one event type with occurences greater than the average occurences of that event type among all businesses.

The query result format is in the following example:

Events table:
+-------------+------------+------------+
| business_id | event_type | occurences |
+-------------+------------+------------+
| 1           | reviews    | 7          |
| 3           | reviews    | 3          |
| 1           | ads        | 11         |
| 2           | ads        | 7          |
| 3           | ads        | 6          |
| 1           | page views | 3          |
| 2           | page views | 12         |
+-------------+------------+------------+

Result table:
+-------------+
| business_id |
+-------------+
| 1           |
+-------------+ 
Average for 'reviews', 'ads' and 'page views' are (7+3)/2=5, (11+7+6)/3=8, (3+12)/2=7.5 respectively.
Business with id 1 has 7 'reviews' events (more than 5) and 11 'ads' events (more than 8) so it is an active business.









select business_id                                      # Finally, select 'business_id'
from
(select event_type, avg(occurences) as ave_occurences   # First, take the average of 'occurences' group by 'event_type'
 from events as e1
 group by event_type
) as temp1
join events as e2 on temp1.event_type = e2.event_type   # Second, join Events table on 'event_type'
where e2.occurences > temp1.ave_occurences              # Third, the 'occurences' should be greater than the average of 'occurences'
group by business_id
having count(distinct temp1.event_type) > 1             # (More than one event type with 'occurences' greater than 1)


WITH r2 AS(
SELECT *, CASE WHEN occurences > AVG(occurences) OVER (PARTITION BY event_type) THEN 1 ELSE 0 END AS chosen
FROM Events)
SELECT business_id
FROM r2
GROUP BY business_id
HAVING SUM(chosen) >1;




select 
business_id

from events as a
left join
    (
    select event_type, avg(occurences) as av
    from events
    group by event_type
    ) as b
on a.event_type = b.event_type
where a.occurences > b.av
group by business_id
having count(*)>1;





select business_id from 
(
select  * , avg(occurences) over(partition by event_type ) as e_avg from 
events
) a where occurences>e_avg
group by business_id having count(event_type)>1