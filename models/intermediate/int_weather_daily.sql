select
    region_id,
    weather_date,
    round(avg(temperature_c), 1) as avg_temp_c,
    round(min(temperature_c), 1) as min_temp_c,
    round(max(temperature_c), 1) as max_temp_c,
    round(sum(snowfall_cm), 1) as total_snowfall_cm,
    max(wind_speed_kph) as max_wind_kph,
    min(visibility_km) as min_visibility_km,
    total_snowfall_cm >= 30 or max_wind_kph >= 80 as is_storm,
    max_temp_c >= 40 as is_heatwave
from {{ ref('stg_weather_readings') }}
group by 1, 2
