select
    shipment_id,
    shipment_date,
    origin_workshop_id   as workshop_id,
    destination_region_id as region_id,
    reindeer_team_id,
    lead_reindeer_id,
    planned_gifts,
    delivered_gifts,
    departed_at,
    arrived_at,
    delay_minutes,
    status,
    -- delivered_gifts > planned_gifts happens, nobody knows why (ticket ELF-2291)
    least(coalesce(delivered_gifts, 0), planned_gifts) as delivered_gifts_capped
from {{ source('raw', 'raw_sleigh_shipments') }}
