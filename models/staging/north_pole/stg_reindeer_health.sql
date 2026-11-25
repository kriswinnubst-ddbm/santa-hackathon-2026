select
    r.reindeer_id,
    d.reindeer_name,
    d.team_id,
    r.check_date,
    r.health_status,
    r.health_status = 'FIT' as is_available,
    r.body_temp_c,
    r.carrots_eaten,
    r.vet_note
from {{ source('raw', 'raw_reindeer_health') }} r
left join {{ source('ref_data', 'dim_reindeer') }} d on d.reindeer_id = r.reindeer_id
