/*
1454. Active Users
Medium
SQL Schema
Table Accounts:

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| name          | varchar |
+---------------+---------+
the id is the primary key for this table.
This table contains the account id and the user name of each account.
 

Table Logins:

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| login_date    | date    |
+---------------+---------+
There is no primary key for this table, it may contain duplicates.
This table contains the account id of the user who logged in and the login date. A user may log in multiple times in the day.
 

Write an SQL query to find the id and the name of active users.

Active users are those who logged in to their accounts for 5 or more consecutive days.

Return the result table ordered by the id.

The query result format is in the following example:

Accounts table:
+----+----------+
| id | name     |
+----+----------+
| 1  | Winston  |
| 7  | Jonathan |
+----+----------+

Logins table:
+----+------------+
| id | login_date |
+----+------------+
| 7  | 2020-05-30 |
| 1  | 2020-05-30 |
| 7  | 2020-05-31 |
| 7  | 2020-06-01 |
| 7  | 2020-06-02 |
| 7  | 2020-06-02 |
| 7  | 2020-06-03 |
| 1  | 2020-06-07 |
| 7  | 2020-06-10 |
+----+------------+

Result table:
+----+----------+
| id | name     |
+----+----------+
| 7  | Jonathan |
+----+----------+
User Winston with id = 1 logged in 2 times only in 2 different days, so, Winston is not an active user.
User Jonathan with id = 7 logged in 7 times in 6 different days, five of them were consecutive days, so, Jonathan is an active user.
Follow up question:
Can you write a general solution if the active users are those who logged in to their accounts for n or more consecutive days?




SELECT DISTINCT a.id, (SELECT name FROM Accounts WHERE id=a.id) name
FROM Logins a, Logins b
WHERE a.id=b.id AND
DATEDIFF(a.login_date,b.login_date) BETWEEN 1 AND 4
GROUP BY a.id, a.login_date
HAVING COUNT(DISTINCT b.login_date)=4
;





Related Questions:
1321. Restaurant Growth
601. Human Traffic of Stadium

Choice 1(I like this one):

SELECT DISTINCT l1.id,
(SELECT name FROM Accounts WHERE id = l1.id) AS name
FROM Logins l1
JOIN Logins l2 ON l1.id = l2.id AND DATEDIFF(l2.login_date, l1.login_date) BETWEEN 1 AND 4
GROUP BY l1.id, l1.login_date
HAVING COUNT(DISTINCT l2.login_date) = 4
Choice 2:

SELECT *
FROM Accounts
WHERE id IN
    (SELECT DISTINCT t1.id 
     FROM Logins t1 INNER JOIN Logins t2 on t1.id = t2.id AND DATEDIFF(t1.login_date, t2.login_date) BETWEEN 1 AND 4
     GROUP BY t1.id, t1.login_date
     HAVING COUNT(DISTINCT(t2.login_date)) = 4)
ORDER BY id
Choice 3:

WITH temp AS (SELECT l1.id, l1.login_date, COUNT(DISTINCT l2.login_date) AS cnt
FROM Logins l1
LEFT JOIN Logins l2 ON l1.id = l2.id AND DATEDIFF(l2.login_date, l1.login_date) BETWEEN 1 AND 4
GROUP BY 1,2
HAVING cnt>=4)

SELECT DISTINCT temp.id, name
FROM temp
JOIN Accounts ON temp.id = Accounts.id
ORDER BY 1;
Recursive CTE solution to solve the follow up question(just for test):

WITH RECURSIVE
rec_t AS
(SELECT id, login_date, 1 AS days FROM Logins 
 UNION ALL
 SELECT l.id, l.login_date, rec_t.days+1 FROM rec_t
 INNER JOIN Logins l 
 ON rec_t.id = l.id AND DATE_ADD(rec_t.login_date, INTERVAL 1 DAY) = l.login_date
)

SELECT * FROM Accounts
WHERE id IN
(SELECT DISTINCT id FROM rec_t WHERE days = 5)
ORDER BY id





SELECT DISTINCT a.id, (SELECT name FROM Accounts WHERE id=a.id) name
FROM Logins a, Logins b
WHERE a.id=b.id AND
DATEDIFF(a.login_date,b.login_date) BETWEEN 1 AND 4
GROUP BY a.id, a.login_date
HAVING COUNT(DISTINCT b.login_date)=4
;





