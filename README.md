# Financial Performance Analysis

## Overview

This project analyzes the financial performance of 12 major public companies across multiple industries between 2009 and 2023 using PostgreSQL.

The analysis focuses on company performance through profitability, revenue growth, operating cash flow, leverage, and sector-level comparisons using SQL queries built with window functions, Common Table Expressions (CTEs), and conditional logic. The project also includes data quality checks to assess the reliability of the dataset before performing financial analysis.

---

## Business Questions

1. What is the scope and quality of the financial dataset?
2. How do average revenue, EBITDA, and profitability differ across companies and sectors?
3. Which companies rank highest by EBITDA and ROE within their sector?
4. How have revenue and operating cash flow evolved over time for each company?
5. Which company-year observations show signs of financial distress?
6. How are debt-to-equity ratios distributed across company-year observations?
7. How does each company's EBITDA margin compare with its sector average?
8. Which company-year observations report high or declining revenue growth relative to their historical sector average?

---

## Dataset

- **Source:** Kaggle – Financial Statements of Major Companies (2009–2023)
- **Author:** Rishabh Patil
- **Dataset License:** Database Contents License (DbCL)
- **Companies:** 12
- **Time Period:** 2009–2023
- **Observation Level:** Annual company financial statements
- **Currency/Units:** Market Cap is expressed in USD billions; all other financial figures (Revenue, EBITDA, Net Income, Cash Flow, Shareholder Equity) are expressed in USD millions, as reported in the source dataset

### Data Quality Notes

The dataset was assessed before analysis through SQL quality checks covering:

- Missing values in key financial variables
- Duplicate company-year records
- Financial distress indicators

One known data issue is the presence of both `BANK` and `Bank` as separate sector labels. This inconsistency originates from the original dataset and has been intentionally retained. As a result, SQL treats them as separate categories in sector-level aggregations and rankings.

---

## Technical Skills Demonstrated

- Aggregate Functions
- Window Functions (`RANK`, `DENSE_RANK`, `LAG`, `AVG OVER`, `SUM OVER`, `NTILE`)
- Common Table Expressions (CTEs)
- CASE expressions for business rule classification
- NULL handling (`NULLIF`, `IS NULL`)
- Data validation and quality checks
- Ranking and comparative analysis
- Year-over-year financial analysis

---

## Key Findings

- The dataset contains 161 annual company observations covering 12 companies from 2009 to 2023. SQL data quality checks identified no duplicate company-year records and only one missing value among the selected key financial variables, relating to market capitalization.

- The IT category recorded the highest overall profitability in the dataset, with the highest average EBITDA (50,629.47) and the highest average ROE (36.83%). At the company level, Apple reported the highest average EBITDA (68,080.43), followed by Microsoft and Google.

- Apple generated the highest cumulative operating cash flow in the dataset, reaching 895,928 by 2022. Microsoft followed with 675,666 by 2023, while Google reached 543,725 by 2022.

- Microsoft exceeded the historical IT-sector average EBITDA margin in the majority of recent years. In 2023, its EBITDA margin reached 48.31%, compared with the sector average of 36.00%.

- Sector-level comparisons should be interpreted carefully because several categories contain only one company. In addition, the original `BANK` and `Bank` labels are treated as separate categories in the SQL results.

---

## Tools

- PostgreSQL
- GitHub

---

## Project License

MIT License (project code)
