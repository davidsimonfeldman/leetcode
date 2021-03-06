/*
615. Average Salary: Departments VS Company
Hard
SQL Schema
Given two tables as below, write a query to display the comparison result (higher/lower/same) of the average salary of employees in a department to the company's average salary.
 

Table: salary
| id | employee_id | amount | pay_date   |
|----|-------------|--------|------------|
| 1  | 1           | 9000   | 2017-03-31 |
| 2  | 2           | 6000   | 2017-03-31 |
| 3  | 3           | 10000  | 2017-03-31 |
| 4  | 1           | 7000   | 2017-02-28 |
| 5  | 2           | 6000   | 2017-02-28 |
| 6  | 3           | 8000   | 2017-02-28 |
 

The employee_id column refers to the employee_id in the following table employee.
 

| employee_id | department_id |
|-------------|---------------|
| 1           | 1             |
| 2           | 2             |
| 3           | 2             |
 

So for the sample data above, the result is:
 

| pay_month | department_id | comparison  |
|-----------|---------------|-------------|
| 2017-03   | 1             | higher      |
| 2017-03   | 2             | lower       |
| 2017-02   | 1             | same        |
| 2017-02   | 2             | same        |
 

Explanation
 

In March, the company's average salary is (9000+6000+10000)/3 = 8333.33...
 

The average salary for department '1' is 9000, which is the salary of employee_id '1' since there is only one employee in this department. So the comparison result is 'higher' since 9000 > 8333.33 obviously.
 

The average salary of department '2' is (6000 + 10000)/2 = 8000, which is the average of employee_id '2' and '3'. So the comparison result is 'lower' since 8000 < 8333.33.
 

With he same formula for the average salary comparison in February, the result is 'same' since both the department '1' and '2' have the same average salary with the company, which is 7000.
 
 
 
 
 
 
 
 
 select t.pay_month, t.department_id, case when avg1=avg2 then 'same' when avg1>avg2 then 'higher' else 'lower' end comparison
from
(select distinct e.department_id, left(pay_date,7) pay_month,
AVG(amount) over(partition by left(pay_date,7),e.department_id) avg1,
AVG(amount) over(partition by left(pay_date,7)) avg2
from salary s
inner join employee e 
on s.employee_id=e.employee_id) t
 
 
 
 
 
 
 SELECT DISTINCT pay_month, department_id, 
(CASE WHEN department_avg_salary > company_avg_salary THEN 'higher'
     WHEN department_avg_salary < company_avg_salary THEN 'lower'
     WHEN department_avg_salary = company_avg_salary THEN 'same' END) AS comparison
FROM (
SELECT A.employee_id, amount, pay_date,department_id, LEFT(pay_date,7) as pay_month, AVG(amount) OVER(PARTITION BY A.pay_date) AS company_avg_salary,
AVG(amount) OVER(PARTITION BY A.pay_date, B.department_id) AS department_avg_salary
FROM salary AS A
JOIN employee AS B
ON A.employee_id = B.employee_id) AS temp;
 
 
 
 
 
 
 
 select distinct date pay_month,department_id ,
 case when a>b then 'higher' when a=b then 'same' else 'lower' end as comparison
 from
 (select left(pay_date,7) date,amount,department_id
 ,avg(amount)over(partition by pay_date,department_id) a, 
  avg(amount)over(partition by pay_date) b
 from salary s
 join employee e
 on s.employee_id=e.employee_id)v
 
 
 
 
 
 
 
 
 SELECT d1.pay_month, d1.department_id, 
CASE WHEN d1.department_avg > c1.company_avg THEN 'higher'
     WHEN d1.department_avg < c1.company_avg THEN 'lower'
     ELSE 'same'
END AS 'comparison'
FROM ((SELECT LEFT(s1.pay_date, 7) pay_month, e1.department_id, AVG(s1.amount) department_avg
FROM salary s1
JOIN employee e1 ON s1.employee_id = e1.employee_id
GROUP BY pay_month, e1.department_id) d1
LEFT JOIN (SELECT LEFT(pay_date, 7) pay_month, AVG(amount) company_avg
FROM salary
GROUP BY pay_month) c1 ON d1.pay_month = c1.pay_month)
ORDER BY pay_month DESC, department_id;
 
 
 
 
 
 
 
 
 
 
 
 
 select distinct date pay_month,department_id ,
 case when a>b then 'higher' when a=b then 'same' else 'lower' end as comparison
 from
 (select left(pay_date,7) date,amount,department_id
 ,avg(amount)over(partition by pay_date,department_id) a, 
  avg(amount)over(partition by pay_date) b
 from salary s
 join employee e
 on s.employee_id=e.employee_id)v