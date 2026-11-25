# north_pole_analytics

The dbt and Snowflake repository of **North Pole Enterprises**. It contains the transformations behind Santa's Mission Control dashboard.

> 🎄 **DDBM Christmas Hackathon 2026:** read [`HACKATHON.md`](HACKATHON.md) first.

## Repository layout

```
├── models/
│   ├── staging/north_pole/   1:1 cleaned views on the RAW source tables (+ _sources.yml)
│   ├── intermediate/         business logic: production metrics, behaviour scores, letter parsing, daily weather
│   └── marts/
│       ├── operations/       fct_daily_deliveries, fct_elf_production_daily, fct_weather_daily
│       └── compliance/       dim_child_behaviour (naughty/nice)
├── macros/                   generate_schema_name (dev/prod schema handling)
├── analyses/                 ad-hoc SQL kept for reference
├── tests/                    singular data tests
├── snowflake/
│   ├── ddl/                  DDL of the RAW and ANALYTICS tables
│   ├── setup/                mount the shared data in your account
│   └── cortex/               planned AI features
├── docs/
│   ├── architecture.md       data flow and lineage
│   ├── data_dictionary.md    every table and column
│   └── business/             company overview, glossary, meeting notes
└── sample_data/              1,000 raw letters for offline work
```

## Getting started

1. Mount the data in Snowflake: `snowflake/setup/connect_shared_data.sql`.
2. Copy `profiles.yml.example` to `~/.dbt/profiles.yml` and fill it in.
3. If you named the shared database something other than `SANTA_DATA`, set `vars.santa_db` in `dbt_project.yml`.
4. Run:
   ```bash
   pip install dbt-snowflake
   dbt debug
   dbt build --select staging intermediate marts
   ```

## Conventions

- `stg_` models are views, one per source table, and handle renaming, typing and deduplication only.
- `int_` models hold business logic and are not exposed to Tableau.
- Marts are tables, named `fct_` for facts and `dim_` for dimensions.
- Never commit credentials. `profiles.yml` and `.env` are git-ignored.

## Known issues

- Documentation is missing for almost every model. See the backlog.
- The only test (`not_null` on `dim_child_behaviour.behaviour_score`) fails.
- `int_letters_parsed` doesn't handle free-text letters (TODO in the model).
