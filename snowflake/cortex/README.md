# Cortex (planned)

Backlog item NPE-412: "Explain red KPIs automatically". Santa wants the Mission Control dashboard to explain *why* a region turns red, in three bullets:

1. Primary cause
2. Aggravating factors
3. Recommended action

The idea is to call `SNOWFLAKE.CORTEX.COMPLETE` on the delivery KPI together with the telemetry for the same region and date (weather, elf production, reindeer health, incidents). Nothing has been built yet; put the SQL here.
