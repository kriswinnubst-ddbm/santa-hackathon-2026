select
    event_id,
    child_id,
    event_ts,
    event_ts::date as event_date,
    coalesce(event_type, 'unknown') as event_type,
    score_delta,
    iff(score_delta > 0, 'NICE', 'NAUGHTY') as event_polarity,
    reported_by,
    source_system
from {{ source('raw', 'raw_behaviour_events') }}
where child_id is not null
