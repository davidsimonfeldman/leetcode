/*
579. Find Cumulative Salary of an Employee
Hard
SQL Schema
The Employee table holds the salary information in a year.

Write a SQL to get the cumulative sum of an employee's salary over a period of 3 months but exclude the most recent month.

The result should be displayed by 'Id' ascending, and then by 'Month' descending.

Example
Input

| Id | Month | Salary |
|----|-------|--------|
| 1  | 1     | 20     |
| 2  | 1     | 20     |
| 1  | 2     | 30     |
| 2  | 2     | 30     |
| 3  | 2     | 40     |
| 1  | 3     | 40     |
| 3  | 3     | 60     |
| 1  | 4     | 60     |
| 3  | 4     | 70     |
Output

| Id | Month | Salary |
|----|-------|--------|
| 1  | 3     | 90     |
| 1  | 2     | 50     |
| 1  | 1     | 20     |
| 2  | 1     | 20     |
| 3  | 3     | 100    |
| 3  | 2     | 40     |
 

Explanation
Employee '1' has 3 salary records for the following 3 months except the most recent month '4': salary 40 for month '3', 30 for month '2' and 20 for month '1'
So the cumulative sum of salary of this employee over 3 months is 90(40+30+20), 50(30+20) and 20 respectively.

| Id | Month | Salary |
|----|-------|--------|
| 1  | 3     | 90     |
| 1  | 2     | 50     |
| 1  | 1     | 20     |
Employee '2' only has one salary record (month '1') except its most recent month '2'.
| Id | Month | Salary |
|----|-------|--------|
| 2  | 1     | 20     |
 

Employ '3' has two salary records except its most recent pay month '4': month '3' with 60 and month '2' with 40. So the cumulative salary is as following.
| Id | Month | Salary |
|----|-------|--------|
| 3  | 3     | 100    |
| 3  | 2     | 40     |

















WITH cte AS ( SELECT id
        , salary
        , LAG(month) OVER (partition BY id ORDER BY month) AS m
        , SUM(salary) OVER (partition BY id ORDER BY month rows 3 preceding) - salary AS s
    FROM employee
        ORDER BY id, month )

SELECT id      , m AS month      , s AS salary
FROM cte
    WHERE m IS NOT null
    ORDER BY id, m DESC    
    
    
    
    
    SELECT id, month, Salary
FROM
(
SELECT  id, 
        month, 
		-- Every 3 months. ROWS 2 PRECEDING indicates the number of rows or values to precede the current row (1 + 2)
        SUM(salary) OVER(PARTITION BY id  ORDER BY month ROWS 2 PRECEDING) as Salary, 
        DENSE_RANK() OVER(PARTITION BY id ORDER by month DESC) month_no
FROM Employee
)  src
--  exclude the most recent month
where month_no > 1
ORDER BY id , month desc
    
    
    
    select e1.id,e1.month month,sum(e2.salary) salary
from
employee e1 inner join employee e2 on e1.id=e2.id and (e1.Month - e2.Month) between 0 and 2
where (e1.id,e1.month) not in (select id,max(month) from employee group by id)
group by e1.id,e1.month
order by e1.id,e1.month desc
    
    
    
    
    
    
    
    
    SELECT   A.Id, MAX(B.Month) as Month, SUM(B.Salary) as Salary
FROM     Employee A, Employee B
WHERE    A.Id = B.Id AND B.Month BETWEEN (A.Month-3) AND (A.Month-1)
GROUP BY A.Id, A.Month
ORDER BY Id, Month DESC