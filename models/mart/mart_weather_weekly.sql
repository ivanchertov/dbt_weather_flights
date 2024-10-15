WITH weekly_weather AS (
    SELECT 
        TO_CHAR(date, 'IYYY-IW') AS week_year,  -- ISO year and week
        faa AS airport_code,
        
        -- Aggregate metrics based on type (average, max, min, sum, or mode)
        MIN(temp_min) AS weekly_min_temp,            -- Minimum temperature of the week
        MAX(temp_max) AS weekly_max_temp,            -- Maximum temperature of the week
        AVG(precipitation) AS weekly_avg_precipitation, -- Average precipitation over the week
        SUM(precipitation) AS weekly_total_precipitation, -- Total precipitation over the week
        SUM(snowfall) AS weekly_total_snowfall,         -- Total snowfall of the week
        AVG(wind_direction) AS weekly_avg_wind_direction, -- Average wind direction over the week
        AVG(wind_speed) AS weekly_avg_wind_speed,         -- Average wind speed over the week
        MAX(wind_gust) AS weekly_wind_peakgust         -- Maximum wind gust over the week

    FROM "hh_analytics_24_2"."s_ivanchertov"."prep_weather_daily" -- Assuming this is the weather data
    GROUP BY TO_CHAR(date, 'IYYY-IW'), faa  -- Group by ISO year-week and airport code
)

-- Remove the ORDER BY here
SELECT * 
FROM weekly_weather;
