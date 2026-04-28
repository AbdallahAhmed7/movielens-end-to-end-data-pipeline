

WITH src_movies AS (
SELECT * FROM {{ ref('src_movies') }}
)
SELECT
-- Surrogate key (requires dbt_utils package)
{{ dbt_utils.generate_surrogate_key(['movie_id']) }} AS movie_sk,
-- Natural key
movie_id,
-- Clean title: remove '(1995)' from end
REGEXP_REPLACE(INITCAP(TRIM(title)),'\\s*\\(\\d{4}\\)$', '') AS movie_title,
-- Extract year from title string
TRY_CAST(
REGEXP_SUBSTR(title, '\\d{4}', 1, 1) AS INT
) AS release_year,
-- Genres
SPLIT(genres, '|') AS genre_array,
genres
FROM src_movies