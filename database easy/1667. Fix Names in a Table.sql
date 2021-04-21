/* 
1667. Fix Names in a Table
Easy
 
SQL Schema
Table: Users

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| user_id        | int     |
| name           | varchar |
+----------------+---------+
user_id is the primary key for this table.
This table contains the ID and the name of the user. The name consists of only lowercase and uppercase characters.
 

Write an SQL query to fix the names so that only the first character is uppercase and the rest are lowercase.

Return the result table ordered by user_id.

The query result format is in the following example:

 

Users table:
+---------+-------+
| user_id | name  |
+---------+-------+
| 1       | aLice |
| 2       | bOB   |
+---------+-------+

Result table:
+---------+-------+
| user_id | name  |
+---------+-------+
| 1       | Alice |
| 2       | Bob   |
+---------+-------+

Write your T-SQL query statement below
select user_id, UPPER(LEFT(name,1))+LOWER(SUBSTRING(name,2,LEN(name))) name
from Users
order by 1


SELECT user_id, concat(upper(substring(name,1,1)),lower(substring(name,2,length(name)-1))) as name
FROM Users
order by user_id

 */