WITH route_stats AS (
    SELECT
        origin AS origin_airport_code,
        dest AS destination_airport_code,
        COUNT(*) AS total_flights_on_route,
        COUNT(DISTINCT tail_number) AS unique_airplanes,
        COUNT(DISTINCT airline) AS unique_airlines,
        ROUND(AVG(actual_elapsed_time), 2) AS avg_actual_elapsed_time,
        ROUND(AVG(arr_delay), 2) AS avg_arrival_delay,
        MAX(arr_delay) AS max_arrival_delay,
        MIN(arr_delay) AS min_arrival_delay,
        SUM(CASE WHEN cancelled = 1 THEN 1 ELSE 0 END) AS total_cancelled,
        SUM(CASE WHEN diverted = 1 THEN 1 ELSE 0 END) AS total_diverted
    FROM prep_flights
    GROUP BY origin, dest
),
origin_airports AS (
    SELECT faa AS origin_airport_code, region, country
    FROM prep_airports
),
destination_airports AS (
    SELECT faa AS destination_airport_code, region AS dest_region, country AS dest_country
    FROM prep_airports
)
SELECT
    r.origin_airport_code,
    o.region AS origin_region,
    o.country AS origin_country,
    r.destination_airport_code,
    d.dest_region,
    d.dest_country,
    r.total_flights_on_route,
    r.unique_airplanes,
    r.unique_airlines,
    r.avg_actual_elapsed_time,
    r.avg_arrival_delay,
    r.max_arrival_delay,
    r.min_arrival_delay,
    r.total_cancelled,
    r.total_diverted
FROM route_stats r
LEFT JOIN origin_airports o ON r.origin_airport_code = o.origin_airport_code
LEFT JOIN destination
