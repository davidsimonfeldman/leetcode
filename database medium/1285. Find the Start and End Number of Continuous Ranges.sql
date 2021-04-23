/* 
1285. Find the Start and End Number of Continuous Ranges
Medium
SQL Schema
Table: Logs

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| log_id        | int     |
+---------------+---------+
id is the primary key for this table.
Each row of this table contains the ID in a log Table.

Since some IDs have been removed from Logs. Write an SQL query to find the start and end number of continuous ranges in table Logs.

Order the result table by start_id.

The query result format is in the following example:

Logs table:
+------------+
| log_id     |
+------------+
| 1          |
| 2          |
| 3          |
| 7          |
| 8          |
| 10         |
+------------+

Result table:
+------------+--------------+
| start_id   | end_id       |
+------------+--------------+
| 1          | 3            |
| 7          | 8            |
| 10         | 10           |
+------------+--------------+
The result table should contain all ranges in table Logs.
From 1 to 3 is contained in the table.
From 4 to 6 is missing in the table
From 7 to 8 is contained in the table.
Number 9 is missing in the table.
Number 10 is contained in the table.










SELECT min(log_id) as start_id, max(log_id) as end_id
FROM
(SELECT log_id, ROW_NUMBER() OVER(ORDER BY log_id) as num
FROM Logs) a
GROUP BY log_id - num





select L1.log_id as START_ID, min(L2.log_id) as END_ID
from 
	(select log_id from Logs 
	where log_id-1 not in (select log_id from Logs)) L1,
	(select log_id from Logs 
	where log_id+1 not in (select log_id from Logs)) L2
where L1.log_id <= L2.log_id
group by L1.log_id











WITH temp1 AS(SELECT log_id
,log_id-ROW_NUMBER() OVER(ORDER BY log_id) AS difference
FROM Logs)

SELECT MIN(log_id) AS start_id
,MAX(log_id) AS end_id
FROM temp1
GROUP BY difference
ORDER BY start_id

Just calculate the differece between log_id and corresponding row_number, and select the min and max log_id within each difference.