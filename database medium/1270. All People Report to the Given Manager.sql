/*
1270. All People Report to the Given Manager
Medium
SQL Schema
Table: Employees

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| employee_id   | int     |
| employee_name | varchar |
| manager_id    | int     |
+---------------+---------+
employee_id is the primary key for this table.
Each row of this table indicates that the employee with ID employee_id and name employee_name reports his work to his/her direct manager with manager_id
The head of the company is the employee with employee_id = 1.
 

Write an SQL query to find employee_id of all employees that directly or indirectly report their work to the head of the company.

The indirect relation between managers will not exceed 3 managers as the company is small.

Return result table in any order without duplicates.

The query result format is in the following example:

Employees table:
+-------------+---------------+------------+
| employee_id | employee_name | manager_id |
+-------------+---------------+------------+
| 1           | Boss          | 1          |
| 3           | Alice         | 3          |
| 2           | Bob           | 1          |
| 4           | Daniel        | 2          |
| 7           | Luis          | 4          |
| 8           | Jhon          | 3          |
| 9           | Angela        | 8          |
| 77          | Robert        | 1          |
+-------------+---------------+------------+

Result table:
+-------------+
| employee_id |
+-------------+
| 2           |
| 77          |
| 4           |
| 7           |
+-------------+

The head of the company is the employee with employee_id 1.
The employees with employee_id 2 and 77 report their work directly to the head of the company.
The employee with employee_id 4 report his work indirectly to the head of the company 4 --> 2 --> 1. 
The employee with employee_id 7 report his work indirectly to the head of the company 7 --> 4 --> 2 --> 1.
The employees with employee_id 3, 8 and 9 don't report their work to head of company directly or indirectly. 




SELECT main.employee_id FROM Employees AS main
LEFT JOIN Employees AS t1 ON main.manager_id = t1.employee_id
LEFT JOIN Employees AS t2 ON t1.manager_id = t2.employee_id
WHERE main.employee_id != 1 AND t2.manager_id = 1




with direct_reports as (
select employee_id
from employees 
where manager_id = 1
and employee_id != manager_id
),

indirect_reports_lvl1 as (
 select a.employee_id
 from employees a
 join direct_reports b
 on a.manager_id = b.employee_id
 group by a.employee_id
),

indirect_reports_lvl2 as (
select a.employee_id
from employees a
join indirect_reports_lvl1 b
on a.manager_id = b.employee_id
group by a.employee_id
)

select employee_id
from direct_reports

union all

select employee_id
from indirect_reports_lvl1

union all

select employee_id
from indirect_reports_lvl2


SELECT a.employee_id FROM Employees a JOIN Employees b JOIN Employees c
ON a.manager_id = b.employee_id AND b.manager_id = c.employee_id
WHERE c.manager_id = 1 AND a.employee_id != 1




SELECT e1.employee_id
FROM Employees e1,
     Employees e2,
     Employees e3
WHERE e1.manager_id = e2.employee_id
  AND e2.manager_id = e3.employee_id
  AND e3.manager_id = 1 
  AND e1.employee_id != 1





# Write your MySQL query statement below
select employee_id from (select distinct emp.employee_id
from Employees emp join 
     Employees sup on 
     emp.manager_id=sup.employee_id
                   join 
     Employees sup2 on 
     sup.manager_id=sup2.manager_id
                   join 
     Employees sup3 on 
     sup3.employee_id=sup2.manager_id 
  where     emp.manager_id=1 and sup2.manager_id=1 or sup3.manager_id=1
 order by 1 desc)  f
 where f.employee_id!=1