-- ============================================================
-- File:        03_financial_performance_analysis.sql
-- Project:     Financial Performance Analysis (2009–2023)
-- Description: Advanced performance metrics using window functions
--              across companies and sectors
-- Dataset:     Financial Statements of Major Companies (2009–2023)
--              by Rishabh Patil — Kaggle (DbCL License)
-- ============================================================


-- Query 8: EBITDA Ranking Within Sector
-- Objective: EBITDA-based ranking of companies within each sector
--            using each company's most recent available year.

WITH latest_year AS (
    SELECT DISTINCT ON (company)
        company,
        category,
        ebitda,
        year
    FROM financial_statements
    ORDER BY company, year DESC
)
SELECT
    year,
    company,
    category,
    ebitda,
    RANK() OVER (
        PARTITION BY category
        ORDER BY ebitda DESC
    ) AS ebitda_rank_in_sector
FROM latest_year
ORDER BY category, ebitda_rank_in_sector, company;


-- Query 9: Year-Over-Year Revenue Growth
-- Objective: Annual revenue growth rate per company
--            relative to the prior year.

SELECT
    year,
    company,
    category,
    revenue,
    LAG(revenue) OVER (PARTITION BY company ORDER BY year) AS prev_year_revenue,
    ROUND(
        (revenue - LAG(revenue) OVER (PARTITION BY company ORDER BY year))
        / NULLIF(LAG(revenue) OVER (PARTITION BY company ORDER BY year), 0) * 100,
    2) AS yoy_revenue_growth_pct
FROM financial_statements
ORDER BY company, year;


-- Query 10: Cumulative Operating Cash Flow per Company
-- Objective: Running total of operating cash flow per company
--            from 2009 to the most recent available year.

SELECT
    year,
    company,
    category,
    cfo,
    SUM(cfo) OVER (PARTITION BY company ORDER BY year) AS cumulative_cfo
FROM financial_statements
ORDER BY company, year;


-- Query 11: Leverage Risk Classification by Debt/Equity Quartile
-- Objective: Distribution of companies across four leverage
--            risk quartiles based on debt-to-equity ratio.

SELECT
    year,
    company,
    category,
    debt_equity_ratio,
    NTILE(4) OVER (ORDER BY debt_equity_ratio DESC) AS leverage_risk_quartile
FROM financial_statements
WHERE debt_equity_ratio IS NOT NULL
ORDER BY leverage_risk_quartile, debt_equity_ratio DESC;
