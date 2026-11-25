# Data dictionary

Database `SANTA_HACKATHON` (in your account: whatever you named the shared database). Period: 1 Nov - 24 Dec 2026.

## RAW.RAW_LETTERS

Letters to Santa as received by the mail room. One row per scanned letter; payload format varies per channel and country (JSON, localised JSON, nested JSON, free text, broken JSON). Contains duplicate scans.

| Column | Type | Description |
|---|---|---|
| letter_id | VARCHAR | Letter identifier (not unique: double scans exist) |
| received_at | TIMESTAMP_NTZ | Timestamp the letter was scanned (UTC) |
| channel | VARCHAR | post / email / chimney_drop / santa_app / mall_santa_scan |
| postal_country | VARCHAR | Country as written on the envelope; inconsistent (NL, nl, NLD, Nederland, Holland, ...) |
| raw_payload | VARCHAR | Letter content: JSON or free text. Use TRY_PARSE_JSON; ~25% is not valid JSON |

## RAW.RAW_BEHAVIOUR_EVENTS

Naughty/nice behaviour reports for 2026 from Elf-on-the-Shelf and other sources.

| Column | Type | Description |
|---|---|---|
| event_id | VARCHAR | Event identifier |
| child_id | VARCHAR | Child (FK dim_child); NULL for orphan reports |
| event_ts | TIMESTAMP_NTZ | When the behaviour was observed |
| event_type | VARCHAR | Behaviour type, e.g. shared_toys, tantrum; NULL for some reports |
| score_delta | NUMBER(38,0) | Score impact: positive = nice, negative = naughty |
| reported_by | VARCHAR | Reporting elf-on-the-shelf unit |
| source_system | VARCHAR | elf_on_the_shelf_app / chimney_cam / parent_hotline / teacher_portal |

## RAW.RAW_ELF_SHIFTS

Daily shift registration per elf, 1 Nov - 24 Dec 2026. Contains duplicate rows, inconsistent status labels and a few negative counts.

| Column | Type | Description |
|---|---|---|
| shift_id | VARCHAR | Shift identifier (duplicates exist) |
| elf_id | VARCHAR | Elf (FK dim_elf) |
| shift_date | DATE | Shift date |
| workshop_id | VARCHAR | Workshop (FK dim_workshop) |
| status | VARCHAR | WORKED / SICK / STRIKE / VACATION / DAY_OFF (dirty variants: 'on strike', 'Strike ', 'sick') |
| hours_worked | NUMBER(5,1) | Hours worked |
| toys_built | NUMBER(38,0) | Toys produced in the shift (negative values are entry errors) |
| toys_defective | NUMBER(38,0) | Toys rejected by quality control |

## RAW.RAW_SLEIGH_SHIPMENTS

Sleigh shipments from workshops to regional drop zones. Grain: one shipment.

| Column | Type | Description |
|---|---|---|
| shipment_id | VARCHAR | Shipment identifier |
| shipment_date | DATE | Planned shipment date |
| origin_workshop_id | VARCHAR | Workshop of origin |
| destination_region_id | VARCHAR | Destination region (FK dim_region) |
| reindeer_team_id | VARCHAR | Reindeer team flying the shipment |
| lead_reindeer_id | VARCHAR | Lead reindeer of the team on that flight |
| planned_gifts | NUMBER(38,0) | Gifts planned on the shipment |
| delivered_gifts | NUMBER(38,0) | Gifts confirmed delivered; NULL when confirmation not (yet) received |
| departed_at | TIMESTAMP_NTZ | Departure timestamp |
| arrived_at | TIMESTAMP_NTZ | Arrival timestamp; NULL if cancelled or not confirmed |
| delay_minutes | NUMBER(8,1) | Delay versus schedule in minutes |
| status | VARCHAR | DELIVERED / DELAYED / CANCELLED; NULL when not confirmed |

## RAW.RAW_WEATHER_READINGS

Hourly weather telemetry per region. temperature_c = -999 is a sensor error code.

| Column | Type | Description |
|---|---|---|
| reading_id | VARCHAR | Reading identifier |
| region_id | VARCHAR | Region (FK dim_region) |
| reading_ts | TIMESTAMP_NTZ | Hour of the reading (UTC) |
| temperature_c | NUMBER(6,1) | Temperature in Celsius (-999 = sensor error) |
| snowfall_cm | NUMBER(6,1) | Snowfall in the hour (cm) |
| wind_speed_kph | NUMBER(6,1) | Wind speed (km/h) |
| visibility_km | NUMBER(6,2) | Visibility (km) |
| sensor_id | VARCHAR | Weather station |

## RAW.RAW_REINDEER_HEALTH

Daily vet check per reindeer.

| Column | Type | Description |
|---|---|---|
| reindeer_id | VARCHAR | Reindeer (FK dim_reindeer) |
| check_date | DATE | Date of check |
| health_status | VARCHAR | FIT / FLU / INJURED / RESTING |
| body_temp_c | NUMBER(4,1) | Body temperature (normal ~38.6C) |
| carrots_eaten | NUMBER(5,1) | Carrots eaten that day |
| vet_note | VARCHAR | Free-text vet note |

## RAW.RAW_INCIDENTS

Operational incident log (free text). Some severities missing, some region ids lower-case.

| Column | Type | Description |
|---|---|---|
| incident_id | VARCHAR | Incident identifier |
| reported_at | TIMESTAMP_NTZ | When the incident was reported |
| region_id | VARCHAR | Affected region |
| workshop_id | VARCHAR | Responsible workshop |
| category | VARCHAR | Incident category |
| severity | NUMBER(38,0) | 1 (minor) - 5 (critical) |
| description | VARCHAR | Free-text description |
| status | VARCHAR | OPEN / RESOLVED |

## ANALYTICS.DIM_WORKSHOP

Santa's 8 workshops (production + dispatch).

| Column | Type | Description |
|---|---|---|
| workshop_id | VARCHAR | Workshop key |
| workshop_name | VARCHAR | Name |
| city | VARCHAR | City |
| country_code | VARCHAR | ISO country code (XX = North Pole) |
| latitude | FLOAT | Latitude |
| longitude | FLOAT | Longitude |
| elf_capacity | NUMBER(38,0) | Number of elves employed |
| serves | VARCHAR | Sales area served by the workshop |
| opened_year | NUMBER(38,0) | Year opened |
| union_membership_pct | NUMBER(4,2) | Share of elves in the elf union |

## ANALYTICS.DIM_REGION

Delivery regions (46). Europe = Nordics + Western Europe + Central & Eastern Europe.

| Column | Type | Description |
|---|---|---|
| region_id | VARCHAR | Region key, e.g. FI-LAP = Lapland |
| region_name | VARCHAR | Name |
| country_code | VARCHAR | ISO country code |
| macro_region | VARCHAR | Europe / North America / South America / Asia / Oceania / Africa / Middle East |
| sub_region | VARCHAR | Sub-region |
| workshop_id | VARCHAR | Serving workshop |
| latitude | FLOAT | Latitude |
| longitude | FLOAT | Longitude |
| kpi_target_delivery_rate | NUMBER(4,2) | Target delivery rate (0.95) |
| timezone | VARCHAR | IANA timezone |

## ANALYTICS.DIM_TOY

Toy catalogue.

| Column | Type | Description |
|---|---|---|
| toy_id | VARCHAR | Toy key |
| toy_name | VARCHAR | Toy name |
| category | VARCHAR | Toy category |
| age_min | NUMBER(38,0) | Minimum age |
| age_max | NUMBER(38,0) | Maximum age |
| build_minutes | NUMBER(38,0) | Elf build time in minutes |
| material_cost_eur | NUMBER(8,2) | Material cost (EUR) |
| weight_kg | NUMBER(6,2) | Weight (kg) |
| is_fragile | BOOLEAN | Fragile |
| contains_chocolate | BOOLEAN | Contains chocolate (heat sensitive) |

## ANALYTICS.DIM_ELF

Elf employees.

| Column | Type | Description |
|---|---|---|
| elf_id | VARCHAR | Elf key |
| first_name | VARCHAR | First name |
| last_name | VARCHAR | Last name |
| workshop_id | VARCHAR | Workshop |
| department | VARCHAR | Department |
| hire_date | DATE | Hire date (elves live long) |
| seniority_level | VARCHAR | Apprentice / Journeyelf / Master / Head Elf |
| is_union_member | BOOLEAN | Member of the elf union (ELFU) |
| cookie_rate_per_hour | NUMBER(5,2) | Pay in cookies per hour |

## ANALYTICS.DIM_REINDEER

Reindeer and their teams. Rudolph (R01) leads Nordic Express (T01).

| Column | Type | Description |
|---|---|---|
| reindeer_id | VARCHAR | Reindeer key |
| reindeer_name | VARCHAR | Name |
| team_id | VARCHAR | Team key |
| team_name | VARCHAR | Team name |
| harness_position | VARCHAR | Lead / Swing / Team / Wheel / Backup Lead |
| home_workshop_id | VARCHAR | Home workshop |
| age_years | NUMBER(38,0) | Age |
| max_payload_kg | NUMBER(38,0) | Max payload (kg) |
| has_glowing_nose | BOOLEAN | Has a glowing nose |

## ANALYTICS.DIM_CHILD

Children on Santa's list with their 2026 behaviour score.

| Column | Type | Description |
|---|---|---|
| child_id | VARCHAR | Child key |
| first_name | VARCHAR | First name |
| last_name | VARCHAR | Last name |
| gender | VARCHAR | F / M / X |
| birth_date | DATE | Birth date |
| age | NUMBER(38,0) | Age on 24 Dec 2026 |
| region_id | VARCHAR | Region |
| city | VARCHAR | City |
| registered_at | DATE | Date added to the list |
| events_count | NUMBER(38,0) | Number of behaviour events in 2026 |
| last_event_at | TIMESTAMP_NTZ | Last behaviour event |
| behaviour_score | NUMBER(38,0) | 0-100, = 65 + sum(score_delta), capped. NULL when no events |
| naughty_nice_segment | VARCHAR | NICE (>=70) / BORDERLINE (40-69) / NAUGHTY (<40) / UNKNOWN (no score) |
| is_nice | BOOLEAN | behaviour_score >= 70 |

## ANALYTICS.FCT_WISHLIST_ITEMS

Wishes parsed from the letters. Grain: one toy on one letter.

| Column | Type | Description |
|---|---|---|
| wish_id | VARCHAR | Wish key |
| letter_id | VARCHAR | Source letter |
| child_id | VARCHAR | Child |
| region_id | VARCHAR | Region of the child |
| toy_id | VARCHAR | Matched toy |
| wish_rank | NUMBER(38,0) | Position on the wishlist (1 = most wanted) |
| letter_received_date | DATE | Letter received date |
| parse_method | VARCHAR | structured_json / flat_json / localised_json / nested_json / free_text_nlp / manual_elf_review |
| parse_confidence | NUMBER(4,3) | Parser confidence 0-1 |
| fulfilment_status | VARCHAR | APPROVED / UNDER_REVIEW / COAL / UNKNOWN |

## ANALYTICS.FCT_DAILY_DELIVERIES

Daily delivery KPI per region. Baseline = delivery rate 1-28 Nov. RED if >=30% below baseline.

| Column | Type | Description |
|---|---|---|
| delivery_date | DATE | Date |
| region_id | VARCHAR | Region |
| region_name | VARCHAR | Region name |
| macro_region | VARCHAR | Macro region |
| sub_region | VARCHAR | Sub-region |
| workshop_id | VARCHAR | Serving workshop |
| shipments | NUMBER(38,0) | Number of shipments |
| cancelled_shipments | NUMBER(38,0) | Cancelled shipments |
| planned_gifts | NUMBER(38,0) | Gifts planned |
| delivered_gifts | NUMBER(38,0) | Gifts delivered (unconfirmed counted as 0) |
| delivery_rate | NUMBER(6,4) | delivered_gifts / planned_gifts |
| on_time_shipments | NUMBER(38,0) | Shipments with status DELIVERED |
| on_time_rate | NUMBER(6,4) | on_time_shipments / shipments |
| avg_delay_minutes | NUMBER(8,1) | Average delay (min) |
| baseline_delivery_rate | NUMBER(6,4) | Region delivery rate 1-28 Nov |
| pct_change_vs_baseline | NUMBER(6,4) | delivery_rate / baseline - 1 |
| kpi_status | VARCHAR | RED (<= -30%) / AMBER (<= -10%) / GREEN |

## ANALYTICS.FCT_ELF_PRODUCTION_DAILY

Workshop production per day (output of int_elf_production_metrics).

| Column | Type | Description |
|---|---|---|
| workshop_id | VARCHAR | Workshop |
| production_date | DATE | Date |
| elves_rostered | NUMBER(38,0) | Elves on the roster |
| elves_worked | NUMBER(38,0) | Elves who worked |
| elves_sick | NUMBER(38,0) | Elves sick |
| elves_on_strike | NUMBER(38,0) | Elves on strike |
| elves_on_leave | NUMBER(38,0) | Vacation + day off |
| hours_worked | NUMBER(10,1) | Total hours |
| toys_built | NUMBER(38,0) | Toys built |
| toys_defective | NUMBER(38,0) | Toys rejected |
| absence_rate | NUMBER(6,4) | (sick + strike) / rostered |
| strike_rate | NUMBER(6,4) | strike / rostered |
| defect_rate | NUMBER(6,4) | toys_defective / toys_built |
| toys_per_elf_hour | NUMBER(8,3) | Productivity |

## ANALYTICS.FCT_WEATHER_DAILY

Daily weather per region (sensor errors removed).

| Column | Type | Description |
|---|---|---|
| region_id | VARCHAR | Region |
| weather_date | DATE | Date |
| avg_temp_c | NUMBER(6,1) | Average temperature |
| min_temp_c | NUMBER(6,1) | Min temperature |
| max_temp_c | NUMBER(6,1) | Max temperature |
| total_snowfall_cm | NUMBER(7,1) | Snowfall (cm) |
| max_wind_kph | NUMBER(6,1) | Max wind (km/h) |
| min_visibility_km | NUMBER(6,2) | Min visibility (km) |
| is_storm | BOOLEAN | Snowfall >= 30 cm or wind >= 80 km/h |
| is_heatwave | BOOLEAN | Max temp >= 40C |

## ANALYTICS.FCT_INCIDENTS

Cleaned incident log.

| Column | Type | Description |
|---|---|---|
| incident_id | VARCHAR | Incident key |
| incident_date | DATE | Date |
| reported_at | TIMESTAMP_NTZ | Reported at |
| region_id | VARCHAR | Region |
| workshop_id | VARCHAR | Workshop |
| category | VARCHAR | Category |
| severity | NUMBER(38,0) | 1-5 |
| description | VARCHAR | Free text |
| status | VARCHAR | OPEN / RESOLVED |

## ANALYTICS.FCT_REINDEER_HEALTH_DAILY

Reindeer availability per day.

| Column | Type | Description |
|---|---|---|
| check_date | DATE | Date |
| reindeer_id | VARCHAR | Reindeer |
| reindeer_name | VARCHAR | Name |
| team_id | VARCHAR | Team |
| health_status | VARCHAR | FIT / FLU / INJURED / RESTING |
| is_available | BOOLEAN | health_status = FIT |
| body_temp_c | NUMBER(4,1) | Body temperature |
| carrots_eaten | NUMBER(5,1) | Carrots eaten |
| vet_note | VARCHAR | Vet note |
