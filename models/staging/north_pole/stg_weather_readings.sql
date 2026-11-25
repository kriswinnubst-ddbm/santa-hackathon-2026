select
    reading_id,
    region_id,
    reading_ts,
    reading_ts::date as weather_date,
    nullif(temperature_c, -999) as temperature_c,
    snowfall_cm,
    wind_speed_kph,
    visibility_km,
    sensor_id
from {{ source('raw', 'raw_weather_readings') }}
