/*
618. Students Report By Geography
Hard
SQL Schema
A U.S graduate school has students from Asia, Europe and America. The students' location information are stored in table student as below.
 

| name   | continent |
|--------|-----------|
| Jack   | America   |
| Pascal | Europe    |
| Xi     | Asia      |
| Jane   | America   |
 

Pivot the continent column in this table so that each name is sorted alphabetically and displayed underneath its corresponding continent. The output headers should be America, Asia and Europe respectively. It is guaranteed that the student number from America is no less than either Asia or Europe.
 

For the sample input, the output is:
 

| America | Asia | Europe |
|---------|------|--------|
| Jack    | Xi   | Pascal |
| Jane    |      |        |
 

Follow-up: If it is unknown which continent has the most students, can you write a query to generate the student report?








SELECT America, Asia, Europe
FROM(
SELECT *,
ROW_NUMBER()OVER(PARTITION BY continent ORDER BY name) AS a
FROM student
) AS SOURCE
PIVOT
(MAX(name)FOR continent in (America, Asia, Europe)) AS PVT


SELECT
        MAX(CASE WHEN continent = 'America' THEN name END )AS America,
        MAX(CASE WHEN continent = 'Asia' THEN name END )AS Asia,
        MAX(CASE WHEN continent = 'Europe' THEN name END )AS Europe  
FROM (SELECT *, ROW_NUMBER()OVER(PARTITION BY continent ORDER BY name) AS row_id FROM student) AS t
GROUP BY row_id






with a as (SELECT *, ROW_NUMBER()OVER(PARTITION BY continent ORDER BY name) AS row_id FROM student
)
select 
max(case when continent ='America' then name end) America,
max(case when continent ='Asia' then name end) Asia,
max(case when continent ='Europe' then name end)Europe
from a
group by row_id








SELECT
        MAX(CASE WHEN continent = 'America' THEN name END )AS America,
        MAX(CASE WHEN continent = 'Asia' THEN name END )AS Asia,
        MAX(CASE WHEN continent = 'Europe' THEN name END )AS Europe  
FROM (SELECT *, ROW_NUMBER()OVER(PARTITION BY continent ORDER BY name) AS row_id FROM student) AS t
GROUP BY row_id







select min(America) as America, min(Asia) as Asia, min(Europe) as Europe from
    (select 
        row,
        case when continent = 'America' then name else null end as America,
        case when continent = 'Asia' then name else null end as Asia,
        case when continent = 'Europe' then name else null end as Europe
    from
        (select *,
        row_number() over(partition by continent order by name) as row
        from student) t1) t2
group by row;











/* Write your T-SQL query statement below */
SELECT America,Asia,Europe
from
(select *,row_number() over (partition by continent order by name) as rank from student) AS RESULT
pivot
( max(name) FOR  CONTINENT IN
 ([America],[Asia],[Europe])
) AS PIV 