/*
1264. Page Recommendations
Medium
SQL Schema
Table: Friendship

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| user1_id      | int     |
| user2_id      | int     |
+---------------+---------+
(user1_id, user2_id) is the primary key for this table.
Each row of this table indicates that there is a friendship relation between user1_id and user2_id.
 

Table: Likes

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| user_id     | int     |
| page_id     | int     |
+-------------+---------+
(user_id, page_id) is the primary key for this table.
Each row of this table indicates that user_id likes page_id.
 

Write an SQL query to recommend pages to the user with user_id = 1 using the pages that your friends liked. It should not recommend pages you already liked.

Return result table in any order without duplicates.

The query result format is in the following example:

Friendship table:
+----------+----------+
| user1_id | user2_id |
+----------+----------+
| 1        | 2        |
| 1        | 3        |
| 1        | 4        |
| 2        | 3        |
| 2        | 4        |
| 2        | 5        |
| 6        | 1        |
+----------+----------+
 
Likes table:
+---------+---------+
| user_id | page_id |
+---------+---------+
| 1       | 88      |
| 2       | 23      |
| 3       | 24      |
| 4       | 56      |
| 5       | 11      |
| 6       | 33      |
| 2       | 77      |
| 3       | 77      |
| 6       | 88      |
+---------+---------+

Result table:
+------------------+
| recommended_page |
+------------------+
| 23               |
| 24               |
| 56               |
| 33               |
| 77               |
+------------------+
User one is friend with users 2, 3, 4 and 6.
Suggested pages are 23 from user 2, 24 from user 3, 56 from user 3 and 33 from user 6.
Page 77 is suggested from both user 2 and user 3.
Page 88 is not suggested because user 1 already likes it.










# Write your MySQL query statement below
with a as 
(
select user1_id user,user2_id friend  from Friendship
where  user1_id=1  
union all

select  user2_id ,user1_id friend   from Friendship
where    user2_id=1)

select  distinct page_id recommended_page from
a join Likes l
on a.friend=l.user_id
where  page_id not in (select  page_id from Likes where user_id=1)



select distinct page_id as recommended_page
from
(select
case
when user1_id=1 then user2_id
when user2_id=1 then user1_id
end as user_id
from Friendship) a
join Likes
on a.user_id=Likes.user_id
where page_id not in (select page_id from Likes where user_id=1)




SELECT DISTINCT page_id AS recommended_page
FROM Likes
WHERE user_id IN (
    SELECT user2_id AS friend_id FROM Friendship WHERE user1_id = 1
    UNION
    SELECT user1_id AS friend_id FROM Friendship WHERE user2_id = 1) AND
    page_id NOT IN (
      SELECT page_id FROM Likes WHERE user_id = 1
    )
    
    
    
    
    
    
    
    SELECT DISTINCT page_id AS recommended_page 
	FROM Likes
	WHERE user_id IN 
	      				(SELECT CASE WHEN user1_id=1 THEN user2_id WHEN user2_id=1 THEN user1_id ELSE '' END
		  				FROM Friendship 
						WHERE user1_id=1 or user2_id=1)
	AND page_id NOT IN 
					(SELECT DISTINCT page_id FROM Likes WHERE user_id=1);