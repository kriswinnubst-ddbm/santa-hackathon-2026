# North Pole Enterprises – Business glossary

Business definitions used across North Pole Enterprises. All analytics tables live in schema `ANALYTICS` of the shared database (in your account e.g. `SANTA_DATA.ANALYTICS`). Data covers 1 November – 24 December 2026. Santa asks questions in English, Dutch and the occasional "ho ho ho".

## Core definitions

| Term | Definition | SQL |
|---|---|---|
| Nice / lief / zoet | Child with behaviour score 70 or higher | `dim_child.behaviour_score >= 70` or `is_nice = TRUE` |
| Naughty / stout | Child with behaviour score below 40 | `naughty_nice_segment = 'NAUGHTY'` |
| Borderline / twijfelgeval | Score 40–69: gets only their #1 wish, rest under review | `naughty_nice_segment = 'BORDERLINE'` |
| Unknown behaviour | No behaviour events recorded in 2026 (Elf-on-the-Shelf offline) | `behaviour_score IS NULL` |
| Behaviour score | 65 + sum of all score_delta in 2026, capped to 0–100 | `dim_child.behaviour_score` |
| Coal / kolen | Wish rejected because child is naughty | `fct_wishlist_items.fulfilment_status = 'COAL'` |
| Delivery rate / leverbetrouwbaarheid | Delivered gifts / planned gifts | `fct_daily_deliveries.delivery_rate` (aggregate as `SUM(delivered_gifts)/SUM(planned_gifts)`, never average the rates) |
| Baseline | Region delivery rate over 1–28 Nov 2026 | `baseline_delivery_rate` |
| Red KPI / rode KPI | Delivery rate 30% or more below baseline | `kpi_status = 'RED'` |
| On time | Shipment status DELIVERED (DELAYED = >60 min late) | `on_time_rate` |
| Strike / staking | Elf with shift status STRIKE | `fct_elf_production_daily.elves_on_strike` |
| Absence / verzuim | (sick + strike) / rostered elves | `absence_rate` |
| Productivity | Toys built per elf hour | `toys_per_elf_hour` |
| Storm | Snowfall ≥ 30 cm or wind ≥ 80 km/h on a day | `fct_weather_daily.is_storm` |
| Heatwave / hittegolf | Max temperature ≥ 40 °C | `is_heatwave` |
| Europe / Europa | macro_region = 'Europe' (Nordics + Western Europe + Central & Eastern Europe) | `dim_region.macro_region = 'Europe'` |
| Lapland | region_id = 'FI-LAP' | |
| Holland / Nederland | region_id = 'NL' | |
| Workshop / werkplaats | Production + dispatch site, 8 in total | `dim_workshop` |
| Rudolph | reindeer_id = 'R01', lead of team T01 Nordic Express | `dim_reindeer` |

## Synonyms

- child, kid, kind, kinderen → `dim_child`
- toy, gift, present, cadeau, speelgoed → `dim_toy` (catalogue) / `fct_wishlist_items` (wishes) / `planned_gifts` (deliveries)
- wish, wishlist, verlanglijstje, wensen → `fct_wishlist_items`
- delivery, bezorging, levering, sleigh, slee → `fct_daily_deliveries`
- elf, elfje, elves, kabouter → `dim_elf`, `fct_elf_production_daily`
- reindeer, rendier → `dim_reindeer`, `fct_reindeer_health_daily`
- weather, weer, snow, sneeuw → `fct_weather_daily`
- incident, problem, storing → `fct_incidents`
- this week / deze week → relative to 24 Dec 2026 unless Santa says otherwise ("today" = latest date in the data)

## Frequently asked questions (with the SQL we use)

**Q: How many nice children are there in the Netherlands?**
```sql
SELECT COUNT(*) AS nice_children
FROM SANTA_DATA.ANALYTICS.DIM_CHILD
WHERE region_id = 'NL' AND behaviour_score >= 70;
```

**Q: Welke regio's staan op rood op 10 december?**
```sql
SELECT region_name, delivery_rate, baseline_delivery_rate, pct_change_vs_baseline
FROM SANTA_DATA.ANALYTICS.FCT_DAILY_DELIVERIES
WHERE delivery_date = '2026-12-10'::date AND kpi_status = 'RED'
ORDER BY pct_change_vs_baseline;
```

**Q: What are the top 5 most wished-for toys by nice kids?**
```sql
SELECT t.toy_name, COUNT(*) AS wishes
FROM SANTA_DATA.ANALYTICS.FCT_WISHLIST_ITEMS w
JOIN SANTA_DATA.ANALYTICS.DIM_CHILD c ON c.child_id = w.child_id
JOIN SANTA_DATA.ANALYTICS.DIM_TOY t ON t.toy_id = w.toy_id
WHERE c.is_nice
GROUP BY t.toy_name
ORDER BY wishes DESC
LIMIT 5;
```

**Q: Delivery rate per macro region in December?**
```sql
SELECT macro_region, SUM(delivered_gifts) / NULLIF(SUM(planned_gifts), 0) AS delivery_rate
FROM SANTA_DATA.ANALYTICS.FCT_DAILY_DELIVERIES
WHERE delivery_date >= '2026-12-01'::date
GROUP BY macro_region
ORDER BY delivery_rate;
```

## Questions Santa asked last week that nobody answered yet

- Hoeveel elfjes staakten er gisteren in Rovaniemi?
- Which workshop has the highest defect rate in the week of 14 December?
- How many children get coal this year, per country?
- Was Rudolph fit on 8 December?
- Show snowfall in Lapland versus delivery rate per day in December.
- Which toy category is most popular among 6–8 year olds?
