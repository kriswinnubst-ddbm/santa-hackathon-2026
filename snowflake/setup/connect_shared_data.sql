-- =====================================================================
-- connect_shared_data.sql : run this in your own Snowflake (trial) account to mount the North Pole data
-- Replace <PROVIDER_ORG>.<PROVIDER_ACCOUNT> with the identifier the organisers give you.
-- =====================================================================
USE ROLE ACCOUNTADMIN;

-- 0. Send this to the organisers so they can add you to the share
SELECT CURRENT_ORGANIZATION_NAME() || '.' || CURRENT_ACCOUNT_NAME() AS my_account, CURRENT_REGION() AS my_region;

-- 1. Mount the shared data (read-only, live, no copy)
CREATE DATABASE SANTA_DATA FROM SHARE <PROVIDER_ORG>.<PROVIDER_ACCOUNT>.SANTA_HACKATHON_SHARE;
GRANT IMPORTED PRIVILEGES ON DATABASE SANTA_DATA TO ROLE SYSADMIN;

-- 2. A small warehouse (trial credits are limited!)
CREATE WAREHOUSE IF NOT EXISTS TEAM_WH WAREHOUSE_SIZE = 'XSMALL' AUTO_SUSPEND = 60 AUTO_RESUME = TRUE INITIALLY_SUSPENDED = TRUE;
GRANT USAGE ON WAREHOUSE TEAM_WH TO ROLE SYSADMIN;

-- 3. Your own writable database for dbt output, views, Cortex results
CREATE DATABASE IF NOT EXISTS TEAM_WORK;
CREATE SCHEMA IF NOT EXISTS TEAM_WORK.DBT;
CREATE SCHEMA IF NOT EXISTS TEAM_WORK.SANDBOX;
GRANT OWNERSHIP ON DATABASE TEAM_WORK TO ROLE SYSADMIN COPY CURRENT GRANTS;

-- 4. Smoke test
USE WAREHOUSE TEAM_WH;
SELECT kpi_status, COUNT(*) FROM SANTA_DATA.ANALYTICS.FCT_DAILY_DELIVERIES GROUP BY 1;

-- 5. Cortex: not available on trial accounts. If you need Cortex, the organisers provide access.
