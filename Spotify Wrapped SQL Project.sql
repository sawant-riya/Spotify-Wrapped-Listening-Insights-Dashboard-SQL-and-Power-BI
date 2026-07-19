CREATE TABLE spotify_wrapped (
    ts TIMESTAMP,
    platform VARCHAR(500),
    ms_played INT,
    conn_country VARCHAR(50),
    track_name VARCHAR(255),
    artist_name VARCHAR(255),
    album_name VARCHAR(255),
    track_uri VARCHAR(255),
    reason_start VARCHAR(50),
    reason_end VARCHAR(50),
    shuffle BOOLEAN,
    skipped BOOLEAN,
    offline BOOLEAN,
    incognito_mode BOOLEAN
);

ALTER DATABASE  Spotify_wrapped_db RENAME TO  spotify_wrapped_db;
ALTER TABLE spotify_wrapped
ALTER COLUMN platform TYPE 
VARCHAR(500);

SELECT COUNT(*) AS total_rows FROM spotify_wrapped;

SELECT * FROM spotify_wrapped LIMIT 10;

--------------------------------------------------------------------------------------

--Q1] Total Listening Time [Calculates total listening time in minutes.]

--Q1] Total Listening Time [Calculates total listening time in minutes.]

SELECT ROUND(SUM(ms_played)/60000.0, 2) AS total_minutes_played
FROM spotify_wrapped;

--Q2]Total Number Of Tracks Played [Counts total number of tracks played.]

SELECT COUNT(*) AS total_tracks_played
FROM spotify_wrapped;

--Q3]Top 5 Most Played Tracks [Finds the top 5 tracks with the highest total listening time]

SELECT track_name, artist_name, SUM(ms_played)/60000 AS total_minutes
FROM spotify_wrapped
WHERE track_name IS NOT NULL AND artist_name IS NOT NULL
GROUP BY track_name, artist_name
ORDER BY total_minutes DESC
LIMIT 5;

--Q4] Number of Unique Artists [Counts how many different artists you listened to.]

SELECT COUNT(DISTINCT artist_name) AS unique_artists
FROM spotify_wrapped;

--Q5] Most Used Platform [Shows which platform (Web, Mobile, etc.) you used the most.]

SELECT platform, COUNT(*) AS usage_count
FROM spotify_wrapped
GROUP BY platform
ORDER BY usage_count DESC
LIMIT 1
;

--Q5b] Most Used Platform (Cleaned) [Groups fragmented device-string platform values into clean categories]

SELECT
    CASE
        WHEN platform ILIKE '%android%' THEN 'Android'
        WHEN platform ILIKE '%ios%' OR platform ILIKE '%iphone%' THEN 'iOS'
        WHEN platform ILIKE '%web_player%' THEN 'Web Player'   -- moved up, checked before osx/windows
        WHEN platform ILIKE '%osx%' OR platform ILIKE '%os x%' THEN 'Mac/OSX'
        WHEN platform ILIKE '%windows%' THEN 'Windows'
        ELSE 'Other'
    END AS platform_clean,
    COUNT(*) AS usage_count
FROM spotify_wrapped
GROUP BY platform_clean
ORDER BY usage_count DESC;

--Q6] Top 5 Artists by Total Listening Time [Identifies the top 5 artists you listened to the most, based on total minutes]

SELECT artist_name, SUM(ms_played)/60000 AS total_minutes
FROM spotify_wrapped
GROUP BY artist_name
ORDER BY total_minutes DESC
LIMIT 5;

--Q7] Top 5 Albums by Listening Time [Shows the most played albums by total listening time.]

SELECT COALESCE (album_name,'Unknown Album')AS album_name , SUM(ms_played)/60000 AS total_minutes
FROM spotify_wrapped
GROUP BY album_name
ORDER BY total_minutes DESC
LIMIT 5;

--Q8] Skip Rate(%) [Calculates the percentage of tracks that were skipped.]

SELECT Round(SUM(CASE WHEN skipped THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS skip_percentage
FROM spotify_wrapped;

--Q9] Shuffle Usage [Calculates what percentage of tracks were played on shuffle]

SELECT Round(SUM(CASE WHEN shuffle THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS shuffle_percentage
FROM spotify_wrapped;

--Q10] Total Listening Time by Country [Shows how much time was spent listening to Spotify in each country]

SELECT conn_country, SUM(ms_played)/60000 AS total_minutes
FROM spotify_wrapped
GROUP BY conn_country
ORDER BY total_minutes DESC;

--Q11] Listening Trend by Day [Shows total listening time for each day to visualize trends]

SELECT DATE(ts) AS day, SUM(ms_played)/60000 AS daily_minutes
FROM spotify_wrapped
GROUP BY DATE(ts)
ORDER BY day;

--Q12] Listening Trend by Hour [Shows which hours of the day you listened the most]

SELECT EXTRACT(HOUR FROM ts) AS hour, SUM(ms_played)/60000 AS minutes_per_hour
FROM spotify_wrapped
GROUP BY EXTRACT(HOUR FROM ts)
ORDER BY hour;

--Q13] Offline VS Online Listening [Compares total listening time offline vs online]

SELECT 
    COALESCE(
        CASE 
            WHEN offline = TRUE THEN 'Offline'
            WHEN offline = FALSE THEN 'Online'
        END,
        'Unknown Status'
    ) AS listening_status,
    SUM(ms_played)/60000 AS total_minutes
FROM spotify_wrapped
GROUP BY listening_status;

--Insight: Helps understand how often users listen without internet connectivity.

--Q14] Incognito Mode Usage [Shows total listening time in incognito mode vs normal mode]

SELECT incognito_mode, SUM(ms_played)/60000 AS total_minutes
FROM spotify_wrapped
GROUP BY incognito_mode;
--Useful for understanding privacy behavior

--Q15] Top 5 Tracks Skipped Most [Finds the tracks you skipped most often]

SELECT track_name, artist_name, SUM(CASE WHEN skipped THEN 1 ELSE 0 END) AS skip_count 
FROM spotify_wrapped
GROUP BY track_name, artist_name
ORDER BY skip_count DESC
LIMIT 5;
--Indicates songs that may not appeal to you or that you replayed less.

--Q16] Tracks Played Offline Most [Shows which tracks are most played offline]

SELECT track_name, artist_name, SUM(CASE WHEN offline THEN 1 ELSE 0 END) AS offline_plays
FROM spotify_wrapped
GROUP BY track_name, artist_name
ORDER BY offline_plays DESC
LIMIT 5;
--Useful for identifying favorite tracks users download.

--Q17] Top 5 Reasons for Track Start [Shows the most common ways tracks were started (play button, autoplay, playlist, etc)]

SELECT reason_start, COUNT(*) AS count
FROM spotify_wrapped
GROUP BY reason_start
ORDER BY count DESC
LIMIT 5;
--Helps analyze listening behavior and engagement triggers


--Wrapped Insights
--Q18] Top 5 Tracks per Country [Finds the most played tracks in each country]

With RankedTracks AS (
                      SELECT conn_country,COALESCE (track_name,'Unknown') AS track_name, SUM(ms_played)/60000 AS total_minutes,
                      ROW_NUMBER()OVER(PARTITION BY conn_country ORDER BY SUM(ms_played)/60000 DESC)AS rn
FROM spotify_wrapped
GROUP BY conn_country, track_name)

SELECT conn_country, track_name, total_minutes
FROM RankedTracks
WHERE rn<=5
ORDER BY conn_country, total_minutes DESC;
--Great for geo-specific recommendations.

--Q19] Top 5 Artists per Month[Shows the most played artists each month]

With MonthlyRankedArtists AS (
                          SELECT TO_CHAR(ts, 'YYYY-MM') AS month, artist_name, SUM(ms_played)/60000 AS total_minutes,
                          ROW_NUMBER()OVER(PARTITION BY TO_CHAR(ts, 'YYYY-MM') ORDER BY SUM(ms_played)/60000 DESC) AS rn
FROM spotify_wrapped
GROUP BY month, artist_name
HAVING COUNT(*) >= 5 )

SELECT month, artist_name, total_minutes
FROM MonthlyRankedArtists
WHERE rn<=5
ORDER BY month,total_minutes DESC;
--Useful to see changing listening patterns over time

--Q20] Top 10 Most Loyal Tracks (Lowest Skip Rate) [Finds tracks you rarely skip]

SELECT track_name, artist_name, 
       SUM(CASE WHEN skipped THEN 1 ELSE 0 END)*100.0/COUNT(*) AS skip_rate,
       COUNT(*) AS total_plays
FROM spotify_wrapped
GROUP BY track_name, artist_name
HAVING COUNT(*) >= 10
ORDER BY skip_rate ASC
LIMIT 10;

--Identifies your favorite tracks—perfect for playlist recommendations

