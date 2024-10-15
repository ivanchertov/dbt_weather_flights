WITH weekly_weather AS (
    SELECT 
        TO_CHAR(date, 'IYYY-IW') AS week_year,  -- ISO year and week
        airport_code,  -- Using airport_code from prep_weather_daily
        
        -- Aggregate metrics based on type (average, max, min, sum, or mode)
        MIN(min_temp_c) AS weekly_min_temp,            -- Minimum temperature of the week
        MAX(max_temp_c) AS weekly_max_temp,            -- Maximum temperature of the week
        AVG(precipitation_mm) AS weekly_avg_precipitation, -- Average precipitation over the week
        SUM(precipitation_mm) AS weekly_total_precipitation, -- Total precipitation over the week
        SUM(max_snow_mm) AS weekly_total_snowfall,         -- Total snowfall of the week
        AVG(avg_wind_direction) AS weekly_avg_wind_direction, -- Average wind direction over the week
        AVG(avg_wind_speed_km) AS weekly_avg_wind_speed,         -- Average wind speed over the week
        MAX(wind_peakgust_kml) AS weekly_wind_peakgust         -- Maximum wind gust over the week
    FROM 
        "hh_analytics_24_2"."s_ivanchertov"."prep_weather_daily"
    GROUP BY 
        TO_CHAR(date, 'IYYY-IW'), airport_code  -- Group by ISO year-week and airport code
)
SELECT * 
FROM weekly_weather
ORDER BY week_year, airport_code;
