WITH departures AS (
    SELECT origin AS faa,
           COUNT(origin) AS nunique_from,
           COUNT(sched_dep_time) AS dep_planned,
           SUM(cancelled) AS dep_cancelled,
           SUM(diverted) AS dep_diverted,
           COUNT(arr_time) AS dep_n_flights,
           COUNT(DISTINCT tail_number) AS dep_nunique_tails,
           COUNT(DISTINCT airline) AS dep_nunique_airlines
    FROM {{ ref('prep_flights') }}
    GROUP BY origin
),
arrivals AS (
    SELECT dest AS faa,
           COUNT(dest) AS nunique_to,
           COUNT(sched_dep_time) AS arr_planned,
           SUM(cancelled) AS arr_cancelled,
           SUM(diverted) AS arr_diverted,
           COUNT(arr_time) AS arr_n_flights,
           COUNT(DISTINCT tail_number) AS arr_nunique_tails,
           COUNT(DISTINCT airline) AS arr_nunique_airlines
    FROM {{ ref('prep_flights') }}
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
SELECT pa.city,
       pa.country,
       pa.name,
       ts.*
FROM {{ ref('prep_airports') }} pa
LEFT JOIN total_stats ts
USING (faa)
ORDER BY ts.total_flights DESC;  -- Optional: Order by total flights or any meaningful metric
