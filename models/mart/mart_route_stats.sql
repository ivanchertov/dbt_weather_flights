WITH route_stats AS (
    SELECT
        f.origin AS origin_airport_code,
        f.dest AS destination_airport_code,
        COUNT(*) AS total_flights_on_route,
        COUNT(DISTINCT f.tail_number) AS unique_airplanes,
        COUNT(DISTINCT f.airline) AS unique_airlines,
        ROUND(AVG(f.actual_elapsed_time), 2) AS avg_actual_elapsed_time,
        ROUND(AVG(f.arr_delay), 2) AS avg_arrival_delay,
        MAX(f.arr_delay) AS max_arrival_delay,
        MIN(f.arr_delay) AS min_arrival_delay,
        SUM(CASE WHEN f.cancelled = 1 THEN 1 ELSE 0 END) AS total_cancelled,
        SUM(CASE WHEN f.diverted = 1 THEN 1 ELSE 0 END) AS total_diverted
    FROM 
        "hh_analytics_24_2"."s_ivanchertov"."prep_flights" f
    GROUP BY 
        f.origin, f.dest
),
origin_airports AS (
    SELECT faa AS origin_airport_code, city AS origin_city, country AS origin_country
    FROM "hh_analytics_24_2"."s_ivanchertov"."prep_airports"
),
destination_airports AS (
    SELECT faa AS destination_airport_code, city AS destination_city, country AS destination_country
    FROM "hh_analytics_24_2"."s_ivanchertov"."prep_airports"
)
SELECT
    r.origin_airport_code,
    o.origin_city,
    o.origin_country,
    r.destination_airport_code,
    d.destination_city,
    d.destination_country,
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
LEFT JOIN destination_airports d ON r.destination_airport_code = d.destination_airport_code -- Removed extra semicolon here
