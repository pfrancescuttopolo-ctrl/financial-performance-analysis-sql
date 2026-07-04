-- ============================================================
-- File:        04_sector_benchmarking.sql
-- Project:     Financial Performance Analysis (2009–2023)
-- Description: Sector and peer benchmarking using CTEs and
--              advanced aggregations across 12 companies
-- Dataset:     Financial Statements of Major Companies (2009–2023)
--              by Rishabh Patil — Kaggle (DbCL License)
-- ============================================================


-- Query 12: Top 2 Companies by ROE Within Each Sector (Most Recent Year)
-- Objective: ROE-based ranking within each sector for the most
--            recent available year, top 2 per sector.

WITH latest_data AS (
    SELECT DISTINCT ON (company)
        company,
        category,
        year,
        roe
    FROM financial_statements
    ORDER BY company, year DESC
),
ranked_roe AS (
    SELECT
        company,
        category,
        year,
        roe,
        DENSE_RANK() OVER (PARTITION BY category ORDER BY roe DESC) AS roe_rank
    FROM latest_data
)
SELECT
    company,
    category,
    year,
    ROUND(roe, 2) AS roe,
    roe_rank
FROM ranked_roe
WHERE roe_rank <= 2
ORDER BY category, roe_rank;

-- Query 13: EBITDA Margin vs Sector Average
-- Objective: EBITDA margin per company compared against
--            the sector average by year.

WITH sector_avg AS (
    SELECT
        category,
        AVG(ebitda / NULLIF(revenue, 0) * 100) AS avg_sector_ebitda_margin
    FROM financial_statements
    GROUP BY category
),
company_margin AS (
    SELECT
        company,
        category,
        year,
        ROUND(ebitda / NULLIF(revenue, 0) * 100, 2) AS ebitda_margin
    FROM financial_statements
)
SELECT
    cm.year,
    cm.company,
    cm.category,
    cm.ebitda_margin,
    ROUND(sa.avg_sector_ebitda_margin::NUMERIC, 2) AS sector_avg_margin,
    CASE
        WHEN cm.ebitda_margin > sa.avg_sector_ebitda_margin THEN 'Above Sector Average'
        ELSE 'Below Sector Average'
    END AS vs_sector
FROM company_margin cm
JOIN sector_avg sa ON cm.category = sa.category
ORDER BY cm.category, cm.year, cm.company;


-- Query 14: Revenue Growth Outlier Detection
-- Objective: Annual revenue growth classification per company
--            relative to sector average.

WITH yoy AS (
    SELECT
        year,
        company,
        category,
        revenue,
        LAG(revenue) OVER (PARTITION BY company ORDER BY year) AS prev_revenue,
        ROUND(
            (revenue - LAG(revenue) OVER (PARTITION BY company ORDER BY year))
            / NULLIF(LAG(revenue) OVER (PARTITION BY company ORDER BY year), 0) * 100,
        2) AS yoy_growth
    FROM financial_statements
),
sector_growth_avg AS (
    SELECT
        category,
        AVG(yoy_growth) AS avg_sector_growth
    FROM yoy
    WHERE yoy_growth IS NOT NULL
    GROUP BY category
)
SELECT
    y.year,
    y.company,
    y.category,
    y.yoy_growth,
    ROUND(sga.avg_sector_growth::NUMERIC, 2) AS sector_avg_growth,
    CASE
        WHEN y.yoy_growth > sga.avg_sector_growth * 1.5 THEN 'High Growth Outlier'
        WHEN y.yoy_growth < 0 THEN 'Revenue Decline'
        ELSE 'Normal Growth'
    END AS growth_classification
FROM yoy y
JOIN sector_growth_avg sga ON y.category = sga.category
WHERE y.yoy_growth IS NOT NULL
ORDER BY y.category, y.year, y.company;
