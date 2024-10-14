WITH daily_data AS (
    SELECT * 
    FROM {{ref('staging_weather_daily')}}
),
add_features AS (
    SELECT *
        , date AS date_day
        , date AS date_month
        , TO_CHAR(date, 'YYYY') AS date_year
        , TO_CHAR(date, 'IW') AS cw  -- ISO week number
        , TO_CHAR(date, 'Month') AS month_name
        , TO_CHAR(date, 'Day') AS weekday
    FROM daily_data
),
add_more_features AS (
    SELECT *
        , (CASE 
            WHEN month_name IN ('December', 'January', 'February') THEN 'winter'
            WHEN month_name IN ('March', 'April', 'May') THEN 'spring'
            WHEN month_name IN ('June', 'July', 'August') THEN 'summer'
            WHEN month_name IN ('September', 'October', 'November') THEN 'autumn'
        END) AS season
    FROM add_features
)
SELECT *
FROM add_more_features
ORDER BY date