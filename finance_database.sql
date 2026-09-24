-- =========================================================
-- FINANCE DATABASE ANALYSIS PROJECT
-- Synthetic Financial Dataset
-- MySQL 8+
-- =========================================================

DROP DATABASE IF EXISTS finance_analysis;

CREATE DATABASE finance_analysis;

USE finance_analysis;


-- =========================================================
-- 1. DEPARTMENTS TABLE
-- =========================================================

CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    business_unit VARCHAR(100) NOT NULL
);


INSERT INTO departments
(department_id, department_name, business_unit)
VALUES
(1, 'Sales', 'Commercial'),
(2, 'Marketing', 'Commercial'),
(3, 'Finance', 'Corporate'),
(4, 'Human Resources', 'Corporate'),
(5, 'Operations', 'Operations'),
(6, 'Technology', 'Technology'),
(7, 'Customer Support', 'Operations'),
(8, 'Research & Development', 'Technology');


-- =========================================================
-- 2. FINANCIAL TRANSACTIONS TABLE
-- =========================================================

CREATE TABLE financial_transactions (
    transaction_id INT PRIMARY KEY,
    transaction_date DATE NOT NULL,
    department_id INT NOT NULL,
    transaction_type ENUM('Revenue', 'Expense') NOT NULL,
    category VARCHAR(100) NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    payment_method VARCHAR(50),
    status ENUM('Completed', 'Pending', 'Cancelled') NOT NULL,

    FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
);


-- =========================================================
-- 3. VARIABLES
-- =========================================================

SET @row_num = 0;
SET SESSION cte_max_recursion_depth = 5000;


-- =========================================================
-- 4. GENERATE 2,000 REALISTIC FINANCIAL TRANSACTIONS
-- =========================================================

INSERT INTO financial_transactions
(
    transaction_id,
    transaction_date,
    department_id,
    transaction_type,
    category,
    amount,
    payment_method,
    status
)

WITH RECURSIVE numbers AS
(
    SELECT 1 AS n

    UNION ALL

    SELECT n + 1
    FROM numbers
    WHERE n < 2000
)

SELECT
    n AS transaction_id,

    DATE_ADD(
        '2025-01-01',
        INTERVAL FLOOR(RAND(n * 17) * 365) DAY
    ) AS transaction_date,


    -- Department
    FLOOR(RAND(n * 23) * 8) + 1 AS department_id,


    -- Revenue / Expense
    CASE
        WHEN RAND(n * 31) < 0.42
            THEN 'Revenue'
        ELSE 'Expense'
    END AS transaction_type,


    -- Category
    CASE

        -- Revenue categories
        WHEN RAND(n * 31) < 0.42 THEN
            CASE FLOOR(RAND(n * 41) * 5)
                WHEN 0 THEN 'Product Sales'
                WHEN 1 THEN 'Service Revenue'
                WHEN 2 THEN 'Subscription Revenue'
                WHEN 3 THEN 'Consulting Revenue'
                ELSE 'Other Revenue'
            END

        -- Expense categories
        ELSE
            CASE FLOOR(RAND(n * 53) * 9)
                WHEN 0 THEN 'Employee Salaries'
                WHEN 1 THEN 'Marketing'
                WHEN 2 THEN 'Office Rent'
                WHEN 3 THEN 'Technology'
                WHEN 4 THEN 'Travel'
                WHEN 5 THEN 'Utilities'
                WHEN 6 THEN 'Professional Fees'
                WHEN 7 THEN 'Equipment'
                ELSE 'Other Operating Expense'
            END
    END AS category,


    -- Amount
    CASE

        -- Revenue amounts
        WHEN RAND(n * 31) < 0.42 THEN
            ROUND(
                25000 + RAND(n * 67) * 475000,
                2
            )

        -- Expense amounts
        ELSE
            ROUND(
                5000 + RAND(n * 71) * 245000,
                2
            )

    END AS amount,


    -- Payment Method
    CASE FLOOR(RAND(n * 83) * 5)
        WHEN 0 THEN 'Bank Transfer'
        WHEN 1 THEN 'Credit Card'
        WHEN 2 THEN 'UPI'
        WHEN 3 THEN 'Cheque'
        ELSE 'Cash'
    END AS payment_method,


    -- Transaction Status
    CASE
        WHEN RAND(n * 97) < 0.88
            THEN 'Completed'
        WHEN RAND(n * 97) < 0.96
            THEN 'Pending'
        ELSE 'Cancelled'
    END AS status

FROM numbers;


-- =========================================================
-- 5. BASIC VALIDATION
-- =========================================================

SELECT COUNT(*) AS total_transactions
FROM financial_transactions;


SELECT COUNT(*) AS total_departments
FROM departments;


-- =========================================================
-- 6. CHECK TRANSACTION TYPES
-- =========================================================

SELECT
    transaction_type,
    COUNT(*) AS transaction_count,
    SUM(amount) AS total_amount
FROM financial_transactions
GROUP BY transaction_type;


-- =========================================================
-- 7. CHECK STATUS
-- =========================================================

SELECT
    status,
    COUNT(*) AS transaction_count
FROM financial_transactions
GROUP BY status;


-- =========================================================
-- 8. CHECK DEPARTMENT DATA
-- =========================================================

SELECT
    d.department_id,
    d.department_name,
    d.business_unit,
    COUNT(ft.transaction_id) AS transaction_count
FROM departments d
LEFT JOIN financial_transactions ft
    ON d.department_id = ft.department_id
GROUP BY
    d.department_id,
    d.department_name,
    d.business_unit
ORDER BY d.department_id;


-- =========================================================
-- 9. SAMPLE DATA
-- =========================================================
SELECT *
FROM financial_transactions
LIMIT 20;