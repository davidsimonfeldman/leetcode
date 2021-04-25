/*
1412. Find the Quiet Students in All Exams
Hard
SQL Schema
Table: Student

+---------------------+---------+
| Column Name         | Type    |
+---------------------+---------+
| student_id          | int     |
| student_name        | varchar |
+---------------------+---------+
student_id is the primary key for this table.
student_name is the name of the student.
 

Table: Exam

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| exam_id       | int     |
| student_id    | int     |
| score         | int     |
+---------------+---------+
(exam_id, student_id) is the primary key for this table.
Student with student_id got score points in exam with id exam_id.
 

A "quite" student is the one who took at least one exam and didn't score neither the high score nor the low score.

Write an SQL query to report the students (student_id, student_name) being "quiet" in ALL exams.

Don't return the student who has never taken any exam. Return the result table ordered by student_id.

The query result format is in the following example.

 

Student table:
+-------------+---------------+
| student_id  | student_name  |
+-------------+---------------+
| 1           | Daniel        |
| 2           | Jade          |
| 3           | Stella        |
| 4           | Jonathan      |
| 5           | Will          |
+-------------+---------------+

Exam table:
+------------+--------------+-----------+
| exam_id    | student_id   | score     |
+------------+--------------+-----------+
| 10         |     1        |    70     |
| 10         |     2        |    80     |
| 10         |     3        |    90     |
| 20         |     1        |    80     |
| 30         |     1        |    70     |
| 30         |     3        |    80     |
| 30         |     4        |    90     |
| 40         |     1        |    60     |
| 40         |     2        |    70     |
| 40         |     4        |    80     |
+------------+--------------+-----------+

Result table:
+-------------+---------------+
| student_id  | student_name  |
+-------------+---------------+
| 2           | Jade          |
+-------------+---------------+

For exam 1: Student 1 and 3 hold the lowest and high score respectively.
For exam 2: Student 1 hold both highest and lowest score.
For exam 3 and 4: Studnet 1 and 4 hold the lowest and high score respectively.
Student 2 and 5 have never got the highest or lowest in any of the exam.
Since student 5 is not taking any exam, he is excluded from the result.
So, we only return the information of Student 2.







select student_id,student_name from student
where student_id in (select student_id from exam) and student_id not in (
select student_id from(
select student_id,
rank() over(partition by exam_id order by score asc) as asc_rank,
rank() over(partition by exam_id order by score desc) as desc_rank from exam ) tab1
where asc_rank=1 or desc_rank=1)




WITH CTE AS 
(
    SELECT 
      student_id,
      DENSE_RANK() OVER(PARTITION BY exam_id ORDER BY score ASC) AS RK1,
      DENSE_RANK() OVER(PARTITION BY exam_id ORDER BY score DESC) AS RK2
    FROM Exam
)

SELECT DISTINCT Student.student_id,student_name
FROM CTE INNER JOIN Student ON CTE.student_id = Student.student_id
WHERE Student.student_id NOT IN (SELECT student_id FROM CTE WHERE RK1 = 1 OR RK2 = 1)
ORDER BY 1 ASC





WITH cte AS 
(
	SELECT exam_id, student_id, 
	RANK() OVER(partition by exam_id order by score DESC) AS "high_score",
	RANK() OVER(partition by exam_id order by score) AS "low_score"
	FROM Exam 
)

SELECT DISTINCT e.student_id, s.student_name
FROM Exam e LEFT JOIN Student s ON s.student_id = e.student_id
WHERE e.student_id NOT IN (SELECT student_id FROM cte WHERE high_score = 1 OR low_score = 1)






 WITH cte AS(
    SELECT exam_id, exam.student_id, student_name, score, 
     RANK() OVER(PARTITION BY exam_id ORDER BY score) rk1, 
     RANK() OVER(PARTITION BY exam_id ORDER BY score DESC) rk2 
    FROM exam LEFT JOIN student
    ON exam.student_id = student.student_id
)

SELECT DISTINCT student_id, student_name
FROM cte
WHERE student_id NOT IN (SELECT student_id FROM cte WHERE rk1 = 1 or rk2 = 1)
ORDER BY student_id