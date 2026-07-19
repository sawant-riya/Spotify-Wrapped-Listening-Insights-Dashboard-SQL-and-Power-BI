# Spotify-Wrapped-Listening-Insights-Dashboard-SQL-and-Power-BI

1. Project Title
   Spotify Wrapped Listening Insights Dashboard SQL and Power BI

2. Project Overview

   A self-built "Spotify Wrapped" analytics dashboard that analyzes personal streaming history to surface listening patterns, top artists/tracks, hourly &       daily behavior, offline vs. online usage, and skip behavior. Built end-to-end using SQL for data cleaning and KPI calculation, and Power BI for               interactive visualization.

3. Short Description
   A complete end-to-end analytics project built using SQL and Power BI, inspired by the annual Spotify Wrapped experience. This project analyzes 156K           listening minutes, 47K+ genuine streams (30+ second plays), 2,574 unique artists, 7,476 unique tracks, and a 12.4% skip rate, turning raw streaming logs      into meaningful insights and interactive dashboards.

4.Project Goals

 - Transform raw streaming logs into structured analytical tables
 
 - Build SQL queries to calculate major KPIs (listening time, top artists, skip %)

 - Create a 2-page interactive Power BI dashboard showcasing personalized listening insights

 - Demonstrate real-world analytics skills using SQL, DAX, and Power BI visualization best practices
    


5.Key KPIs showcased:
 
 - Total Listening Time: 156K minutes
 
 - Total Streams: 47K (plays lasting 30+ seconds — see Methodology below)

- Unique Artists: 2,574

- Unique Songs: 7,476

- Overall Skip Rate: 12.4%

- Offline Plays: 1,155 · Shuffle Plays: 15,317 · Incognito Sessions: 1 

6.Tools & Technologies

- SQL (PostgreSQL): Data cleaning, aggregations, CTEs, window functions (ROW_NUMBER), conditional categorization
 
- Power BI / DAX: Calculated columns, measures, CALCULATE, RANKX, DIVIDE, interactive slicers

7.How this project helps?

 This project demonstrates the ability to take a raw, messy event-level dataset (57K+ rows of device strings, timestamps,    and play flags) and turn it into structured, trustworthy KPIs and an interactive dashboard — the same underlying skill      streaming platforms use internally to track engagement, recommendation  quality, and usage patterns at scale.
  
8.Business Insights

- Listening behavior is time-dependent, with two clear engagement peaks at 6 AM (10.3K minutes) and 5 PM (9.4K minutes) —     both 219–247% higher than the midnight baseline (3.0K minutes), suggesting strong morning/evening routine-driven usage.

- Skip behavior remains material (12.4%), suggesting room to improve playlist sequencing or recommendation relevance during   certain listening contexts.

- Weekday listening is consistently high and fairly stable (21.3K–23.2K minutes, Monday–Friday), without one single day       dominating the pattern.

- The dominant device platform is Android (39,188 of 57,508 plays), once raw device-string values were normalized into        clean categories — a useful signal for where to prioritize platform-specific testing or features.

- The most-played artist also tops the most-skipped list in raw counts — but this reflects play volume, not necessarily       poor fit; a rate-based (not count-based) view is used to properly separate genuine "loyal" tracks from high-exposure ones.

9. Methodology & Assumptions 

- Stream definition: A play is only counted toward "Total Streams" if it lasted 30+ seconds, aligned with the threshold       Spotify itself uses to count a genuine stream — filtering out accidental taps and near-instant skips.

- Platform categorization: The raw platform field contains 46 distinct, inconsistent device-string values (e.g.,              "web_player osx 10.15;firefox 95.0;desktop"). These were programmatically normalized into 4 clean categories (Android,       Mac/OSX, Web Player, Windows) using pattern matching, with careful   attention to condition order to avoid                  misclassifying overlapping substrings.

- Loyalty ranking: "Most loyal tracks" (lowest skip rate) requires a minimum of 10 total plays before a track qualifies, to   avoid a single lucky play with zero skips being misread as a meaningful loyalty signal.

- Minutes vs. play counts: All "peak hour" figures represent total minutes played in that hour bucket (aggregated across      all dates), not a count of individual plays — this distinction is called out explicitly to avoid ambiguity.

10. Files in This Repository

  spotify_wrapped_sql_project.sql — full SQL build: schema, cleaning, KPI queries, window-function rankings, and              categorization logic

  Spotify Wrapped Listening Insights Dashboard SQL and Power BI.pbix — interactive 2-page Power BI dashboard

11. Dashboard Preview

  Page 1 — Spotify Wrapped Summary (Yearly Overview): headline KPIs, minutes-over-time trend, top skipped tracks, top 10      artists.

  Page 2 — Listening Behavior and Analytics: skip/shuffle/offline/incognito breakdown, reason-for-play-start composition,     hourly and day-of-week listening patterns.
 




