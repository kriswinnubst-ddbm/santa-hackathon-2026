with src as (
    select * from {{ source('raw', 'raw_elf_shifts') }}
),
dedup as (
    select *
    from src
    qualify row_number() over (partition by shift_id order by shift_id) = 1
)
select
    shift_id,
    elf_id,
    shift_date,
    workshop_id,
    case
        when upper(trim(status)) in ('STRIKE', 'ON STRIKE') then 'STRIKE'
        else upper(trim(status))
    end as status,
    hours_worked,
    case when toys_built < 0 then null else toys_built end as toys_built,
    toys_defective
from dedup
