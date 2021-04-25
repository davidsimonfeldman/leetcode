/*
1194. Tournament Winners
Hard
SQL Schema
Table: Players

+-------------+-------+
| Column Name | Type  |
+-------------+-------+
| player_id   | int   |
| group_id    | int   |
+-------------+-------+
player_id is the primary key of this table.
Each row of this table indicates the group of each player.
Table: Matches

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| match_id      | int     |
| first_player  | int     |
| second_player | int     | 
| first_score   | int     |
| second_score  | int     |
+---------------+---------+
match_id is the primary key of this table.
Each row is a record of a match, first_player and second_player contain the player_id of each match.
first_score and second_score contain the number of points of the first_player and second_player respectively.
You may assume that, in each match, players belongs to the same group.
 

The winner in each group is the player who scored the maximum total points within the group. In the case of a tie, the lowest player_id wins.

Write an SQL query to find the winner in each group.

The query result format is in the following example:

Players table:
+-----------+------------+
| player_id | group_id   |
+-----------+------------+
| 15        | 1          |
| 25        | 1          |
| 30        | 1          |
| 45        | 1          |
| 10        | 2          |
| 35        | 2          |
| 50        | 2          |
| 20        | 3          |
| 40        | 3          |
+-----------+------------+

Matches table:
+------------+--------------+---------------+-------------+--------------+
| match_id   | first_player | second_player | first_score | second_score |
+------------+--------------+---------------+-------------+--------------+
| 1          | 15           | 45            | 3           | 0            |
| 2          | 30           | 25            | 1           | 2            |
| 3          | 30           | 15            | 2           | 0            |
| 4          | 40           | 20            | 5           | 2            |
| 5          | 35           | 50            | 1           | 1            |
+------------+--------------+---------------+-------------+--------------+

Result table:
+-----------+------------+
| group_id  | player_id  |
+-----------+------------+ 
| 1         | 15         |
| 2         | 35         |
| 3         | 40         |

















WITH CTE AS
(SELECT first_player player_id, first_score score
FROM matches
UNION ALL
SELECT second_player player_id, second_score score
FROM matches),
CTE_1 AS (SELECT player_id, SUM(score) score
FROM CTE
GROUP BY player_id)

SELECT DISTINCT group_id, FIRST_VALUE(c.player_id) OVER(partition by group_id ORDER BY score DESC, c.player_id) player_id
from cte_1 c LEFT JOIN players p ON c.player_id = p.player_id






with t as(
select p.player_id, p.group_id,
sum(
case when p.player_id = m.first_player then first_score else second_score end
) as player_score
from Players p
join Matches m on p.player_id = m.first_player or p.player_id = m.second_player
group by p.player_id, p.group_id),
t2 as(
select group_id, player_id,
row_number() over (partition by group_id order by player_id) as row_num
from t
where (group_id, player_score) in (select group_id, max(player_score) from t group by group_id))
select group_id, player_id
from t2
where row_num = 1



 /* Write your T-SQL query statement below */
select group_id, player_id from 
(
    select p.player_id, p.group_id, 
    row_number() over(partition by p.group_id order by player_total.score desc, p.player_id asc) rank
    from players p join
        (
            select player_id, sum(player_score.score) as score
            from (
                    (select first_player as player_id, first_score as score from Matches)
                        union all
                    (select second_player as player_id, second_score as score from Matches)
                 ) player_score 
            group by player_id
        ) player_total
    on p.player_id = player_total.player_id
) rank_table 
where rank_table.rank = 1



