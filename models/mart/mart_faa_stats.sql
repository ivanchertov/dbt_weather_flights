WITH departures AS (
    SELECT origin AS faa,
           COUNT(origin) AS nunique_from,
           COUNT(sched_dep_time) AS dep_planned,
           SUM(CAST(cancelled AS INT)) AS dep_cancelled,
           SUM(CAST(diverted AS INT)) AS dep_diverted,
           COUNT(arr_time) AS dep_n_flights,
           COUNT(DISTINCT tail_number) AS dep_nunique_tails,
           COUNT(DISTINCT airline) AS dep_nunique_airlines
    FROM prep_flights
    GROUP BY origin
),
arrivals AS (
    SELECT dest AS faa,
           COUNT(dest) AS nunique_to,
           COUNT(sched_dep_time) AS arr_planned,
           SUM(CAST(cancelled AS INT)) AS arr_cancelled,
           SUM(CAST(diverted AS INT)) AS arr_diverted,
           COUNT(arr_time) AS arr_n_flights,
           COUNT(DISTINCT tail_number) AS arr_nunique_tails,
           COUNT(DISTINCT airline) AS arr_nunique_airlines
    FROM prep_flights
    GROUP BY dest
),
total_stats AS (
    SELECT faa,
           nunique_to,
           nunique_from,
           dep_planned + arr_planned AS total_planned,
           dep_cancelled + arr_cancelled AS total_canceled,
           dep_diverted + arr_diverted AS total_diverted,
           dep_n_flights + arr_n_flights AS total_flights
    FROM departures
    JOIN arrivals
    ON arrivals.faa = departures.faa
)
SELECT city,
       country,
       name,
       total_stats.*
FROM prep_airports
LEFT JOIN total_stats
USING (faa)
ORDER BY city;
