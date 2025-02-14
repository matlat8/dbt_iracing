{{ config(materialized='table') }}

WITH data_cte AS (
    SELECT
        sr.cust_id,
        sr.display_name,
        sr.club_name,
        sr.country_code,
        ca.country_image_url
    FROM iracing.session_results sr
    LEFT JOIN iracing.country_attribution ca
        on sr.country_code = ca.country_code
    WHERE cust_id <> 0
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY cust_id
        ORDER BY loaddate DESC, display_name DESC
    ) = 1
)
SELECT
    *
from
    data_cte
