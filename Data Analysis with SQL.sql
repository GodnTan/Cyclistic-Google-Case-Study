--Create new dataset that contains data entries from Jan-Jun

CREATE TABLE `hardy-portal-412114.2023Data.First_half_data_2023` AS 
SELECT *
FROM(
  SELECT *
  FROM `hardy-portal-412114.2023Data.januarydata`
  UNION ALL
  SELECT *
  FROM `hardy-portal-412114.2023Data.FebuaryData`
  UNION ALL
  SELECT *
  FROM `hardy-portal-412114.2023Data.MarchData`
  UNION ALL
  SELECT *
  FROM `hardy-portal-412114.2023Data.AprilData`
  UNION ALL
  SELECT *
  FROM `hardy-portal-412114.2023Data.MayData`
  UNION ALL
  SELECT *
  FROM `hardy-portal-412114.2023Data.JuneData`
)
  
-- calculate the difference between the total number of rows (COUNT(*)) and the number of rows where the columns is not null (COUNT(col_name)). This difference represents the count of rows where the col_name is null.
SELECT  
  COUNT(*) - COUNT(ride_id) as ride_id_null_count, 
  COUNT(*) - COUNT(rideable_type) as rideable_type_null_count,
  COUNT(*) - COUNT(started_at) as started_at_null_count,
  COUNT(*) - COUNT(ended_at) as ended_at_null_count,
  COUNT(*) - COUNT(ride_id) as ride_id_null_count,
  COUNT(*) - COUNT(start_station_name) as start_station_name_null_count,
  COUNT(*) - COUNT(start_station_id) as start_station_id_null_count,
  COUNT(*) - COUNT(end_station_name) as end_station_name_null_count,
  COUNT(*) - COUNT(end_station_id) as end_station_id_null_count,
  COUNT(*) - COUNT(start_lat) as start_lat_name_null_count,
  COUNT(*) - COUNT(start_lng) as start_lng_name_null_count,
  COUNT(*) - COUNT(end_lat) as end_lat_null_count,
  COUNT(*) - COUNT(end_lng) as end_lng_null_count,
  COUNT(*) - COUNT(member_casual) as member_casual_null_count
FROM `hardy-portal-412114.2023Data.First_half_data_2023`
  
--check if there are duplicate ride_ids which return as true as there was one less row from the total rows which indicated a duplicate ride_id
SELECT
  COUNT(DISTINCT (ride_id) ) AS total, 
  COUNT(*) AS total_rows
FROM `hardy-portal-412114.2023Data.First_half_data_2023` 
  
 --get duplicate ride_id which was '1.19E+15' in the output
SELECT
  ride_id
FROM `hardy-portal-412114.2023Data.First_half_data_2023` 
GROUP BY
  ride_id
HAVING
  COUNT(ride_id) >1
  
--select the rows that were duplicates from the previous query to check if they were duplicate entries or just duplicate ride_ids with unique informations which in this case, is the latter
SELECT
  * 
FROM `hardy-portal-412114.2023Data.First_half_data_2023` 
WHERE
  ride_id = '1.19E+15'
  
--ensure count type is 2 which would only consists of member and casual
SELECT
  COUNT(DISTINCT member_casual) 
FROM 
  `hardy-portal-412114.2023Data.First_half_data_2023`
  
--create a new table that has no null values so that we dont change the old dataset
CREATE TABLE  `hardy-portal-412114.2023Data.First_half_data_2023_clean` AS 
SELECT *
FROM(
  SELECT  
    *
  FROM `hardy-portal-412114.2023Data.First_half_data_2023` 

  WHERE
    start_station_name is not null --based on previous query, this is the columns with null values hence we dont want them in our data
    AND
    start_station_id is not null
    AND
    end_station_name is not null
    AND
    end_station_id is not null
    AND
    end_lat is not null
    AND
    end_lng is not null
)
  
--Replace table by adding new columns to aid in further analysis of the dataset
CREATE OR REPLACE TABLE `hardy-portal-412114.2023Data.First_half_data_2023_clean`  AS
SELECT
   ride_id,rideable_type,started_at,ended_at,start_station_name,start_station_id, end_station_name,end_station_id, start_lat, start_lng,end_lat, end_lng,member_casual AS member_type,
  CASE 
    WHEN EXTRACT (DAYOFWEEK FROM started_at) = 1 THEN 'MON'
    WHEN EXTRACT (DAYOFWEEK FROM started_at) = 2 THEN 'TUE'
    WHEN EXTRACT (DAYOFWEEK FROM started_at) = 3 THEN 'WED'
    WHEN EXTRACT (DAYOFWEEK FROM started_at) = 4 THEN 'THU'
    WHEN EXTRACT (DAYOFWEEK FROM started_at) = 5 THEN 'FRI'
    WHEN EXTRACT (DAYOFWEEK FROM started_at) = 6 THEN 'SAT'
    WHEN EXTRACT (DAYOFWEEK FROM started_at) = 7 THEN 'SUN'
  END AS day_of_week ,
  CASE
    WHEN EXTRACT (MONTH FROM started_at) = 1 THEN 'JAN'
    WHEN EXTRACT (MONTH FROM started_at) = 2 THEN 'FEB'
    WHEN EXTRACT (MONTH FROM started_at) = 3 THEN 'MAR'
    WHEN EXTRACT (MONTH FROM started_at) = 4 THEN 'APR'
    WHEN EXTRACT (MONTH FROM started_at) = 5 THEN 'MAY'
    WHEN EXTRACT (MONTH FROM started_at) = 6 THEN 'JUN'
  END AS month,
  EXTRACT (DAY FROM started_at) AS day,
  EXTRACT (YEAR FROM started_at) AS year,
  TIMESTAMP_DIFF (ended_at, started_at, minute) AS ride_length_m,
  FORMAT_TIMESTAMP("%I:%M %p", started_at) AS time
FROM `hardy-portal-412114.2023Data.First_half_data_2023_clean`
WHERE TIMESTAMP_DIFF (ended_at, started_at, minute) > 1 AND TIMESTAMP_DIFF (ended_at, started_at, hour) < 24
  
--ensure that there are only 7 days as the output which includes Monday-Sunday
SELECT
  COUNT(DISTINCT day_of_week) as day
FROM `hardy-portal-412114.2023Data.First_half_data_2023_clean`

--Analysis of the popular hours where each user rides the bikes
SELECT 
  EXTRACT (HOUR from started_at) AS hour_of_day, count (*) AS num_of_rides, member_type
FROM `hardy-portal-412114.2023Data.First_half_data_2023_clean` 

GROUP BY
  hour_of_day , member_type
ORDER BY
  hour_of_day DESC,member_type

-- this query checks what days are the most popular ones within the week by counting number of riders
SELECT  
  COUNT(ride_id) AS total, 
  day_of_week           
FROM `hardy-portal-412114.2023Data.First_half_data_2023_clean` 
GROUP BY day_of_week

--Total Rides for Casual riders across the Mon-Sun from Jan-June
SELECT
  COUNT(ride_id) as total,
  day_of_week,
  member_type
FROM 
`hardy-portal-412114.2023Data.First_half_data_2023_clean` 
WHERE member_type = 'casual'
GROUP BY
  day_of_week,member_type
  
--Total Rides for Member riders across the Mon-Sun from Jan-June
SELECT
  COUNT(ride_id) as total,
  day_of_week,
  member_type
FROM 
`hardy-portal-412114.2023Data.First_half_data_2023_clean` 
WHERE member_type = 'member'
GROUP BY
  day_of_week,member_type

--compare average ride-lengths s between member and casual riders
SELECT  
  AVG(ride_length_m) AS total, 
  member_type,
  day_of_week        
FROM `hardy-portal-412114.2023Data.First_half_data_2023_clean` 
GROUP BY day_of_week, member_type
ORDER BY  day_of_week, member_type

