/*

185. Department Top Three Salaries
Hard
SQL Schema
The Employee table holds all employees. Every employee has an Id, and there is also a column for the department Id.

+----+-------+--------+--------------+
| Id | Name  | Salary | DepartmentId |
+----+-------+--------+--------------+
| 1  | Joe   | 85000  | 1            |
| 2  | Henry | 80000  | 2            |
| 3  | Sam   | 60000  | 2            |
| 4  | Max   | 90000  | 1            |
| 5  | Janet | 69000  | 1            |
| 6  | Randy | 85000  | 1            |
| 7  | Will  | 70000  | 1            |
+----+-------+--------+--------------+
The Department table holds all departments of the company.

+----+----------+
| Id | Name     |
+----+----------+
| 1  | IT       |
| 2  | Sales    |
+----+----------+
Write a SQL query to find employees who earn the top three salaries in each of the department. For the above tables, your SQL query should return the following rows (order of rows does not matter).

+------------+----------+--------+
| Department | Employee | Salary |
+------------+----------+--------+
| IT         | Max      | 90000  |
| IT         | Randy    | 85000  |
| IT         | Joe      | 85000  |
| IT         | Will     | 70000  |
| Sales      | Henry    | 80000  |
| Sales      | Sam      | 60000  |
+------------+----------+--------+
Explanation:

In IT department, Max earns the highest salary, both Randy and Joe earn the second highest salary, and Will earns the third highest salary. There are only two employees in the Sales department, Henry earns the highest salary while Sam earns the second highest salary.


select D.Name as Department, E.Name as Employee, E.Salary as Salary 
  from Employee E, Department D
   where (select count(distinct(Salary)) from Employee 
           where DepartmentId = E.DepartmentId and Salary > E.Salary) in (0, 1, 2)
         and 
           E.DepartmentId = D.Id 
         order by E.DepartmentId, E.Salary DESC;
         
         
         
         
         with cte as
 ( select name,departmentId,salary,
 DENSE_RANK() OVER (PARTITION BY e.departmentId ORDER BY e.salary DESC) as Rank 
             from employee e   )
 select d.name as department,c.name as employee,c.salary 
from cte c 
inner join Department d on c.departmentId=d.id 
where c.rank<=3




# Write your MySQL query statement below
SELECT
    dpt.Name AS Department,
    e1.Name AS Employee,
    e1.Salary AS Salary
FROM Employee AS e1
INNER JOIN Department dpt
ON e1.DepartmentID = dpt.Id
WHERE 3 > (
           SELECT COUNT(DISTINCT Salary)
           FROM Employee AS e2
           WHERE e2.Salary > e1.Salary
           AND e1.DepartmentID = e2.DepartmentID
          )
ORDER BY
Department ASC,
Salary DESC;





select d.Name Department, e1.Name Employee, e1.Salary
from Employee e1 
join Department d
on e1.DepartmentId = d.Id
where 3 > (select count(distinct(e2.Salary)) 
                  from Employee e2 
                  where e2.Salary > e1.Salary 
                  and e1.DepartmentId = e2.DepartmentId
                  );
                  
                  
                  
                  
                  Select dep.Name as Department, emp.Name as Employee, emp.Salary from Department dep, 
Employee emp where emp.DepartmentId=dep.Id and 
(Select count(distinct Salary) From Employee where DepartmentId=dep.Id and Salary>emp.Salary)<3