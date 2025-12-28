SELECT *
FROM nyc_nyc_taxi_trips;

-- 1. What is the average trip duration (in minutes) per day of week?
SELECT
    pickup_weekday,
    ROUND(AVG(trip_duration) / 60, 2) AS avg_duration_min
FROM nyc_taxi_trips
WHERE trip_duration > 0
  AND trip_duration <= 180 * 60
GROUP BY pickup_weekday
ORDER BY avg_duration_min DESC;

-- 2. Identify peak pickup hours based on number of trips.
SELECT
    pickup_hour,
    COUNT(*) AS total_trips
FROM nyc_taxi_trips
WHERE trip_duration > 0
  AND trip_duration <= 180 * 60
GROUP BY pickup_hour
ORDER BY total_trips DESC;

-- 3. What is the average trip duration during weekends vs weekdays?
SELECT
    CASE 
        WHEN is_weekend = 1 THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    ROUND(AVG(trip_duration) / 60, 2) AS avg_duration_min
FROM nyc_taxi_trips
WHERE trip_duration > 0
  AND trip_duration <= 180 * 60
GROUP BY day_type;

-- 4. Which pickup hour has the longest average trip duration?
SELECT
    pickup_hour,
    ROUND(AVG(trip_duration) / 60, 2) AS avg_duration_min
FROM nyc_taxi_trips
WHERE trip_duration > 0
  AND trip_duration <= 180 * 60
GROUP BY pickup_hour
ORDER BY avg_duration_min DESC
LIMIT 1;

-- 5. What is the relationship between distance buckets and trip duration?
SELECT
    CASE
        WHEN trip_distance_km < 2 THEN '<2 km'
        WHEN trip_distance_km BETWEEN 2 AND 5 THEN '2–5 km'
        WHEN trip_distance_km BETWEEN 5 AND 10 THEN '5–10 km'
        ELSE '>10 km'
    END AS distance_bucket,
    ROUND(AVG(trip_duration) / 60, 2) AS avg_duration_min
FROM nyc_taxi_trips
WHERE trip_duration > 0
  AND trip_duration <= 180 * 60
GROUP BY distance_bucket
ORDER BY avg_duration_min;

-- 6. How does passenger count affect average trip duration?
SELECT
    passenger_count,
    ROUND(AVG(trip_duration) / 60, 2) AS avg_duration_min
FROM nyc_taxi_trips
WHERE trip_duration > 0
  AND trip_duration <= 180 * 60
GROUP BY passenger_count
ORDER BY passenger_count;

-- 7. Find the top 5 longest average trips by vendor.
SELECT
    vendor_id,
    ROUND(AVG(trip_duration) / 60, 2) AS avg_duration_min
FROM nyc_taxi_trips
WHERE trip_duration > 0
  AND trip_duration <= 180 * 60
GROUP BY vendor_id
ORDER BY avg_duration_min DESC
LIMIT 5;

-- 8. Calculate total trips and average duration per hour.
SELECT
    pickup_hour,
    COUNT(*) AS total_trips,
    ROUND(AVG(trip_duration) / 60, 2) AS avg_duration_min
FROM nyc_taxi_trips
WHERE trip_duration > 0
  AND trip_duration <= 180 * 60
GROUP BY pickup_hour
ORDER BY pickup_hour;

-- 9. Identify hours where average trip duration exceeds 20 minutes.
SELECT
    pickup_hour,
    ROUND(AVG(trip_duration) / 60, 2) AS avg_duration_min
FROM nyc_taxi_trips
WHERE trip_duration > 0
  AND trip_duration <= 180 * 60
GROUP BY pickup_hour
HAVING AVG(trip_duration) / 60 > 20;

-- 10. What percentage of trips are longer than 30 minutes?
SELECT
    ROUND(
        SUM(CASE WHEN trip_duration > 30 * 60 THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS long_trip_percentage
FROM nyc_taxi_trips
WHERE trip_duration > 0
  AND trip_duration <= 180 * 60;

-- 11. Detect potential anomalous trips (> 2 hours).
SELECT
    id,
    pickup_datetime,
    trip_distance_km,
    ROUND(trip_duration / 60, 2) AS duration_min
FROM nyc_taxi_trips
WHERE trip_duration > 120 * 60
  AND trip_duration <= 180 * 60
ORDER BY trip_duration DESC;

-- 12. Compare weekday vs weekend trip volume by hour.
SELECT
    pickup_hour,
    is_weekend,
    COUNT(*) AS trip_count
FROM nyc_taxi_trips
WHERE trip_duration > 0
  AND trip_duration <= 180 * 60
GROUP BY pickup_hour, is_weekend
ORDER BY pickup_hour, is_weekend;

-- 13. Find the hour contributing the highest total trip duration.
SELECT
    pickup_hour,
    ROUND(SUM(trip_duration) / 3600, 2) AS total_hours
FROM nyc_taxi_trips
WHERE trip_duration > 0
  AND trip_duration <= 180 * 60
GROUP BY pickup_hour
ORDER BY total_hours DESC
LIMIT 1;

-- 14. Rank hours by average trip duration (window function).
SELECT
    pickup_hour,
    ROUND(AVG(trip_duration) / 60, 2) AS avg_duration_min,
    RANK() OVER (ORDER BY AVG(trip_duration) DESC) AS duration_rank
FROM nyc_taxi_trips
WHERE trip_duration > 0
  AND trip_duration <= 180 * 60
GROUP BY pickup_hour;

-- 15. Find trips longer than the overall average duration.
SELECT
    id,
    pickup_datetime,
    ROUND(trip_duration / 60, 2) AS duration_min
FROM nyc_taxi_trips
WHERE trip_duration >
    (
        SELECT AVG(trip_duration)
        FROM nyc_taxi_trips
        WHERE trip_duration > 0
        
          AND trip_duration <= 180 * 60
    )
AND trip_duration <= 180 * 60;