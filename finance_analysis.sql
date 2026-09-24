-- ============================================================
-- Financial Performance Analysis | SQL Portfolio Project
-- Database: MySQL
-- Analysis Period: 2025
-- Scope: Completed financial transactions
-- ============================================================

-- ------------------------------------------------------------
-- DATA PREVIEW
-- ------------------------------------------------------------
SELECT *
FROM departments;

SELECT *
FROM financial_transactions
LIMIT 10;


-- ============================================================
-- TASK 1 | Department Financial Performance
-- ============================================================
-- Business Question:
-- For each department, how much Revenue and Expense was
-- recorded in 2025, and what was the resulting Profit?
--
-- Logic:
-- Profit = Revenue - Expense
-- Only completed transactions from 2025 are included.
-- ============================================================

WITH department_financials AS (
    SELECT
        d.department_name,

        SUM(
            CASE
                WHEN t.transaction_type = 'Revenue'
                THEN t.amount
                ELSE 0
            END
        ) AS Revenue,

        SUM(
            CASE
                WHEN t.transaction_type = 'Expense'
                THEN t.amount
                ELSE 0
            END
        ) AS Expense

    FROM departments AS d
    JOIN financial_transactions AS t
        ON t.department_id = d.department_id

    WHERE YEAR(t.transaction_date) = 2025
      AND t.status = 'Completed'

    GROUP BY
        d.department_id,
        d.department_name
)

SELECT
    department_name,
    Revenue,
    Expense,
    Revenue - Expense AS Profit
FROM department_financials
ORDER BY Profit DESC;

-- Key Business Insights:
-- • Technology generated the highest completed-2025 profit at
--   approximately ₹85.50 lakh.
-- • Research & Development followed closely at approximately
--   ₹84.72 lakh.
-- • Operations generated approximately ₹84.64 lakh profit.
-- • Finance generated the lowest profit at approximately
--   ₹61.69 lakh.
-- • The gap between the highest and lowest departmental profit
--   was approximately ₹23.81 lakh.
--
-- Management Summary:
-- Technology generated the highest departmental profit, while
-- Finance generated the lowest. Revenue alone does not determine
-- profitability because expenses have a significant impact.


-- ============================================================
-- TASK 2 | Monthly Financial Trend
-- ============================================================
-- Business Question:
-- How much Revenue and Expense did the company record in each
-- month of 2025?
-- ============================================================

SELECT
    MONTHNAME(transaction_date) AS month_name,

    SUM(
        CASE
            WHEN transaction_type = 'Revenue'
            THEN amount
            ELSE 0
        END
    ) AS Revenue,

    SUM(
        CASE
            WHEN transaction_type = 'Expense'
            THEN amount
            ELSE 0
        END
    ) AS Expense

FROM financial_transactions

WHERE YEAR(transaction_date) = 2025
  AND status = 'Completed'

GROUP BY
    MONTH(transaction_date),
    MONTHNAME(transaction_date)

ORDER BY MONTH(transaction_date);

-- Key Business Insights:
-- • December recorded the highest revenue at approximately
--   ₹1.91 crore.
-- • January recorded the lowest revenue at approximately
--   ₹1.26 crore.
-- • September recorded the highest expense at approximately
--   ₹1.31 crore.
-- • February recorded the lowest expense at approximately
--   ₹88.47 lakh.
-- • The highest-revenue month and highest-expense month were
--   different: December and September.
--
-- Management Summary:
-- Monthly revenue and expenses did not follow exactly the same
-- pattern. December generated the highest revenue, while
-- September recorded the highest expense.


-- ============================================================
-- TASK 3 | Expense Category Analysis
-- ============================================================
-- Business Question:
-- Which expense categories contribute the most to total company
-- spending in 2025?
-- ============================================================

WITH expense_categories AS (
    SELECT
        category AS Expenses_Category,
        SUM(amount) AS Total_Expense

    FROM financial_transactions

    WHERE YEAR(transaction_date) = 2025
      AND status = 'Completed'
      AND transaction_type = 'Expense'

    GROUP BY category
)

SELECT
    *,
    ROUND(
        (Total_Expense / SUM(Total_Expense) OVER ()) * 100,
        2
    ) AS Percentage_of_total_expense

FROM expense_categories
ORDER BY Total_Expense DESC;

-- Key Business Insights:
-- • Professional Fees is the largest expense category at
--   approximately ₹1.67 crore, contributing 12.70%.
-- • Equipment is the second-largest expense at approximately
--   ₹1.67 crore, contributing 12.68%.
-- • The difference between Professional Fees and Equipment is
--   approximately ₹19,982.
-- • Together, the two largest categories contribute 25.38%
--   of total completed expenses.
-- • No single category dominates total spending; the nine
--   categories range from approximately 10.08% to 12.70%.
-- • Utilities is the lowest expense category at approximately
--   ₹1.33 crore, contributing 10.08%.
--
-- Management Summary:
-- Professional Fees and Equipment are the two largest expense
-- categories, together contributing 25.38% of total expenses.
-- Overall, spending is relatively distributed across categories.


-- ============================================================
-- TASK 4 | Department Profitability Ranking
-- ============================================================
-- Business Question:
-- Which departments generated the highest profit in 2025?
-- ============================================================

WITH department_financials AS (
    SELECT
        d.department_name,

        SUM(
            CASE
                WHEN t.transaction_type = 'Revenue'
                THEN t.amount
                ELSE 0
            END
        ) AS Revenue,

        SUM(
            CASE
                WHEN t.transaction_type = 'Expense'
                THEN t.amount
                ELSE 0
            END
        ) AS Expense

    FROM departments AS d
    JOIN financial_transactions AS t
        ON t.department_id = d.department_id

    WHERE YEAR(t.transaction_date) = 2025
      AND t.status = 'Completed'

    GROUP BY
        d.department_id,
        d.department_name
),

department_profit AS (
    SELECT
        department_name,
        Revenue,
        Expense,
        Revenue - Expense AS Profit
    FROM department_financials
)

SELECT
    department_name,
    Revenue,
    Expense,
    Profit,
    DENSE_RANK() OVER (
        ORDER BY Profit DESC
    ) AS Profit_Rank

FROM department_profit
ORDER BY Profit_Rank;

-- Key Business Insights:
-- • Technology ranks #1 with approximately ₹85.50 lakh profit.
-- • Research & Development ranks #2 at approximately ₹84.72 lakh.
-- • Operations ranks #3 at approximately ₹84.64 lakh.
-- • Finance ranks #8 with approximately ₹61.69 lakh profit.
-- • The difference between #1 Technology and #8 Finance is
--   approximately ₹23.81 lakh.
--
-- Management Summary:
-- Technology generated the highest completed-2025 profit,
-- followed by Research & Development and Operations.


-- ============================================================
-- TASK 5 | Expense Classification & Contribution
-- ============================================================
-- Business Question:
-- Classify expense categories by spending level and calculate
-- each category's contribution to total expenses.
--
-- Classification Rules:
-- • >= ₹16,000,000  → High Expense
-- • >= ₹14,000,000  → Medium Expense
-- • Otherwise       → Low Expense
-- ============================================================

WITH expense_categories AS (
    SELECT
        category AS Expenses_Category,
        SUM(amount) AS Total_Expense

    FROM financial_transactions

    WHERE YEAR(transaction_date) = 2025
      AND status = 'Completed'
      AND transaction_type = 'Expense'

    GROUP BY category
)

SELECT
    *,
    CASE
        WHEN Total_Expense >= 16000000 THEN 'High Expense'
        WHEN Total_Expense >= 14000000 THEN 'Medium Expense'
        ELSE 'Low Expense'
    END AS Expense_Level,

    ROUND(
        (Total_Expense / SUM(Total_Expense) OVER ()) * 100,
        2
    ) AS Percentage_of_total_expense

FROM expense_categories
ORDER BY Total_Expense DESC;

-- Key Business Insights:
-- • High Expense categories are Professional Fees and Equipment.
--   Together, they contribute 25.38% of total expenses.
-- • Professional Fees is the largest individual category at
--   12.70%.
-- • Equipment contributes 12.68%.
-- • Medium Expense categories are Travel, Office Rent, and
--   Other Operating Expense, contributing 33.43% combined.
-- • Low Expense categories contribute 41.19% combined.
--
-- Management Summary:
-- The expense structure is relatively distributed across
-- categories. The Low Expense group contributes the largest
-- combined share, while Professional Fees is the largest
-- individual expense category.


-- ============================================================
-- TASK 6 | Revenue vs Expense & Profit Margin
-- ============================================================
-- Business Question:
-- How much profit does each department generate relative to
-- its revenue, and which departments have higher profit margins?
--
-- Formula:
-- Profit Margin = Profit / Revenue × 100
-- ============================================================

WITH department_financials AS (
    SELECT
        d.department_name,

        SUM(
            CASE
                WHEN t.transaction_type = 'Revenue'
                THEN t.amount
                ELSE 0
            END
        ) AS Revenue,

        SUM(
            CASE
                WHEN t.transaction_type = 'Expense'
                THEN t.amount
                ELSE 0
            END
        ) AS Expense

    FROM departments AS d
    JOIN financial_transactions AS t
        ON t.department_id = d.department_id

    WHERE YEAR(t.transaction_date) = 2025
      AND t.status = 'Completed'

    GROUP BY
        d.department_id,
        d.department_name
),

department_profit AS (
    SELECT
        department_name,
        Revenue,
        Expense,
        Revenue - Expense AS Profit
    FROM department_financials
)

SELECT
    *,
    ROUND(
        (Profit / Revenue) * 100,
        2
    ) AS Profit_Margin

FROM department_profit
ORDER BY Profit_Margin DESC;

-- Key Business Insights:
-- • Research & Development has the highest profit margin at 35.10%.
-- • Human Resources has the lowest margin at 26.44%.
-- • R&D has the highest margin but not the highest absolute profit.
-- • Technology generated the highest absolute profit at ₹85.50 lakh.
-- • The margin gap between R&D and HR is 8.66 percentage points.
--
-- Management Summary:
-- Absolute profit and profit margin measure different aspects of
-- performance. Technology generated the highest profit amount,
-- while R&D generated the highest profit relative to revenue.


-- ============================================================
-- TASK 7 | Business Unit Financial Performance
-- ============================================================
-- Business Question:
-- How does each business unit perform financially?
-- ============================================================

WITH business_unit_financials AS (
    SELECT
        d.business_unit,

        SUM(
            CASE
                WHEN t.transaction_type = 'Revenue'
                THEN t.amount
                ELSE 0
            END
        ) AS Revenue,

        SUM(
            CASE
                WHEN t.transaction_type = 'Expense'
                THEN t.amount
                ELSE 0
            END
        ) AS Expense

    FROM departments AS d
    JOIN financial_transactions AS t
        ON t.department_id = d.department_id

    WHERE YEAR(t.transaction_date) = 2025
      AND t.status = 'Completed'

    GROUP BY d.business_unit
),

business_unit_profit AS (
    SELECT
        *,
        Revenue - Expense AS Profit
    FROM business_unit_financials
)

SELECT
    *,
    ROUND(
        (Profit / Revenue) * 100,
        2
    ) AS Profit_Margin

FROM business_unit_profit
ORDER BY Profit_Margin DESC;

-- Key Business Insights:
-- • Technology has the highest profit margin at 34.59% and the
--   highest absolute profit at approximately ₹1.70 crore.
-- • Operations follows with a 33.89% profit margin and
--   approximately ₹1.65 crore profit.
-- • Corporate has the lowest profit margin at 27.04% and
--   approximately ₹1.23 crore profit.
-- • The margin difference between Technology and Corporate is
--   7.55 percentage points.
--
-- Management Summary:
-- Technology recorded the highest business-unit profit margin,
-- followed by Operations, while Corporate recorded the lowest
-- margin.


-- ============================================================
-- TASK 8 | Top Expense Category Within Each Department
-- ============================================================
-- Business Question:
-- What is the largest expense category within each department?
--
-- DENSE_RANK() is used so that tied categories can both receive
-- Rank 1.
-- ============================================================

WITH department_expenses AS (
    SELECT
        d.department_name,
        t.category AS Expenses_Category,
        SUM(t.amount) AS Total_Expense

    FROM departments AS d
    JOIN financial_transactions AS t
        ON d.department_id = t.department_id

    WHERE YEAR(t.transaction_date) = 2025
      AND t.status = 'Completed'
      AND t.transaction_type = 'Expense'

    GROUP BY
        d.department_name,
        t.category
),

ranked_expenses AS (
    SELECT
        department_name,
        Expenses_Category,
        Total_Expense,

        DENSE_RANK() OVER (
            PARTITION BY department_name
            ORDER BY Total_Expense DESC
        ) AS Expense_Rank

    FROM department_expenses
)

SELECT
    *
FROM ranked_expenses
WHERE Expense_Rank = 1;

-- Key Business Insights:
-- • Equipment is the highest expense category for Customer Support,
--   Operations, and Sales.
-- • Utilities is the highest expense category for Finance.
-- • Professional Fees is the highest category for Human Resources
--   and Marketing.
-- • Marketing is the highest expense category for R&D.
-- • Other Operating Expense is the highest category for Technology.
-- • Sales has the highest top-category expense among the listed
--   departments at approximately ₹29.27 lakh.
--
-- Management Summary:
-- The largest expense driver varies by department. No single
-- expense category dominates every department.


-- ============================================================
-- TASK 9 | Department Financial Health Analysis
-- ============================================================
-- Business Question:
-- Classify departments into Strong, Moderate, or Lower financial
-- health based on predefined profit-margin thresholds.
--
-- Classification Rules:
-- • >= 34.00% → Strong
-- • >= 30.00% → Moderate
-- • < 30.00%  → Lower
-- ============================================================

WITH department_financials AS (
    SELECT
        d.department_name,

        SUM(
            CASE
                WHEN t.transaction_type = 'Revenue'
                THEN t.amount
                ELSE 0
            END
        ) AS Revenue,

        SUM(
            CASE
                WHEN t.transaction_type = 'Expense'
                THEN t.amount
                ELSE 0
            END
        ) AS Expense

    FROM departments AS d
    JOIN financial_transactions AS t
        ON t.department_id = d.department_id

    WHERE YEAR(t.transaction_date) = 2025
      AND t.status = 'Completed'

    GROUP BY d.department_name
),

department_profit AS (
    SELECT
        *,
        Revenue - Expense AS Profit
    FROM department_financials
),

department_margin AS (
    SELECT
        *,
        ROUND(
            (Profit / Revenue) * 100,
            2
        ) AS Profit_Margin
    FROM department_profit
)

SELECT
    *,
    CASE
        WHEN Profit_Margin >= 34.00 THEN 'Strong'
        WHEN Profit_Margin >= 30.00 THEN 'Moderate'
        ELSE 'Lower'
    END AS Financial_Health

FROM department_margin
ORDER BY Profit_Margin DESC;

-- Key Business Insights:
-- Strong:
-- • R&D → 35.10%
-- • Operations → 34.79%
-- • Technology → 34.09%
--
-- Moderate:
-- • Customer Support → 32.99%
-- • Sales → 30.92%
--
-- Lower:
-- • Finance → 27.67%
-- • Marketing → 27.51%
-- • Human Resources → 26.44%
--
-- Management Summary:
-- Under the defined margin thresholds, R&D, Operations, and
-- Technology fall into the Strong category. Customer Support
-- and Sales fall into Moderate, while Finance, Marketing, and
-- Human Resources fall into Lower.


-- ============================================================
-- TASK 10 | Final Management Challenge
-- ============================================================
-- Objective:
-- Prepare a management-level summary of the company's completed
-- 2025 financial transactions.
--
-- The final analysis is divided into:
-- 1. Department Performance
-- 2. Business Unit Performance
-- 3. Department Expense Drivers
-- ============================================================


-- ------------------------------------------------------------
-- TASK 10.1 | Department Performance
-- ------------------------------------------------------------
-- Required fields:
-- • Department
-- • Revenue
-- • Expense
-- • Profit
-- • Profit Margin %
-- • Profit Rank
--
-- Requirement:
-- Highest profit should receive Rank 1.
-- ============================================================

WITH department_financials AS (
    SELECT
        d.department_name,

        SUM(
            CASE
                WHEN t.transaction_type = 'Revenue'
                THEN t.amount
                ELSE 0
            END
        ) AS Revenue,

        SUM(
            CASE
                WHEN t.transaction_type = 'Expense'
                THEN t.amount
                ELSE 0
            END
        ) AS Expense

    FROM departments AS d
    JOIN financial_transactions AS t
        ON t.department_id = d.department_id

    WHERE YEAR(t.transaction_date) = 2025
      AND t.status = 'Completed'

    GROUP BY
        d.department_id,
        d.department_name
),

department_profit AS (
    SELECT
        department_name,
        Revenue,
        Expense,
        Revenue - Expense AS Profit
    FROM department_financials
)

SELECT
    department_name,
    Revenue,
    Expense,
    Profit,

    ROUND(
        (Profit / Revenue) * 100,
        2
    ) AS Profit_Margin,

    DENSE_RANK() OVER (
        ORDER BY Profit DESC
    ) AS Profit_Rank

FROM department_profit
ORDER BY Profit_Rank
LIMIT 1;


-- ------------------------------------------------------------
-- TASK 10.2 | Business Unit Performance
-- ------------------------------------------------------------
-- Required fields:
-- • Business Unit
-- • Revenue
-- • Expense
-- • Profit
-- • Profit Margin %
--
-- Requirement:
-- Order business units from highest to lowest profit margin.
-- ============================================================

WITH business_unit_financials AS (
    SELECT
        d.business_unit,

        SUM(
            CASE
                WHEN t.transaction_type = 'Revenue'
                THEN t.amount
                ELSE 0
            END
        ) AS Revenue,

        SUM(
            CASE
                WHEN t.transaction_type = 'Expense'
                THEN t.amount
                ELSE 0
            END
        ) AS Expense

    FROM departments AS d
    JOIN financial_transactions AS t
        ON t.department_id = d.department_id

    WHERE YEAR(t.transaction_date) = 2025
      AND t.status = 'Completed'

    GROUP BY d.business_unit
),

business_unit_profit AS (
    SELECT
        *,
        Revenue - Expense AS Profit
    FROM business_unit_financials
)

SELECT
    *,
    ROUND(
        (Profit / Revenue) * 100,
        2
    ) AS Profit_Margin

FROM business_unit_profit
ORDER BY Profit_Margin DESC;


-- ------------------------------------------------------------
-- TASK 10.3 | Department Expense Driver
-- ------------------------------------------------------------
-- Required fields:
-- • Department
-- • Top Expense Category
-- • Total Expense
-- • Expense Rank
--
-- Requirement:
-- Return only the #1 expense category for each department.
-- ============================================================

WITH department_expenses AS (
    SELECT
        d.department_name,
        t.category AS Expenses_Category,
        SUM(t.amount) AS Total_Expense

    FROM departments AS d
    JOIN financial_transactions AS t
        ON d.department_id = t.department_id

    WHERE YEAR(t.transaction_date) = 2025
      AND t.status = 'Completed'
      AND t.transaction_type = 'Expense'

    GROUP BY
        d.department_name,
        t.category
),

ranked_expenses AS (
    SELECT
        department_name,
        Expenses_Category,
        Total_Expense,

        DENSE_RANK() OVER (
            PARTITION BY department_name
            ORDER BY Total_Expense DESC
        ) AS Expense_Rank

    FROM department_expenses
)

SELECT
    *
FROM ranked_expenses
WHERE Expense_Rank = 1;


-- ============================================================
-- FINAL MANAGEMENT SUMMARY
-- ============================================================
-- • Highest Profit Department:
--   Technology generated approximately ₹85.50 lakh profit with
--   a 34.09% profit margin.
--
-- • Highest Profit Margin Department:
--   Research & Development recorded the highest profit margin
--   at 35.10%, showing that highest absolute profit and highest
--   margin can come from different departments.
--
-- • Highest-Margin Business Unit:
--   Technology recorded a 34.59% profit margin and approximately
--   ₹1.70 crore profit.
--
-- • Major Company-Wide Expense Category:
--   Professional Fees was the largest expense category at
--   approximately ₹1.67 crore, contributing 12.70% of total
--   expenses.
--
-- • Department-Level Expense Drivers:
--   Equipment was the top expense for Customer Support, Operations,
--   and Sales.
--   Professional Fees was the top expense for Human Resources
--   and Marketing.
--   Utilities was the top expense for Finance.
--   Marketing was the top expense for R&D.
--   Other Operating Expense was the top expense for Technology.
--
-- ============================================================
-- END OF ANALYSIS
-- ============================================================
