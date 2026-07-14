-- ============================================================
-- File:        01_data_quality_checks.sql
-- Project:     Financial Performance Analysis (2009–2023)
-- Description: Data quality assessment and anomaly detection
--              across 12 major public companies
-- Dataset:     Financial Statements of Major Companies (2009–2023)
--              by Rishabh Patil — Kaggle (DbCL License)
-- ============================================================


-- Query 1: Dataset Scope Overview
-- Objective: Assess dataset coverage across companies, sectors,
--            and time period to validate analytical scope.

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT company) AS total_companies,
    COUNT(DISTINCT category) AS total_sectors,
    MIN(year) AS first_year,
    MAX(year) AS last_year
FROM financial_statements;


-- Query 2: NULL Value Detection in Key Financial Columns
-- Objective: Identify missing values in critical fields that
--            could affect the reliability of financial analysis.

SELECT
    SUM(CASE WHEN revenue IS NULL THEN 1 ELSE 0 END) AS null_revenue,
    SUM(CASE WHEN ebitda IS NULL THEN 1 ELSE 0 END) AS null_ebitda,
    SUM(CASE WHEN net_income IS NULL THEN 1 ELSE 0 END) AS null_net_income,
    SUM(CASE WHEN market_cap IS NULL THEN 1 ELSE 0 END) AS null_market_cap,
    SUM(CASE WHEN debt_equity_ratio IS NULL THEN 1 ELSE 0 END) AS null_debt_equity
FROM financial_statements;


-- Query 3: Financial Distress Flagging
-- Objective: Classify company-year observations by financial
--            distress signals based on shareholder equity and net income.

SELECT
    year,
    company,
    category,
    shareholder_equity,
    net_income,
    CASE
        WHEN shareholder_equity < 0 AND net_income < 0
            THEN 'Negative Equity and Net Loss'
        WHEN shareholder_equity < 0
            THEN 'Negative Equity'
        WHEN net_income < 0
            THEN 'Net Loss'
        ELSE 'No Distress Signal'
    END AS financial_status
FROM financial_statements
ORDER BY financial_status, company, year;


-- Query 4: Duplicate Record Check
-- Objective: Verify dataset integrity by identifying duplicate
--            year/company combinations.

SELECT
    year,
    company,
    COUNT(*) AS occurrences
FROM financial_statements
GROUP BY year, company
HAVING COUNT(*) > 1;
