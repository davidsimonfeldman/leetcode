/*
177. Nth Highest Salary
Medium
Write a SQL query to get the nth highest salary from the Employee table.

+----+--------+
| Id | Salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
+----+--------+
For example, given the above Employee table, the nth highest salary where n = 2 is 200. If there is no nth highest salary, then the query should return null.

+------------------------+
| getNthHighestSalary(2) |
+------------------------+
| 200                    |

CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
    set N=N-1;
  RETURN (
      select distinct Salary from Employee order by Salary desc limit N,1
  );
END

CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
DECLARE M INT;
SET M=N-1;
  RETURN (
      # Write your MySQL query statement below.
      SELECT DISTINCT Salary FROM Employee ORDER BY Salary DESC LIMIT M, 1
  );
END


   CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
    
  RETURN (
      # Write your MySQL query statement below.
      
    
      SELECT e1.Salary
      FROM (SELECT DISTINCT Salary FROM Employee) e1
      WHERE (SELECT COUNT(*) FROM (SELECT DISTINCT Salary FROM Employee) e2 WHERE e2.Salary > e1.Salary) = N - 1      
      
      LIMIT 1
      
      
      
      
  );
END





CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
RETURN (
# Write your MySQL query statement below.
select DISTINCT Salary
from (select Salary,DENSE_RANK() OVER(ORDER BY Salary DESC) as d_rank from Employee) as sub where d_rank = n
);
END