/*
1811. Find Interview Candidates
Medium
 
SQL Schema
Table: Contests

+--------------+------+
| Column Name  | Type |
+--------------+------+
| contest_id   | int  |
| gold_medal   | int  |
| silver_medal | int  |
| bronze_medal | int  |
+--------------+------+
contest_id is the primary key for this table.
This table contains the LeetCode contest ID and the user IDs of the gold, silver, and bronze medalists.
It is guaranteed that any consecutive contests have consecutive IDs and that no ID is skipped.
 

Table: Users

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| user_id     | int     |
| mail        | varchar |
| name        | varchar |
+-------------+---------+
user_id is the primary key for this table.
This table contains information about the users.
 

Write an SQL query to report the name and the mail of all interview candidates. A user is an interview candidate if at least one of these two conditions is true:

The user won any medal in three or more consecutive contests.
The user won the gold medal in three or more different contests (not necessarily consecutive).
Return the result table in any order.

The query result format is in the following example:

 

Contests table:
+------------+------------+--------------+--------------+
| contest_id | gold_medal | silver_medal | bronze_medal |
+------------+------------+--------------+--------------+
| 190        | 1          | 5            | 2            |
| 191        | 2          | 3            | 5            |
| 192        | 5          | 2            | 3            |
| 193        | 1          | 3            | 5            |
| 194        | 4          | 5            | 2            |
| 195        | 4          | 2            | 1            |
| 196        | 1          | 5            | 2            |
+------------+------------+--------------+--------------+

Users table:
+---------+--------------------+-------+
| user_id | mail               | name  |
+---------+--------------------+-------+
| 1       | sarah@leetcode.com | Sarah |
| 2       | bob@leetcode.com   | Bob   |
| 3       | alice@leetcode.com | Alice |
| 4       | hercy@leetcode.com | Hercy |
| 5       | quarz@leetcode.com | Quarz |
+---------+--------------------+-------+

Result table:
+-------+--------------------+
| name  | mail               |
+-------+--------------------+
| Sarah | sarah@leetcode.com |
| Bob   | bob@leetcode.com   |
| Alice | alice@leetcode.com |
| Quarz | quarz@leetcode.com |
+-------+--------------------+

Sarah won 3 gold medals (190, 193, and 196), so we include her in the result table.
Bob won a medal in 3 consecutive contests (190, 191, and 192), so we include him in the result table.
    - Note that he also won a medal in 3 other consecutive contests (194, 195, and 196).
Alice won a medal in 3 consecutive contests (191, 192, and 193), so we include her in the result table.
Quarz won a medal in 5 consecutive contests (190, 191, 192, 193, and 194), so we include them in the result table.
 

Follow up:

What if the first condition changed to be "any medal in n or more consecutive contests"? How would you change your solution to get the interview candidates? Imagine that n is the parameter of a stored procedure.
Some users may not participate in every contest but still perform well in the ones they do. How would you change your solution to only consider contests where the user was a participant? Suppose the registered users for each contest are given in another table.

with medals as (
    select gold_medal   as user_id, 'gold'   as medal, contest_id from contests
    union all
    select silver_medal as user_id, 'silver' as medal, contest_id from contests
    union all
    select bronze_medal as user_id, 'bronze' as medal, contest_id from contests
), 
lagged_and_counted as (
    select 
        user_id, medal, contest_id,
        lag(contest_id, 2) over (partition by user_id order by contest_id) as lag_2,
        count(1) over (partition by user_id, medal) as medal_count
    from medals
)
select distinct name, mail
from lagged_and_counted
natural join Users
where 
    contest_id = lag_2 + 2 
    or  
    (medal = 'gold' and medal_count >= 3)
    
    
    
    
    
    
    
    
    
    
    # In table 1, we can easily use group by to find out who won gold medals at least 3 times. 
with t1 as (select gold_medal
       from contests
       group by gold_medal
       having count(contest_id) >= 3),
 
 # In table 2, we can use union all to create 2 columns, contestID (contain duplicate) and userID (anyone who won a medal in a given contest)
 # In this table, selecting one contest_id will point to 3 different user_ids. 
 # For example, contest_id = 190 will give you (190, 1), (190, 5), (190, 2). Contest_id = 191 will give you (191, 2), (191, 3), (191, 5).
 
 t2 as (select contest_id, gold_medal as user_id
       from contests
       union all
       select contest_id, silver_medal
       from contests
       union all
       select contest_id, bronze_medal
       from contests),

# Now we can use pairs of contest_id and user_id to look for players who won consecutive games.
# For example, these three pairs represent the medalists in contest 190 ----> (190, 1), (190, 5), (190, 2)
# Now we add 1 to the contest_id, the pairs become (191, 1), (191, 5), (191, 2)
# Only (191, 5), (191, 2) exist in t2, thus user 5, 2 won contest 190 and 191 consecutively. (191, 1) does't exist in t2, so user 1 did not win consecutively.
# We can use this method to find who won 3 or more games. Just use +- 1 and +-2 on the contest_id to create more pairs, and look for such pairs in t2

t3 as (select contest_id, user_id
       from t2
       where ((contest_id+1, user_id) in (select contest_id, user_id from t2) 
       and (contest_id+2, user_id) in (select contest_id, user_id from t2))
        or 
        ((contest_id-1, user_id) in (select contest_id, user_id from t2) 
       and (contest_id-2, user_id) in (select contest_id, user_id from t2)))
        
		# Find the name and mail for the user_id who is either in table 1 or table 3
        select name, mail
        from users
        where user_id in (select gold_medal from t1)
        or user_id in (select user_id from t3);
        
        
        
        
        
        
        
        First melt contest into long format, then rank the medal by contest_id within each user group.
Here the consecutive medal won means the difference between rank and contest_id are the same.
Next, filter the result by selecting those who has # within difference group >= N?and combine them with gold medal winners.
Finally join user table and keep the distinct results.

with t0 as (
    select gold_medal as user, contest_id 
    from contests 
    union all 
    select silver_medal as user, contest_id 
    from contests 
    union all 
    select bronze_medal as user, contest_id 
    from contests 
)
, t1 as (
    select user, contest_id, row_number() over(partition by user order by contest_id) as rn 
    from t0 
)
, t2 as (
    select user as user_id -- consecutive medal winners
    from t1 
    group by user, contest_id - rn 
    having count(*) >= 3 -- replace 3 with any number to solve the N problem
    union all
    select gold_medal as user_id  -- gold medal winners
    from contests 
    group by gold_medal 
    having count(*) >= 3
)
select distinct u.name, u.mail 
from t2 
inner join users u
on t2.user_id = u.user_id