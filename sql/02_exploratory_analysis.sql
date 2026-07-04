-- ============================================================
-- File:        02_exploratory_analysis.sql
-- Project:     Financial Performance Analysis (2009–2023)
-- Description: Exploratory analysis of revenue, profitability,
--              and sector-level performance across 12 companies
-- Dataset:     Financial Statements of Major Companies (2009–2023)
--              by Rishabh Patil — Kaggle (DbCL License)
-- ============================================================


-- Query 5: Average Revenue and EBITDA per Company
-- Objective: Average EBITDA, revenue, and net profit margin
--            per company across the full observation period.

SELECT
    company,
    category,
    ROUND(AVG(revenue), 2) AS avg_revenue,
    ROUND(AVG(ebitda), 2) AS avg_ebitda,
    ROUND(AVG(net_profit_margin), 2) AS avg_net_profit_margin
FROM financial_statements
GROUP BY company, category
ORDER BY avg_ebitda DESC;


-- Query 6: Sector-Level Profitability Overview
-- Objective: Average revenue, EBITDA, ROE, and net margin
--            aggregated by sector for cross-industry comparison.

SELECT
    category,
    COUNT(DISTINCT company) AS num_companies,
    ROUND(AVG(revenue), 2) AS avg_revenue,
    ROUND(AVG(ebitda), 2) AS avg_ebitda,
    ROUND(AVG(roe), 2) AS avg_roe,
    ROUND(AVG(net_profit_margin), 2) AS avg_margin
FROM financial_statements
GROUP BY category
ORDER BY avg_ebitda DESC;


-- Query 7: Revenue Trend vs Company Historical Average
-- Objective: Annual revenue per company alongside their
--            historical average for trend assessment.

SELECT
    year,
    company,
    category,
    revenue,
    ROUND(AVG(revenue) OVER (PARTITION BY company), 2) AS company_avg_revenue
FROM financial_statements
ORDER BY company, year;
