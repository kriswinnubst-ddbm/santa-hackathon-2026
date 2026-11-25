with sh as (
    select * from {{ ref('stg_sleigh_shipments') }}
),
d as (
    select
        shipment_date as delivery_date,
        region_id,
        count(*) as shipments,
        count_if(status = 'CANCELLED') as cancelled_shipments,
        sum(planned_gifts) as planned_gifts,
        sum(coalesce(delivered_gifts, 0)) as delivered_gifts,
        count_if(status = 'DELIVERED') as on_time_shipments,
        round(avg(delay_minutes), 1) as avg_delay_minutes
    from sh
    group by 1, 2
),
bl as (
    select region_id, sum(delivered_gifts) / sum(planned_gifts) as baseline_delivery_rate
    from d
    where delivery_date <= '{{ var("baseline_end_date") }}'
    group by 1
)
select
    d.delivery_date,
    d.region_id,
    r.region_name,
    r.macro_region,
    r.sub_region,
    r.workshop_id,
    d.shipments,
    d.cancelled_shipments,
    d.planned_gifts,
    d.delivered_gifts,
    round(d.delivered_gifts / d.planned_gifts, 4) as delivery_rate,
    d.on_time_shipments,
    round(d.on_time_shipments / d.shipments, 4) as on_time_rate,
    d.avg_delay_minutes,
    round(bl.baseline_delivery_rate, 4) as baseline_delivery_rate,
    round(delivery_rate / bl.baseline_delivery_rate - 1, 4) as pct_change_vs_baseline,
    case
        when pct_change_vs_baseline <= -0.30 then 'RED'
        when pct_change_vs_baseline <= -0.10 then 'AMBER'
        else 'GREEN'
    end as kpi_status
from d
join bl on bl.region_id = d.region_id
join {{ source('ref_data', 'dim_region') }} r on r.region_id = d.region_id
