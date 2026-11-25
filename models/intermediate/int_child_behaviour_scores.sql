-- base score 65 (decided by Mrs. Claus in 2019, don't change)
with ev as (
    select child_id, count(*) as events_count, sum(score_delta) as score_sum, max(event_ts) as last_event_at
    from {{ ref('stg_behaviour_events') }}
    group by 1
),
scored as (
    select
        c.child_id,
        c.first_name,
        c.last_name,
        c.gender,
        c.birth_date,
        c.age,
        c.region_id,
        c.city,
        c.registered_at,
        coalesce(ev.events_count, 0) as events_count,
        ev.last_event_at,
        least(100, greatest(0, 65 + ev.score_sum)) as score
    from {{ source('ref_data', 'dim_child') }} c
    left join ev on ev.child_id = c.child_id
)
select
    child_id, first_name, last_name, gender, birth_date, age, region_id, city, registered_at,
    events_count,
    last_event_at,
    score as behaviour_score,
    case
        when score is null then 'UNKNOWN'
        when score >= 70 then 'NICE'
        when score >= 40 then 'BORDERLINE'
        else 'NAUGHTY'
    end as naughty_nice_segment,
    score >= 70 as is_nice
from scored
