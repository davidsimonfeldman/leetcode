/*
262. Trips and Users
Hard
SQL Schema
Table: Trips

+-------------+----------+
| Column Name | Type     |
+-------------+----------+
| Id          | int      |
| Client_Id   | int      |
| Driver_Id   | int      |
| City_Id     | int      |
| Status      | enum     |
| Request_at  | date     |     
+-------------+----------+
Id is the primary key for this table.
The table holds all taxi trips. Each trip has a unique Id, while Client_Id and Driver_Id are foreign keys to the Users_Id at the Users table.
Status is an ENUM type of (‘completed’, ‘cancelled_by_driver’, ‘cancelled_by_client’).
 

Table: Users

+-------------+----------+
| Column Name | Type     |
+-------------+----------+
| Users_Id    | int      |
| Banned      | enum     |
| Role        | enum     |
+-------------+----------+
Users_Id is the primary key for this table.
The table holds all users. Each user has a unique Users_Id, and Role is an ENUM type of (‘client’, ‘driver’, ‘partner’).
Status is an ENUM type of (‘Yes’, ‘No’).
 

Write a SQL query to find the cancellation rate of requests with unbanned users (both client and driver must not be banned) each day between "2013-10-01" and "2013-10-03".

The cancellation rate is computed by dividing the number of canceled (by client or driver) requests with unbanned users by the total number of requests with unbanned users on that day.

Return the result table in any order. Round Cancellation Rate to two decimal points.

The query result format is in the following example:

 

Trips table:
+----+-----------+-----------+---------+---------------------+------------+
| Id | Client_Id | Driver_Id | City_Id | Status              | Request_at |
+----+-----------+-----------+---------+---------------------+------------+
| 1  | 1         | 10        | 1       | completed           | 2013-10-01 |
| 2  | 2         | 11        | 1       | cancelled_by_driver | 2013-10-01 |
| 3  | 3         | 12        | 6       | completed           | 2013-10-01 |
| 4  | 4         | 13        | 6       | cancelled_by_client | 2013-10-01 |
| 5  | 1         | 10        | 1       | completed           | 2013-10-02 |
| 6  | 2         | 11        | 6       | completed           | 2013-10-02 |
| 7  | 3         | 12        | 6       | completed           | 2013-10-02 |
| 8  | 2         | 12        | 12      | completed           | 2013-10-03 |
| 9  | 3         | 10        | 12      | completed           | 2013-10-03 |
| 10 | 4         | 13        | 12      | cancelled_by_driver | 2013-10-03 |
+----+-----------+-----------+---------+---------------------+------------+

Users table:
+----------+--------+--------+
| Users_Id | Banned | Role   |
+----------+--------+--------+
| 1        | No     | client |
| 2        | Yes    | client |
| 3        | No     | client |
| 4        | No     | client |
| 10       | No     | driver |
| 11       | No     | driver |
| 12       | No     | driver |
| 13       | No     | driver |
+----------+--------+--------+

Result table:
+------------+-------------------+
| Day        | Cancellation Rate |
+------------+-------------------+
| 2013-10-01 | 0.33              |
| 2013-10-02 | 0.00              |
| 2013-10-03 | 0.50              |
+------------+-------------------+

On 2013-10-01:
  - There were 4 requests in total, 2 of which were canceled.
  - However, the request with Id=2 was made by a banned client (User_Id=2), so it is ignored in the calculation.
  - Hence there are 3 unbanned requests in total, 1 of which was canceled.
  - The Cancellation Rate is (1 / 3) = 0.33
On 2013-10-02:
  - There were 3 requests in total, 0 of which were canceled.
  - The request with Id=6 was made by a banned client, so it is ignored.
  - Hence there are 2 unbanned requests in total, 0 of which were canceled.
  - The Cancellation Rate is (0 / 2) = 0.00
On 2013-10-03:
  - There were 3 requests in total, 1 of which was canceled.
  - The request with Id=8 was made by a banned client, so it is ignored.
  - Hence there are 2 unbanned request in total, 1 of which were canceled.
  - The Cancellation Rate is (1 / 2) = 0.50





-- Updated query when both 'Client' and 'Driver' should be unbanned

SELECT  t.request_at AS "Day",
        ROUND(
            COUNT(CASE
                    WHEN t.status != 'completed' THEN 1     -- numerator is total cancelled trips
                    ELSE NULL
                 END) / COUNT(id)                           -- denominator is all trips for that day
        , 2) AS "Cancellation Rate"
FROM    trips AS t
JOIN    users AS client                                     -- users table role-playing as client
ON      t.client_id = client.users_id
AND     client.banned = 'No'                                -- unbanned client
JOIN    users AS driver                                     -- users table role-playing as driver
ON      driver.users_id = t.driver_id
AND     driver.banned = 'No'                                -- unbanned driver
AND     t.request_at BETWEEN '2013-10-01' 
                         AND '2013-10-03'
GROUP BY t.request_at;                                      -- per date calculation
solution for the old question
The where condition checks for two things.

The current client is not 'Banned'
Date is between the range
The second cluase (column) of SELECT statement is tricky. Let's understand what each function is used for

LOWER(column) to change the values to lowercase. This is because MySQL doesn't have ILIKE function to have case-insensitive comparision
LIKE for partial text matches
CASE for counting only cancelled rides instead of all non-null values
1.000 to account for decimals after divisions
COUNT(id) to get total trips for that day
ROUND(value, 2) to round off the result to 2 decimal places Do not confuse with TRUNCATE function
Rename the processed column to the expected one
SELECT      request_at AS "Day", 
            ROUND(((SUM(CASE WHEN LOWER(Status) LIKE "cancelled%" THEN 1.000 ELSE 0 END)) / COUNT(id)), 2) AS "Cancellation Rate" 
FROM        trips
WHERE       client_id NOT IN (SELECT users_id FROM users WHERE banned = 'Yes')
AND         request_at BETWEEN '2013-10-01' AND '2013-10-03'
GROUP BY    request_at;
This solution is faster than the above one
We are joining and hence each record doesn't need to run an inner query to check for the banned status. If it did, it takes a lot of time repeating the same task over and over.

SELECT      request_at AS "Day", 
            ROUND(((SUM(CASE WHEN LOWER(Status) LIKE "cancelled%" THEN 1.000 ELSE 0 END)) / COUNT(id)), 2) AS "Cancellation Rate" 
FROM        trips AS t
JOIN        users AS u
ON          t.client_id = u.users_id
AND         u.banned ='No'
WHERE       request_at BETWEEN '2013-10-01' AND '2013-10-03'
GROUP BY    request_at;






select  Request_at day , round(s/f,2) as 'Cancellation Rate' from 
(SELECT   Status,Request_at, 
 count(Request_at)f,
sum(case when Status like '%cancelled_by%' then 1 else 0 end )s
from Trips t
join Users u on t.Client_Id=u.Users_Id
where Banned='No'
 and   Request_at between '2013-10-01' and '2013-10-03'
group by 2
order by 2
)a





SELECT Request_at as Day, ROUND(SUM(t.Status != "completed") / COUNT(*), 2) as "Cancellation Rate"
    FROM Trips t 
    JOIN Users c ON t.Client_ID = c.Users_ID AND c.Banned = "No"
    JOIN Users d ON t.Driver_ID = d.Users_ID AND d.Banned = "No"
    WHERE Request_at BETWEEN "2013-10-01" AND "2013-10-03"
    GROUP BY Request_at;



SELECT Request_at as Day,
       ROUND(COUNT(IF(Status != 'completed', TRUE, NULL)) / COUNT(*), 2) AS 'Cancellation Rate'
FROM Trips
WHERE (Request_at BETWEEN '2013-10-01' AND '2013-10-03')
      AND Client_id NOT IN (SELECT Users_Id FROM Users WHERE Banned = 'Yes')
GROUP BY Request_at;