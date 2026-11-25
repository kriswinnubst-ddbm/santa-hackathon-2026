# Data platform architecture

```
Source systems                     Snowflake: SANTA_DATA                    dbt (this repo)                    Consumers
---------------------------        ----------------------------------       ------------------------------    -------------------
Mail room / Santa app       --->   RAW.RAW_LETTERS                   --->   staging (views)                   Tableau: Mission Control
Elf-on-the-Shelf app        --->   RAW.RAW_BEHAVIOUR_EVENTS                 stg_*                             Board PDF (weekly)
Workshop time clocks        --->   RAW.RAW_ELF_SHIFTS                       intermediate (views)              Ad-hoc SQL (BI team)
Sleigh dispatch             --->   RAW.RAW_SLEIGH_SHIPMENTS                 int_*
Weather sensors (hourly)    --->   RAW.RAW_WEATHER_READINGS                 marts (tables)
Reindeer vet app            --->   RAW.RAW_REINDEER_HEALTH                  operations / compliance
Incident desk               --->   RAW.RAW_INCIDENTS
                                   ANALYTICS.*  (curated star schema, maintained by the platform team)
```

- **RAW** contains data exactly as it arrives. Expect duplicates, inconsistent labels, error codes and late confirmations.
- **ANALYTICS** is the curated star schema that Tableau reads. The dbt marts in this repo rebuild the operational part of it from RAW.
- **Environments:** `dev` builds into your own schema prefix (`DBT_STAGING`, `DBT_OPERATIONS`, ...) and `prod` uses the plain schema names (see `macros/generate_schema_name.sql`).
- **Lineage:** `stg_elf_shifts → int_elf_production_metrics → fct_elf_production_daily`, `stg_sleigh_shipments → fct_daily_deliveries`, `stg_behaviour_events → int_child_behaviour_scores → dim_child_behaviour`, `stg_weather_readings → int_weather_daily → fct_weather_daily`, `stg_letters → int_letters_parsed`.
