/*
1127. User Purchase Platform
HardTable: Spending

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| user_id     | int     |
| spend_date  | date    |
| platform    | enum    | 
| amount      | int     |
+-------------+---------+
The table logs the spendings history of users that make purchases from an online shopping website which has a desktop and a mobile application.
(user_id, spend_date, platform) is the primary key of this table.
The platform column is an ENUM type of ('desktop', 'mobile').
Write an SQL query to find the total number of users and the total amount spent using mobile only, desktop only and both mobile and desktop together for each date.

The query result format is in the following example:

Spending table:
+---------+------------+----------+--------+
| user_id | spend_date | platform | amount |
+---------+------------+----------+--------+
| 1       | 2019-07-01 | mobile   | 100    |
| 1       | 2019-07-01 | desktop  | 100    |
| 2       | 2019-07-01 | mobile   | 100    |
| 2       | 2019-07-02 | mobile   | 100    |
| 3       | 2019-07-01 | desktop  | 100    |
| 3       | 2019-07-02 | desktop  | 100    |
+---------+------------+----------+--------+

Result table:
+------------+----------+--------------+-------------+
| spend_date | platform | total_amount | total_users |
+------------+----------+--------------+-------------+
| 2019-07-01 | desktop  | 100          | 1           |
| 2019-07-01 | mobile   | 100          | 1           |
| 2019-07-01 | both     | 200          | 1           |
| 2019-07-02 | desktop  | 100          | 1           |
| 2019-07-02 | mobile   | 100          | 1           |
| 2019-07-02 | both     | 0            | 0           |
+------------+----------+--------------+-------------+ 
On 2019-07-01, user 1 purchased using both desktop and mobile, user 2 purchased using mobile only and user 3 purchased using desktop only.
On 2019-07-02, user 2 purchased using mobile only, user 3 purchased using desktop only and no one purchased using both platforms.



SELECT 
    p.spend_date,
    p.platform,
    IFNULL(SUM(amount), 0) total_amount,
    COUNT(user_id) total_users
FROM 
(
    SELECT DISTINCT(spend_date), 'desktop' platform FROM Spending
    UNION
    SELECT DISTINCT(spend_date), 'mobile' platform FROM Spending
    UNION
    SELECT DISTINCT(spend_date), 'both' platform FROM Spending
) p 
LEFT JOIN (
    SELECT
        spend_date,
        user_id,
        IF(mobile_amount > 0, IF(desktop_amount > 0, 'both', 'mobile'), 'desktop') platform,
        (mobile_amount + desktop_amount) amount
    FROM (
        SELECT
          spend_date,
          user_id,
          SUM(CASE platform WHEN 'mobile' THEN amount ELSE 0 END) mobile_amount,
          SUM(CASE platform WHEN 'desktop' THEN amount ELSE 0 END) desktop_amount
        FROM Spending
        GROUP BY spend_date, user_id
    ) o
) t
ON p.platform=t.platform AND p.spend_date=t.spend_date
GROUP BY spend_date, platform







# Write your MySQL query statement below

select c.spend_date, c.platform, sum(coalesce(amount,0)) total_amount, sum(case when amount is null then 0 else 1 end) total_users 
    from
    
    (select distinct spend_date, 'desktop' platform from spending 
    union all
    select distinct spend_date, 'mobile' platform from spending 
    union all
    select distinct spend_date, 'both' platform from spending) c
    
    left join
    
    (select user_id, spend_date, case when count(*)=1 then platform else 'both' end platform, sum(amount) amount 
        from spending group by user_id, spend_date) v
    
    on c.spend_date=v.spend_date and c.platform=v.platform
    group by spend_date, platform;
    
    
    
    
    
    
    WITH CTE AS (SELECT user_id, spend_date, 
    SUM(CASE platform WHEN 'mobile' THEN amount ELSE 0 END) ma,
    SUM(CASE platform WHEN 'desktop' THEN amount ELSE 0 END) da
FROM Spending
GROUP BY user_id, spend_date)
SELECT spend_date, 'desktop' platform, 
    SUM(CASE WHEN da > 0 AND ma = 0 THEN da ELSE 0 END) total_amount, 
    SUM(CASE WHEN da > 0 AND ma = 0 THEN 1 ELSE 0 END) total_users
FROM CTE
GROUP BY spend_date
UNION ALL
SELECT spend_date, 'mobile' platform, 
	 SUM(CASE WHEN ma > 0 AND da = 0 THEN ma ELSE 0 END) total_amount, 
	 SUM(CASE WHEN ma > 0 AND da = 0 THEN 1 ELSE 0 END) total_users
FROM CTE
GROUP BY spend_date
UNION ALL
SELECT spend_date, 'both' platform, 
    SUM(CASE WHEN da > 0 AND ma > 0 THEN ma + da ELSE 0 END) total_amount, 
    SUM(CASE WHEN da > 0 AND ma > 0 THEN 1 ELSE 0 END) total_users
FROM CTE
GROUP BY spend_date











