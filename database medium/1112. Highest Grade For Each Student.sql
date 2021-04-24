/*
1112. Highest Grade For Each Student
Medium
SQL Schema
Table: Enrollments

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| student_id    | int     |
| course_id     | int     |
| grade         | int     |
+---------------+---------+
(student_id, course_id) is the primary key of this table.

Write a SQL query to find the highest grade with its corresponding course for each student. In case of a tie, you should find the course with the smallest course_id. The output must be sorted by increasing student_id.

The query result format is in the following example:

Enrollments table:
+------------+-------------------+
| student_id | course_id | grade |
+------------+-----------+-------+
| 2          | 2         | 95    |
| 2          | 3         | 95    |
| 1          | 1         | 90    |
| 1          | 2         | 99    |
| 3          | 1         | 80    |
| 3          | 2         | 75    |
| 3          | 3         | 82    |
+------------+-----------+-------+

Result table:
+------------+-------------------+
| student_id | course_id | grade |
+------------+-----------+-------+
| 1          | 2         | 99    |
| 2          | 2         | 95    |
| 3          | 3         | 82    |
+------------+-----------+-------+






SELECT DISTINCT student_id,MIN(course_id) AS course_id,grade 
FROM Enrollments
WHERE (student_id,grade) IN (SELECT DISTINCT student_id, max(grade) FROM Enrollments GROUP BY student_id)
GROUP BY student_id 
ORDER BY student_id;



 


SELECT t.student_id, t.course_id, t.grade
FROM 
	(SELECT student_id, course_id, grade, 
	row_number() over (partition by student_id order by grade desc, course_id asc) as r 
	FROM Enrollments) t
WHERE t.r=1
ORDER BY t.student_id asc




# Write your MySQL query statement below
select student_id,  min(course_id)course_id, grade
from Enrollments
 where (student_id,  grade)
 in(
select student_id,  max(grade)   
     from  Enrollments
     group by 1
 )
 group by 1
order by 1