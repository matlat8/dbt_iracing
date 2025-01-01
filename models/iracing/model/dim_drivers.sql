{{ config(materialized='table') }}

WITH data_cte AS (
    SELECT
        cust_id,
        display_name,
        club_name,
        country_code
    FROM iracing.session_results
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
