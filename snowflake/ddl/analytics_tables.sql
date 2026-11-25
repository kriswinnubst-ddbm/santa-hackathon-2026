-- Save Santa's Supply Chain - ANALYTICS schema DDL with business descriptions
-- Use as context for the NL-to-SQL copilot (Track 3). Database name in your account may differ (e.g. SANTA_DATA).

CREATE OR REPLACE TABLE ANALYTICS.DIM_WORKSHOP (
    WORKSHOP_ID           VARCHAR COMMENT 'Workshop key',
    WORKSHOP_NAME         VARCHAR COMMENT 'Name',
    CITY                  VARCHAR COMMENT 'City',
    COUNTRY_CODE          VARCHAR COMMENT 'ISO country code (XX = North Pole)',
    LATITUDE              FLOAT COMMENT 'Latitude',
    LONGITUDE             FLOAT COMMENT 'Longitude',
    ELF_CAPACITY          NUMBER(38,0) COMMENT 'Number of elves employed',
    SERVES                VARCHAR COMMENT 'Sales area served by the workshop',
    OPENED_YEAR           NUMBER(38,0) COMMENT 'Year opened',
    UNION_MEMBERSHIP_PCT  NUMBER(4,2) COMMENT 'Share of elves in the elf union'
)
COMMENT = 'Santa''s 8 workshops (production + dispatch).';

CREATE OR REPLACE TABLE ANALYTICS.DIM_REGION (
    REGION_ID                 VARCHAR COMMENT 'Region key, e.g. FI-LAP = Lapland',
    REGION_NAME               VARCHAR COMMENT 'Name',
    COUNTRY_CODE              VARCHAR COMMENT 'ISO country code',
    MACRO_REGION              VARCHAR COMMENT 'Europe | North America | South America | Asia | Oceania | Africa | Middle East',
    SUB_REGION                VARCHAR COMMENT 'Sub-region',
    WORKSHOP_ID               VARCHAR COMMENT 'Serving workshop',
    LATITUDE                  FLOAT COMMENT 'Latitude',
    LONGITUDE                 FLOAT COMMENT 'Longitude',
    KPI_TARGET_DELIVERY_RATE  NUMBER(4,2) COMMENT 'Target delivery rate (0.95)',
    TIMEZONE                  VARCHAR COMMENT 'IANA timezone'
)
COMMENT = 'Delivery regions (46). Europe = Nordics + Western Europe + Central & Eastern Europe.';

CREATE OR REPLACE TABLE ANALYTICS.DIM_TOY (
    TOY_ID              VARCHAR COMMENT 'Toy key',
    TOY_NAME            VARCHAR COMMENT 'Toy name',
    CATEGORY            VARCHAR COMMENT 'Toy category',
    AGE_MIN             NUMBER(38,0) COMMENT 'Minimum age',
    AGE_MAX             NUMBER(38,0) COMMENT 'Maximum age',
    BUILD_MINUTES       NUMBER(38,0) COMMENT 'Elf build time in minutes',
    MATERIAL_COST_EUR   NUMBER(8,2) COMMENT 'Material cost (EUR)',
    WEIGHT_KG           NUMBER(6,2) COMMENT 'Weight (kg)',
    IS_FRAGILE          BOOLEAN COMMENT 'Fragile',
    CONTAINS_CHOCOLATE  BOOLEAN COMMENT 'Contains chocolate (heat sensitive)'
)
COMMENT = 'Toy catalogue.';

CREATE OR REPLACE TABLE ANALYTICS.DIM_ELF (
    ELF_ID                VARCHAR COMMENT 'Elf key',
    FIRST_NAME            VARCHAR COMMENT 'First name',
    LAST_NAME             VARCHAR COMMENT 'Last name',
    WORKSHOP_ID           VARCHAR COMMENT 'Workshop',
    DEPARTMENT            VARCHAR COMMENT 'Department',
    HIRE_DATE             DATE COMMENT 'Hire date (elves live long)',
    SENIORITY_LEVEL       VARCHAR COMMENT 'Apprentice | Journeyelf | Master | Head Elf',
    IS_UNION_MEMBER       BOOLEAN COMMENT 'Member of the elf union (ELFU)',
    COOKIE_RATE_PER_HOUR  NUMBER(5,2) COMMENT 'Pay in cookies per hour'
)
COMMENT = 'Elf employees.';

CREATE OR REPLACE TABLE ANALYTICS.DIM_REINDEER (
    REINDEER_ID       VARCHAR COMMENT 'Reindeer key',
    REINDEER_NAME     VARCHAR COMMENT 'Name',
    TEAM_ID           VARCHAR COMMENT 'Team key',
    TEAM_NAME         VARCHAR COMMENT 'Team name',
    HARNESS_POSITION  VARCHAR COMMENT 'Lead | Swing | Team | Wheel | Backup Lead',
    HOME_WORKSHOP_ID  VARCHAR COMMENT 'Home workshop',
    AGE_YEARS         NUMBER(38,0) COMMENT 'Age',
    MAX_PAYLOAD_KG    NUMBER(38,0) COMMENT 'Max payload (kg)',
    HAS_GLOWING_NOSE  BOOLEAN COMMENT 'Has a glowing nose'
)
COMMENT = 'Reindeer and their teams. Rudolph (R01) leads Nordic Express (T01).';

CREATE OR REPLACE TABLE ANALYTICS.DIM_CHILD (
    CHILD_ID              VARCHAR COMMENT 'Child key',
    FIRST_NAME            VARCHAR COMMENT 'First name',
    LAST_NAME             VARCHAR COMMENT 'Last name',
    GENDER                VARCHAR COMMENT 'F | M | X',
    BIRTH_DATE            DATE COMMENT 'Birth date',
    AGE                   NUMBER(38,0) COMMENT 'Age on 24 Dec 2026',
    REGION_ID             VARCHAR COMMENT 'Region',
    CITY                  VARCHAR COMMENT 'City',
    REGISTERED_AT         DATE COMMENT 'Date added to the list',
    EVENTS_COUNT          NUMBER(38,0) COMMENT 'Number of behaviour events in 2026',
    LAST_EVENT_AT         TIMESTAMP_NTZ COMMENT 'Last behaviour event',
    BEHAVIOUR_SCORE       NUMBER(38,0) COMMENT '0-100, = 65 + sum(score_delta), capped. NULL when no events',
    NAUGHTY_NICE_SEGMENT  VARCHAR COMMENT 'NICE (>=70) | BORDERLINE (40-69) | NAUGHTY (<40) | UNKNOWN (no score)',
    IS_NICE               BOOLEAN COMMENT 'behaviour_score >= 70'
)
COMMENT = 'Children on Santa''s list with their 2026 behaviour score.';

CREATE OR REPLACE TABLE ANALYTICS.FCT_WISHLIST_ITEMS (
    WISH_ID               VARCHAR COMMENT 'Wish key',
    LETTER_ID             VARCHAR COMMENT 'Source letter',
    CHILD_ID              VARCHAR COMMENT 'Child',
    REGION_ID             VARCHAR COMMENT 'Region of the child',
    TOY_ID                VARCHAR COMMENT 'Matched toy',
    WISH_RANK             NUMBER(38,0) COMMENT 'Position on the wishlist (1 = most wanted)',
    LETTER_RECEIVED_DATE  DATE COMMENT 'Letter received date',
    PARSE_METHOD          VARCHAR COMMENT 'structured_json | flat_json | localised_json | nested_json | free_text_nlp | manual_elf_review',
    PARSE_CONFIDENCE      NUMBER(4,3) COMMENT 'Parser confidence 0-1',
    FULFILMENT_STATUS     VARCHAR COMMENT 'APPROVED | UNDER_REVIEW | COAL | UNKNOWN'
)
COMMENT = 'Wishes parsed from the letters. Grain: one toy on one letter.';

CREATE OR REPLACE TABLE ANALYTICS.FCT_DAILY_DELIVERIES (
    DELIVERY_DATE           DATE COMMENT 'Date',
    REGION_ID               VARCHAR COMMENT 'Region',
    REGION_NAME             VARCHAR COMMENT 'Region name',
    MACRO_REGION            VARCHAR COMMENT 'Macro region',
    SUB_REGION              VARCHAR COMMENT 'Sub-region',
    WORKSHOP_ID             VARCHAR COMMENT 'Serving workshop',
    SHIPMENTS               NUMBER(38,0) COMMENT 'Number of shipments',
    CANCELLED_SHIPMENTS     NUMBER(38,0) COMMENT 'Cancelled shipments',
    PLANNED_GIFTS           NUMBER(38,0) COMMENT 'Gifts planned',
    DELIVERED_GIFTS         NUMBER(38,0) COMMENT 'Gifts delivered (unconfirmed counted as 0)',
    DELIVERY_RATE           NUMBER(6,4) COMMENT 'delivered_gifts / planned_gifts',
    ON_TIME_SHIPMENTS       NUMBER(38,0) COMMENT 'Shipments with status DELIVERED',
    ON_TIME_RATE            NUMBER(6,4) COMMENT 'on_time_shipments / shipments',
    AVG_DELAY_MINUTES       NUMBER(8,1) COMMENT 'Average delay (min)',
    BASELINE_DELIVERY_RATE  NUMBER(6,4) COMMENT 'Region delivery rate 1-28 Nov',
    PCT_CHANGE_VS_BASELINE  NUMBER(6,4) COMMENT 'delivery_rate / baseline - 1',
    KPI_STATUS              VARCHAR COMMENT 'RED (<= -30%) | AMBER (<= -10%) | GREEN'
)
COMMENT = 'Daily delivery KPI per region. Baseline = delivery rate 1-28 Nov. RED if >=30% below baseline.';

CREATE OR REPLACE TABLE ANALYTICS.FCT_ELF_PRODUCTION_DAILY (
    WORKSHOP_ID        VARCHAR COMMENT 'Workshop',
    PRODUCTION_DATE    DATE COMMENT 'Date',
    ELVES_ROSTERED     NUMBER(38,0) COMMENT 'Elves on the roster',
    ELVES_WORKED       NUMBER(38,0) COMMENT 'Elves who worked',
    ELVES_SICK         NUMBER(38,0) COMMENT 'Elves sick',
    ELVES_ON_STRIKE    NUMBER(38,0) COMMENT 'Elves on strike',
    ELVES_ON_LEAVE     NUMBER(38,0) COMMENT 'Vacation + day off',
    HOURS_WORKED       NUMBER(10,1) COMMENT 'Total hours',
    TOYS_BUILT         NUMBER(38,0) COMMENT 'Toys built',
    TOYS_DEFECTIVE     NUMBER(38,0) COMMENT 'Toys rejected',
    ABSENCE_RATE       NUMBER(6,4) COMMENT '(sick + strike) / rostered',
    STRIKE_RATE        NUMBER(6,4) COMMENT 'strike / rostered',
    DEFECT_RATE        NUMBER(6,4) COMMENT 'toys_defective / toys_built',
    TOYS_PER_ELF_HOUR  NUMBER(8,3) COMMENT 'Productivity'
)
COMMENT = 'Workshop production per day (output of int_elf_production_metrics).';

CREATE OR REPLACE TABLE ANALYTICS.FCT_WEATHER_DAILY (
    REGION_ID          VARCHAR COMMENT 'Region',
    WEATHER_DATE       DATE COMMENT 'Date',
    AVG_TEMP_C         NUMBER(6,1) COMMENT 'Average temperature',
    MIN_TEMP_C         NUMBER(6,1) COMMENT 'Min temperature',
    MAX_TEMP_C         NUMBER(6,1) COMMENT 'Max temperature',
    TOTAL_SNOWFALL_CM  NUMBER(7,1) COMMENT 'Snowfall (cm)',
    MAX_WIND_KPH       NUMBER(6,1) COMMENT 'Max wind (km/h)',
    MIN_VISIBILITY_KM  NUMBER(6,2) COMMENT 'Min visibility (km)',
    IS_STORM           BOOLEAN COMMENT 'Snowfall >= 30 cm or wind >= 80 km/h',
    IS_HEATWAVE        BOOLEAN COMMENT 'Max temp >= 40C'
)
COMMENT = 'Daily weather per region (sensor errors removed).';

CREATE OR REPLACE TABLE ANALYTICS.FCT_INCIDENTS (
    INCIDENT_ID    VARCHAR COMMENT 'Incident key',
    INCIDENT_DATE  DATE COMMENT 'Date',
    REPORTED_AT    TIMESTAMP_NTZ COMMENT 'Reported at',
    REGION_ID      VARCHAR COMMENT 'Region',
    WORKSHOP_ID    VARCHAR COMMENT 'Workshop',
    CATEGORY       VARCHAR COMMENT 'Category',
    SEVERITY       NUMBER(38,0) COMMENT '1-5',
    DESCRIPTION    VARCHAR COMMENT 'Free text',
    STATUS         VARCHAR COMMENT 'OPEN | RESOLVED'
)
COMMENT = 'Cleaned incident log.';

CREATE OR REPLACE TABLE ANALYTICS.FCT_REINDEER_HEALTH_DAILY (
    CHECK_DATE     DATE COMMENT 'Date',
    REINDEER_ID    VARCHAR COMMENT 'Reindeer',
    REINDEER_NAME  VARCHAR COMMENT 'Name',
    TEAM_ID        VARCHAR COMMENT 'Team',
    HEALTH_STATUS  VARCHAR COMMENT 'FIT | FLU | INJURED | RESTING',
    IS_AVAILABLE   BOOLEAN COMMENT 'health_status = FIT',
    BODY_TEMP_C    NUMBER(4,1) COMMENT 'Body temperature',
    CARROTS_EATEN  NUMBER(5,1) COMMENT 'Carrots eaten',
    VET_NOTE       VARCHAR COMMENT 'Vet note'
)
COMMENT = 'Reindeer availability per day.';

-- Relationships
-- DIM_REGION.workshop_id            -> DIM_WORKSHOP.workshop_id
-- DIM_ELF.workshop_id               -> DIM_WORKSHOP.workshop_id
-- DIM_REINDEER.home_workshop_id     -> DIM_WORKSHOP.workshop_id
-- DIM_CHILD.region_id               -> DIM_REGION.region_id
-- FCT_WISHLIST_ITEMS.child_id       -> DIM_CHILD.child_id
-- FCT_WISHLIST_ITEMS.toy_id         -> DIM_TOY.toy_id
-- FCT_DAILY_DELIVERIES.region_id    -> DIM_REGION.region_id
-- FCT_ELF_PRODUCTION_DAILY.workshop_id -> DIM_WORKSHOP.workshop_id
-- FCT_WEATHER_DAILY.region_id       -> DIM_REGION.region_id
-- FCT_INCIDENTS.region_id           -> DIM_REGION.region_id
-- FCT_REINDEER_HEALTH_DAILY.reindeer_id -> DIM_REINDEER.reindeer_id
