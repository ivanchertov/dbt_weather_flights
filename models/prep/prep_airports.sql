WITH airports_reorder AS (
    SELECT faa
    	   ,region
    	   ,country
           ,name
           ,city
    FROM {{ref('staging_airports')}}
)
SELECT * FROM airports_reorder