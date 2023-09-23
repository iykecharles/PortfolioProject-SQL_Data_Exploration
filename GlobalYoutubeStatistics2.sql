--loading the 2 tables to ensure that everything works as expected.
SELECT * FROM dbo.['Global YouTube Statistics']
SELECT * FROM dbo.['Global YouTube Statistics CountryData']

--let us check for duplicate youtube accounts. By the way, Youtube allows just unique names so if we have 2 youtube names then 
--data must have been duplicated.
SELECT Youtuber, COUNT(*) FROM dbo.['Global YouTube Statistics']
group by Youtuber
having COUNT(*) > 1

----renaming column "video views" as video_views
--ALTER TABLE dbo.['Global YouTube Statistics']
--RENAME COLUMN video views TO video_views

--BASIC QUERIES

--A list of the Youtube names and their subcribers
SELECT Youtuber, subscribers FROM dbo.['Global YouTube Statistics']

--top 10 youtube channels by subscribers
--SELECT Youtuber, subscribers FROM dbo.['Global YouTube Statistics']
--order by subscribers desc
--OFFSET 0 ROWS FETCH FIVE NEXT ROWS ONLY;

--total subscribers of the Youtubers in the dataset
SELECT SUM(subscribers) AS TOTAL_subscribers FROM dbo.['Global YouTube Statistics']

--Getting Youtube Channels with Over 100 Million Subscribers
SELECT Youtuber, subscribers FROM dbo.['Global YouTube Statistics']
WHERE subscribers > 100000000
order by subscribers desc

--let us see the COUNTRY with the highest subscribers
SELECT COUNTRY, SUM(subscribers) AS COUNTRY_TOTAL FROM dbo.['Global YouTube Statistics']
GROUP BY COUNTRY
ORDER BY COUNTRY_TOTAL DESC

--let us see the group with the highest subscribers
SELECT CATEGORY, SUM(subscribers) AS CATEGORY_SUM FROM dbo.['Global YouTube Statistics']
GROUP BY CATEGORY
ORDER BY CATEGORY_SUM DESC

--A Youtuber with highest yearly earnings.
SELECT Youtuber, COUNTRY, MAX(highest_yearly_earnings) AS highest_yearly_earnings FROM dbo.['Global YouTube Statistics']
GROUP BY Youtuber, COUNTRY
ORDER BY highest_yearly_earnings DESC

--SELECT Youtuber, Country, highest_yearly_earnings
--FROM dbo.['Global YouTube Statistics'] AS yt
--WHERE highest_yearly_earnings = (
--    SELECT MAX(highest_yearly_earnings)
--    FROM dbo.['Global YouTube Statistics']
--    WHERE Youtuber = yt.Youtuber
--)
--ORDER BY highest_yearly_earnings DESC;


--sieving out the channels (with their respctive views) created in pandemic period of 2020 and 2021
SELECT Youtuber, [video views] FROM DBO.['Global YouTube Statistics']
WHERE created_year >= 2020 AND created_year <= 2021
ORDER BY [video views] DESC

--SELECT Youtuber, [video views] FROM DBO.['Global YouTube Statistics']
--WHERE youtuber = 'LeoNata Family'

--Mid-Level Queries

-- calculating the average views per subscriber for each Youtuber 
SELECT Youtuber, AVG(NULLIF([video views], 0) / subscribers) AS VIEWS_PER_SUBSCRIBER FROM dbo.['Global YouTube Statistics']
GROUP BY Youtuber
ORDER BY VIEWS_PER_SUBSCRIBER DESC

-- calculating the average subscribers per population for each Youtuber 
SELECT g.Country, AVG(NULLIF(g.subscribers, 0) / NULLIF(p.Population, 0)) AS VIEWS_PER_POPULATION FROM dbo.['Global YouTube Statistics'] AS g
JOIN dbo.['Global YouTube Statistics CountryData'] AS p
ON p.Youtuber = g.Youtuber
GROUP BY g.Country
ORDER BY VIEWS_PER_POPULATION DESC


WITH FULL_CREATION_DATE AS (
    SELECT 
        CONCAT(created_year, '-', created_month, '-', created_date) AS FULL_CREATION_DATE
    FROM dbo.['Global YouTube Statistics']
)
SELECT FULL_CREATION_DATE AS DaysBetweenEvents FROM FULL_CREATION_DATE;








