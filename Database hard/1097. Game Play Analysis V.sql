/*
1097. Game Play Analysis V
Hard
SQL Schema
Table: Activity

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| player_id    | int     |
| device_id    | int     |
| event_date   | date    |
| games_played | int     |
+--------------+---------+
(player_id, event_date) is the primary key of this table.
This table shows the activity of players of some game.
Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out on some day using some device.
 

We define the install date of a player to be the first login day of that player.

We also define day 1 retention of some date X to be the number of players whose install date is X and they logged back in on the day right after X, divided by the number of players whose install date is X, rounded to 2 decimal places.

Write an SQL query that reports for each install date, the number of players that installed the game on that day and the day 1 retention.

The query result format is in the following example:

Activity table:
+-----------+-----------+------------+--------------+
| player_id | device_id | event_date | games_played |
+-----------+-----------+------------+--------------+
| 1         | 2         | 2016-03-01 | 5            |
| 1         | 2         | 2016-03-02 | 6            |
| 2         | 3         | 2017-06-25 | 1            |
| 3         | 1         | 2016-03-01 | 0            |
| 3         | 4         | 2016-07-03 | 5            |
+-----------+-----------+------------+--------------+

Result table:
+------------+----------+----------------+
| install_dt | installs | Day1_retention |
+------------+----------+----------------+
| 2016-03-01 | 2        | 0.50           |
| 2017-06-25 | 1        | 0.00           |
+------------+----------+----------------+
Player 1 and 3 installed the game on 2016-03-01 but only player 1 logged back in on 2016-03-02 so the day 1 retention of 2016-03-01 is 1 / 2 = 0.50
Player 2 installed the game on 2017-06-25 but didn't log back in on 2017-06-26 so the day 1 retention of 2017-06-25 is 0 / 1 = 0.00










# Write your MySQL query statement below
select a1.event_date as install_dt, count(distinct a1.player_id)as installs,
round(sum(case when a2.event_date is not null then 1 else 0 end)/count(distinct a1.player_id),2) as Day1_retention
from
(select player_id,min(event_date) as event_date
from Activity
group by player_id) a1 left join Activity a2 on a1.player_id=a2.player_id and a1.event_date=a2.event_date-1
group by install_dt



SELECT install_dt, COUNT(player_id) AS installs,
ROUND(COUNT(next_day) / COUNT(player_id), 2) AS Day1_retention
FROM (
    SELECT a1.player_id, a1.install_dt, a2.event_date AS next_day
    FROM
    (
        SELECT player_id, MIN(event_date) AS install_dt 
        FROM Activity
        GROUP BY player_id
    ) AS a1 
    LEFT JOIN Activity AS a2
    ON a1.player_id = a2.player_id
    AND a2.event_date = a1.install_dt + 1
) AS t
GROUP BY install_dt;




select a1.event_date as install_dt, count(distinct a1.player_id)as installs,round(sum(case when a2.event_date is not null then 1 else 0 end)/count(distinct a1.player_id),2) as Day1_retention
from
(select player_id,min(event_date) as event_date
from Activity
group by player_id) a1 left join Activity a2 on a1.player_id=a2.player_id and a1.event_date=a2.event_date-1
group by install_dt




select A.event_date as install_dt, count(A.player_id) as installs, round(count(B.player_id)/count(A.player_id),2) as Day1_retention
from (select player_id, min(event_date) AS event_date from Activity group by player_id) AS A
left join Activity B
ON A.player_id = B.player_id
and A.event_date + 1 = B.event_Date
group by A.event_date




/* Write your T-SQL query statement below */
WITH rank AS 
    (SELECT a.player_id,
            a.event_date,
            RANK() over (PARTITION BY player_id ORDER BY event_date ASC) AS rank_date,
            LEAD(a.event_date, 1) OVER(PARTITION BY a.player_id ORDER BY a.event_date ASC) AS next_date 
     from activity a)

SELECT r.event_date AS install_dt,
       COUNT(r.player_id) AS installs,
        ROUND(SUM(CASE 
                      WHEN r.next_date = DATEADD(day, 1, r.event_date) THEN 1 
                      ELSE 0 
                  END)*1.0/COUNT(r.player_id), 2) AS Day1_retention
FROM rank r
WHERE r.rank_date = 1
GROUP BY r.event_date




select i_date install_dt , max(i_count) installs, sum(ind_next_day)/max(i_count) Day1_retention
from
  (select *
  , min(event_date) over(partition by player_id) i_date
  ,count(player_id) over(partition by event_date) i_count
  ,case when lead(event_date) over(partition by player_id order by event_date )-1 = min(event_date) over(partition by player_id) then 1 else 0 end ind_next_day
from Activity) a
 group by i_date

 

