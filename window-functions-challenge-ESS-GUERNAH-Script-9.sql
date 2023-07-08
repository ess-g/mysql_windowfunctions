-----------------------Challenge Sample Scenario-------------------------

------------------Part 1: Row Number, Rank and Dense Rank----------------

--1.Create a joined table [PULL IN ALL DATA FROM BOTH TABLES]from the Artist [AR]and Album [AL]tables and order it by Name and Title [ORDER BY]

SELECT *
from Artist ar 
join Album al ON ar.ArtistId = al.ArtistId 
ORDER BY Name, title;

--2.Using the table created above, make a table that contains Name, Title and a distinct TableID number for every record in the table

WITH cte AS 
(
SELECT *
from Artist ar 
join Album al ON ar.ArtistId = al.ArtistId 
ORDER BY Name, title
)
SELECT 
    ROW_NUMBER() OVER() AS distinct_table_id, name, title
from cte;

--3.Add a column called album rank that ranks each album, windowed by Name creating an album rank for each band

WITH cte AS 
(
SELECT *
from Artist ar 
join Album al ON ar.ArtistId = al.ArtistId 
ORDER BY Name, title
)
SELECT 
    ROW_NUMBER() OVER() AS distinct_table_id, name, title,
        DENSE_RANK() OVER(PARTITION BY name ORDER BY title) AS album_ranking 
from cte;

------------------Part 2: LAG----------------

--1. Create a table that contains the TrackID, Name, AlbumId and Milliseconds from AlbumId = 13 ordered by TrackID
select * from track --for reference--
select * from album --for reference--
----

SELECT t.TrackId, t.Name, t.AlbumId, t.Milliseconds 
from Track t 
join Album al ON t.AlbumId = al.AlbumId 
WHERE t.AlbumId = 13
ORDER BY TrackId;

--2. Create a column of Milliseconds lagged by 1 row

SELECT t.TrackId, t.Name, t.AlbumId, t.Milliseconds,
    LAG(Milliseconds,1) OVER() AS LagMilliseconds
from Track t 
join Album al ON t.AlbumId = al.AlbumId 
WHERE t.AlbumId = 13
ORDER BY TrackId;

--3. Create a table that subtracts Milliseconds from LagMilliseconds from the table above to compare the length of consecutive songs on the album

WITH cte2 AS 
(
SELECT t.TrackId, t.Name, t.AlbumId, t.Milliseconds,
    LAG(Milliseconds,1) OVER() AS LagMilliseconds
from Track t 
join Album al ON t.AlbumId = al.AlbumId 
WHERE t.AlbumId = 13
ORDER BY TrackId
)
SELECT *,LagMilliseconds-Milliseconds AS diffofMilliseconds
FROM cte2;

--~THE END~--





