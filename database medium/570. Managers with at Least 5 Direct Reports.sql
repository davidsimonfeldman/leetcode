/*
570. Managers with at Least 5 Direct Reports
Medium
SQL Schema
The Employee table holds all employees including their managers. Every employee has an Id, and there is also a column for the manager Id.

+------+----------+-----------+----------+
|Id    |Name 	  |Department |ManagerId |
+------+----------+-----------+----------+
|101   |John 	  |A 	      |null      |
|102   |Dan 	  |A 	      |101       |
|103   |James 	  |A 	      |101       |
|104   |Amy 	  |A 	      |101       |
|105   |Anne 	  |A 	      |101       |
|106   |Ron 	  |B 	      |101       |
+------+----------+-----------+----------+
Given the Employee table, write a SQL query that finds out managers with at least 5 direct report. For the above table, your SQL query should return:

+-------+
| Name  |
+-------+
| John  |
+-------+
Note:
No one would report to himself.

SELECT e2.Name
FROM Employee e1 JOIN Employee e2
ON e1.managerId = e2.Id
GROUP BY e1.managerId
HAVING COUNT(e1.managerId)>=5


select  boss_name name from 
(
SELECT  dude.id dude_id 	    ,boss.Name boss_name     
	 FROM  Employee dude
    join  Employee boss
  on dude.ManagerId=boss.id
)  d
group by boss_name
having count( d.dude_id)>4