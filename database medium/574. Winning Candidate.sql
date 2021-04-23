/*
574. Winning Candidate
Medium
SQL Schema
Table: Candidate

+-----+---------+
| id  | Name    |
+-----+---------+
| 1   | A       |
| 2   | B       |
| 3   | C       |
| 4   | D       |
| 5   | E       |
+-----+---------+  
Table: Vote

+-----+--------------+
| id  | CandidateId  |
+-----+--------------+
| 1   |     2        |
| 2   |     4        |
| 3   |     3        |
| 4   |     2        |
| 5   |     5        |
+-----+--------------+
id is the auto-increment primary key,
CandidateId is the id appeared in Candidate table.
Write a sql to find the name of the winning candidate, the above example will return the winner B.

+------+
| Name |
+------+
| B    |
+------+
Notes:

You may assume there is no tie, in other words there will be only one winning candidate.



select top 1 Name from Candidate c join Vote v on c.id=v.CandidateId
group by Name
order by count(CandidateId) desc



Select distinct c.Name As Name
from Candidate c
where c.id = (Select CandidateId 
from Vote
Group by CandidateId  
order by count(CandidateId) desc
limit 1)



select C.Name from
Candidate C
JOIN(
select CandidateId, dense_rank() OVER (ORDER BY count(CandidateId) desc) as rnk from Vote
GROUP BY CandidateId)Voting
ON C.id = Voting.CandidateId
WHERE Voting.rnk=1



select C.Name from
Candidate C
JOIN(
select CandidateId, dense_rank() OVER (ORDER BY count(CandidateId) desc) as rnk from Vote
GROUP BY CandidateId)Voting
ON C.id = Voting.CandidateId
limit 1