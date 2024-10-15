WITH flight_stats AS (
    SELECT 
        flight_date::DATE,
        origin AS airport_code,
        COUNT(DISTINCT dest) AS unique_departures_connections, -- unique destination airports from the origin
        COUNT(DISTINCT origin) AS unique_arrivals_connections,  -- unique origin airports arriving at this airport
        COUNT(*) AS total_flights_planned,                      -- total flights planned (departures + arrivals)
        SUM(CASE WHEN cancelled = 1 THEN 1 ELSE 0 END) AS total_flights_cancelled, -- total canceled flights
        SUM(CASE WHEN diverted = 1 THEN 1 ELSE 0 END) AS total_flights_diverted,   -- total diverted flights
        COUNT(*) - SUM(CASE WHEN cancelled = 1 THEN 1 ELSE 0 END) - SUM(CASE WHEN diverted = 1 THEN 1 ELSE 0 END) AS total_flights_occurred, -- flights that occurred
        COUNT(DISTINCT tail_number) AS unique_airplanes,  -- optional: unique airplanes per day
        COUNT(DISTINCT airline) AS unique_airlines        -- optional: unique airlines per day
    FROM "hh_analytics_24_2"."s_ivanchertov"."prep_flights"
    GROUP BY flight_date, origin
),
airport_info AS (
    SELECT faa AS airport_code, city, country, name AS airport_name
    FROM "hh_analytics_24_2"."s_ivanchertov"."prep_airports"
),
weather_stats AS (
    SELECT 
        date::DATE AS flight_date,
        faa AS airport_code,
        MIN(temp_min) AS daily_min_temp,  -- daily minimum temperature
        MAX(temp_max) AS daily_max_temp,  -- daily maximum temperature
        SUM(precipitation) AS daily_precipitation, -- daily total precipitation
        SUM(snowfall) AS daily_snowfall,           -- daily total snowfall
        AVG(wind_direction) AS daily_avg_wind_direction, -- daily average wind direction
        AVG(wind_speed) AS daily_avg_wind_speed,        -- daily average wind speed
        MAX(wind_gust) AS daily_wind_peakgust          -- daily peak wind gust
    FROM "hh_analytics_24_2"."s_ivanchertov"."prep_weather_daily"
    GROUP BY flight_date, faa
)
SELECT
    fs.flight_date,
    fs.airport_code,
    a.city,
    a.country,
    a.airport_name,
    fs.unique_departures_connections,
    fs.unique_arrivals_connections,
    fs.total_flights_planned,
    fs.total_flights_cancelled,
    fs.total_flights_diverted,
    fs.total_flights_occurred,
    fs.unique_airplanes, -- optional
    fs.unique_airlines, -- optional
    ws.daily_min_temp,
    ws.daily_max_temp,
    ws.daily_precipitation,
    ws.daily_snowfall,
    ws.daily_avg_wind_direction,
    ws.daily_avg_wind_speed,
    ws.daily_wind_peakgust
FROM flight_stats fs
LEFT JOIN airport_info a ON fs.airport_code = a.airport_code
LEFT JOIN weather_stats ws ON fs.flight_date = ws.flight_date AND fs.airport_code = ws.airport_code -- Removed the problematic semicolon here
