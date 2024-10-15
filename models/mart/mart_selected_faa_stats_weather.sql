WITH flight_stats AS (
    SELECT 
        flight_date::DATE,
        origin AS airport_code,
        COUNT(DISTINCT dest) AS unique_departures_connections,
        COUNT(DISTINCT origin) AS unique_arrivals_connections,
        COUNT(*) AS total_flights_planned,
        SUM(CASE WHEN cancelled = 1 THEN 1 ELSE 0 END) AS total_flights_cancelled,
        SUM(CASE WHEN diverted = 1 THEN 1 ELSE 0 END) AS total_flights_diverted,
        COUNT(*) - SUM(CASE WHEN cancelled = 1 THEN 1 ELSE 0 END) - SUM(CASE WHEN diverted = 1 THEN 1 ELSE 0 END) AS total_flights_occurred,
        COUNT(DISTINCT tail_number) AS unique_airplanes,
        COUNT(DISTINCT airline) AS unique_airlines
    FROM "hh_analytics_24_2"."s_ivanchertov"."prep_flights"
    GROUP BY flight_date, origin
),
airport_info AS (
    SELECT faa AS airport_code, region, country -- Removed non-existent columns
    FROM "hh_analytics_24_2"."s_ivanchertov"."prep_airports"
),
weather_stats AS (
    SELECT 
        date::DATE AS flight_date,
        faa AS airport_code,
        MIN(temp_min) AS daily_min_temp,
        MAX(temp_max) AS daily_max_temp,
        SUM(precipitation) AS daily_precipitation,
        SUM(snowfall) AS daily_snowfall,
        AVG(wind_direction) AS daily_avg_wind_direction,
        AVG(wind_speed) AS daily_avg_wind_speed,
        MAX(wind_gust) AS daily_wind_peakgust
    FROM "hh_analytics_24_2"."s_ivanchertov"."prep_weather_daily"
    GROUP BY flight_date, faa
)
SELECT
    fs.flight_date,
    fs.airport_code,
    a.region,
    a.country,
    fs.unique_departures_connections,
    fs.unique_arrivals_connections,
    fs.total_flights_planned,
    fs.total_flights_cancelled,
    fs.total_flights_diverted,
    fs.total_flights_occurred,
    fs.unique_airplanes,
    fs.unique_airlines,
    ws.daily_min_temp,
    ws.daily_max_temp,
    ws.daily_precipitation,
    ws.daily_snowfall,
    ws.daily_avg_wind_direction,
    ws.daily_avg_wind_speed,
    ws.daily_wind_peakgust
FROM flight_stats fs
LEFT JOIN airport_info a ON fs.airport_code = a.airport_code
LEFT JOIN weather_stats ws ON fs.flight_date = ws.flight_date AND fs.airport_code = ws.airport_code
