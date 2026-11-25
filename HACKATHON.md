# DDBM Christmas Hackathon 2026: Save Santa's Supply Chain

You've just been hired by North Pole Enterprises. This is their production repo. Within 4 hours, build an AI use case that would also help a real client.

**Start by reading:** `docs/business/company_overview.md` (who wants what), `docs/business/glossary.md` (definitions) and `docs/data_dictionary.md` (the tables).

## Pick one route

| Route | Where in this repo |
|---|---|
| **1. Auto-dbt Docs**: Claude reads the SQL and generates `schema.yml` with descriptions and tests that pass `dbt compile` | `models/`; see "Known issues" in the README |
| **2. Anomaly Explainer**: Cortex explains a red KPI in 3 bullets, live in Tableau. Start with "Why did Lapland drop 79% on 10 December?" | `snowflake/cortex/`, `fct_daily_deliveries` + the telemetry tables |
| **3. NL-to-SQL Copilot**: Santa asks a question, Claude writes working Snowflake SQL | `snowflake/ddl/analytics_tables.sql` + `docs/business/glossary.md` |
| **4. Storyboard Generator**: from intake conversation to Tableau layout | `docs/business/meeting_notes/` |

## Working on it

- To keep your own copy you can push to, click **Use this template** on GitHub and work in your team's repo. Don't open pull requests on this repo.
- The data is synthetic, and you have read-only access in Snowflake.
- Rules: no driver rabbit holes, live demo is king, client value first.
- Deadline: **16:30 sharp**.
