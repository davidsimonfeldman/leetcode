/*
580. Count Student Number in Departments
Medium
SQL Schema
A university uses 2 data tables, student and department, to store data about its students and the departments associated with each major.

Write a query to print the respective department name and number of students majoring in each department for all departments in the department table (even ones with no current students).

Sort your results by descending number of students; if two or more departments have the same number of students, then sort those departments alphabetically by department name.

The student is described as follow:

| Column Name  | Type      |
|--------------|-----------|
| student_id   | Integer   |
| student_name | String    |
| gender       | Character |
| dept_id      | Integer   |
where student_id is the student's ID number, student_name is the student's name, gender is their gender, and dept_id is the department ID associated with their declared major.

And the department table is described as below:

| Column Name | Type    |
|-------------|---------|
| dept_id     | Integer |
| dept_name   | String  |
where dept_id is the department's ID number and dept_name is the department name.

Here is an example input:
student table:

| student_id | student_name | gender | dept_id |
|------------|--------------|--------|---------|
| 1          | Jack         | M      | 1       |
| 2          | Jane         | F      | 1       |
| 3          | Mark         | M      | 2       |
department table:

| dept_id | dept_name   |
|---------|-------------|
| 1       | Engineering |
| 2       | Science     |
| 3       | Law         |
The Output should be:

| dept_name   | student_number |
|-------------|----------------|
| Engineering | 2              |
| Science     | 1              |
| Law         | 0              |




SELECT dept_name, SUM(CASE WHEN s.dept_id THEN 1 ELSE 0 END) as student_number
FROM department d LEFT JOIN student s ON d.dept_id = s.dept_id
GROUP BY 1
ORDER BY 2 desc, 1


SELECT d.dept_name, COUNT(s.student_id) AS student_number
FROM student s RIGHT JOIN department d ON s.dept_id = d.dept_id
GROUP BY d.dept_name 
ORDER BY student_number DESC, d.dept_name;




select dept_name,count(student_name)student_number
from 
(select  d.dept_id ,dept_name,student_name
from student s
right join department d
on s.dept_id=d.dept_id)s
group by 1
order by student_number desc