select
    incident_id,
    reported_at,
    reported_at::date as incident_date,
    upper(region_id) as region_id,
    workshop_id,
    category,
    severity,
    description,
    status
from {{ source('raw', 'raw_incidents') }}
