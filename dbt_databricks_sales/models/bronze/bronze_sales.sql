{{config(
    materialized='view',
    schema='bronze'
)}}

select * 
from {{source('s_source', 'fact_sales')}}