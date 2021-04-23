/*  
1341. Movie Rating
Medium
SQL Schema
Table: Movies

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| movie_id      | int     |
| title         | varchar |
+---------------+---------+
movie_id is the primary key for this table.
title is the name of the movie.
Table: Users

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| user_id       | int     |
| name          | varchar |
+---------------+---------+
user_id is the primary key for this table.
Table: Movie_Rating

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| movie_id      | int     |
| user_id       | int     |
| rating        | int     |
| created_at    | date    |
+---------------+---------+
(movie_id, user_id) is the primary key for this table.
This table contains the rating of a movie by a user in their review.
created_at is the user's review date. 
 

Write the following SQL query:

Find the name of the user who has rated the greatest number of movies.
In case of a tie, return lexicographically smaller user name.

Find the movie name with the highest average rating in February 2020.
In case of a tie, return lexicographically smaller movie name.

The query is returned in 2 rows, the query result format is in the following example:

Movies table:
+-------------+--------------+
| movie_id    |  title       |
+-------------+--------------+
| 1           | Avengers     |
| 2           | Frozen 2     |
| 3           | Joker        |
+-------------+--------------+

Users table:
+-------------+--------------+
| user_id     |  name        |
+-------------+--------------+
| 1           | Daniel       |
| 2           | Monica       |
| 3           | Maria        |
| 4           | James        |
+-------------+--------------+

Movie_Rating table:
+-------------+--------------+--------------+-------------+
| movie_id    | user_id      | rating       | created_at  |
+-------------+--------------+--------------+-------------+
| 1           | 1            | 3            | 2020-01-12  |
| 1           | 2            | 4            | 2020-02-11  |
| 1           | 3            | 2            | 2020-02-12  |
| 1           | 4            | 1            | 2020-01-01  |
| 2           | 1            | 5            | 2020-02-17  | 
| 2           | 2            | 2            | 2020-02-01  | 
| 2           | 3            | 2            | 2020-03-01  |
| 3           | 1            | 3            | 2020-02-22  | 
| 3           | 2            | 4            | 2020-02-25  | 
+-------------+--------------+--------------+-------------+

Result table:
+--------------+
| results      |
+--------------+
| Daniel       |
| Frozen 2     |
+--------------+

Daniel and Monica have rated 3 movies ("Avengers", "Frozen 2" and "Joker") but Daniel is smaller lexicographically.
Frozen 2 and Joker have a rating average of 3.5 in February but Frozen 2 is smaller lexicographically.


# Write your MySQL query statement below
SELECT user_name as results FROM
(
    SELECT b.name as user_name,COUNT(*) as counts FROM Movie_rating as a
    JOIN Users as b
    ON a.user_id=b.user_id
    GROUP BY a.user_id
    ORDER BY counts DESC,user_name ASC LIMIT 1
) first_query #query for the person who rates the greatest number of movies
UNION
SELECT movie_name as results FROM
(
    SELECT d.title as movie_name,AVG(c.rating) as grade FROM Movie_rating as c
    JOIN Movies as d
    ON c.movie_id=d.movie_id
    WHERE SUBSTR(c.created_at,1,7)="2020-02"
    GROUP BY c.movie_id
    ORDER BY grade DESC,movie_name ASC LIMIT 1
) second_query; #query for the movie with the highest average rating in February




(
  SELECT u.name AS results
  FROM Movie_Rating r LEFT JOIN Users u
  ON (r.user_id = u.user_id)
  GROUP BY r.user_id
  ORDER BY COUNT(r.movie_id) DESC, u.name 
  LIMIT 1
)
UNION
(
  SELECT m.title AS results
  FROM Movie_Rating r LEFT JOIN Movies m
  ON (r.movie_id = m.movie_id)
  WHERE r.created_at LIKE '2020-02%'
  GROUP BY r.movie_id
  ORDER BY AVG(r.rating) DESC, m.title 
  LIMIT 1
)








(SELECT name results
FROM users u
JOIN movie_rating mr
ON u.user_id = mr.user_id
GROUP BY 1
ORDER BY count(rating) desc, 1 asc
Limit 1)

UNION

(SELECT title results
FROM movies m
JOIN movie_rating mr
ON m.movie_id = mr.movie_id
WHERE month(created_at) = 2
GROUP BY 1
ORDER BY avg(rating) desc, 1 asc
Limit 1)