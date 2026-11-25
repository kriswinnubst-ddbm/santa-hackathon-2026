with s as (
    select * from {{ ref('stg_elf_shifts') }}
),
agg as (
    select
        workshop_id,
        shift_date as production_date,
        count(distinct elf_id) as elves_rostered,
        count_if(status = 'WORKED') as elves_worked,
        count_if(status = 'SICK') as elves_sick,
        count_if(status = 'STRIKE') as elves_on_strike,
        count_if(status in ('VACATION', 'DAY_OFF')) as elves_on_leave,
        round(sum(hours_worked), 1) as hrs,
        sum(toys_built) as built,
        sum(toys_defective) as defects
    from s
    group by 1, 2
)
select
    workshop_id,
    production_date,
    elves_rostered,
    elves_worked,
    elves_sick,
    elves_on_strike,
    elves_on_leave,
    hrs as hours_worked,
    built as toys_built,
    defects as toys_defective,
    round((elves_sick + elves_on_strike) / elves_rostered, 4) as absence_rate,
    round(elves_on_strike / elves_rostered, 4) as strike_rate,
    round(defects / nullif(built, 0), 4) as defect_rate,
    round(built / nullif(hrs, 0), 3) as toys_per_elf_hour
from agg
