-- ad-hoc request from Mrs. Claus (Nov 2026), kept for reference
select
    w.region_id,
    t.toy_name,
    count(*) as wishes
from {{ source('ref_data', 'dim_toy') }} t
join {{ source('ref_data', 'fct_wishlist_items') }} w on w.toy_id = t.toy_id
group by 1, 2
qualify row_number() over (partition by w.region_id order by wishes desc) <= 5
order by 1, 3 desc
