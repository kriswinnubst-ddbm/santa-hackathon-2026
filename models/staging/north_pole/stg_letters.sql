-- one row per letter, double scans removed
select
    letter_id,
    received_at,
    channel,
    postal_country,
    raw_payload,
    try_parse_json(raw_payload) as payload_json,
    payload_json is not null as is_valid_json
from {{ source('raw', 'raw_letters') }}
qualify row_number() over (partition by letter_id order by received_at) = 1
