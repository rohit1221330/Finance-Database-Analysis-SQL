# Finance Database Analysis — SQL

## Project Overview

This project analyzes a company's financial transactions using SQL and MySQL.

The objective is to evaluate departmental financial performance, revenue and expense trends, profitability, expense drivers, and overall financial health.

The project uses a realistic financial transaction dataset containing revenue and expense records across multiple departments and business units for 2025.

---

## Business Objectives

The analysis focuses on:

* Measuring revenue, expenses, and profit by department
* Analyzing monthly revenue and expense trends
* Identifying major expense categories
* Ranking departments based on profitability
* Calculating profit margins
* Comparing business unit performance
* Identifying the largest expense category within each department
* Classifying departments based on financial health
* Generating management-level financial insights

---

## Database Structure

The database contains two main tables:

### 1. Departments

| Column            | Description                     |
| ----------------- | ------------------------------- |
| `department_id`   | Unique department ID            |
| `department_name` | Department name                 |
| `business_unit`   | Business unit of the department |

### 2. Financial Transactions

| Column             | Description                      |
| ------------------ | -------------------------------- |
| `transaction_id`   | Unique transaction ID            |
| `transaction_date` | Date of transaction              |
| `department_id`    | Related department               |
| `transaction_type` | Revenue or Expense               |
| `category`         | Financial transaction category   |
| `amount`           | Transaction amount               |
| `payment_method`   | Payment method                   |
| `status`           | Completed, Pending, or Cancelled |

### Relationship

`departments.department_id` → `financial_transactions.department_id`

---

## Dataset

The project uses:

* **8 Departments**
* **2,000 Financial Transactions**
* **2025 Financial Data**
* Revenue and Expense transactions
* Multiple financial categories
* Completed, Pending, and Cancelled transactions

For the analysis, only **Completed transactions from 2025** were considered.

---

# Analysis Performed

## 1. Department Financial Performance

Calculated:

* Revenue
* Expense
* Profit
* Profit Margin

### Formula

```text
Profit = Revenue - Expense

Profit Margin = (Profit / Revenue) × 100
```

### Key Result

Technology generated the highest departmental profit:

* Revenue: **₹2.51 crore**
* Expense: **₹1.65 crore**
* Profit: **₹85.50 lakh**
* Profit Margin: **34.09%**

---

## 2. Monthly Financial Trend

Analyzed monthly revenue and expenses across 2025.

### Key Findings

* Highest monthly revenue: **December — ₹1.91 crore**
* Lowest monthly revenue: **January — ₹1.26 crore**
* Highest monthly expense: **September — ₹1.31 crore**
* Lowest monthly expense: **February — ₹88.47 lakh**

The analysis shows that higher revenue months did not always have proportionally higher expenses.

---

## 3. Expense Category Analysis

Analyzed total company-wide expenses by category.

### Top Expense Categories

| Expense Category        | Total Expense | Contribution |
| ----------------------- | ------------: | -----------: |
| Professional Fees       |      ₹1.67 Cr |       12.70% |
| Equipment               |      ₹1.67 Cr |       12.68% |
| Travel                  |      ₹1.48 Cr |       11.25% |
| Office Rent             |      ₹1.48 Cr |       11.22% |
| Other Operating Expense |      ₹1.44 Cr |       10.96% |

Professional Fees was the largest expense category, contributing **12.70%** of total expenses.

---

## 4. Department Profitability Ranking

Departments were ranked based on absolute profit using `DENSE_RANK()`.

| Rank | Department             |      Profit |
| ---: | ---------------------- | ----------: |
|    1 | Technology             | ₹85.50 Lakh |
|    2 | Research & Development | ₹84.72 Lakh |
|    3 | Operations             | ₹84.64 Lakh |
|    4 | Customer Support       | ₹80.47 Lakh |
|    5 | Sales                  | ₹74.22 Lakh |
|    6 | Marketing              | ₹65.16 Lakh |
|    7 | Human Resources        | ₹61.76 Lakh |
|    8 | Finance                | ₹61.69 Lakh |

---

## 5. Expense Classification

Expense categories were classified using `CASE` based on total expense:

```text
High Expense    >= ₹16,000,000
Medium Expense  >= ₹14,000,000
Low Expense     < ₹14,000,000
```

### Classification Summary

* High Expense categories: **2**
* Medium Expense categories: **3**
* Low Expense categories: **4**

Professional Fees and Equipment were classified as High Expense categories.

---

## 6. Revenue vs Expense & Profit Margin

Calculated department-level profit margins to understand profitability relative to revenue.

### Highest and Lowest Margins

* Highest: **Research & Development — 35.10%**
* Lowest: **Human Resources — 26.44%**

This shows that the department with the highest absolute profit was not the same as the department with the highest profit margin.

---

## 7. Business Unit Financial Performance

Departments were grouped into business units and analyzed using Revenue, Expense, Profit, and Profit Margin.

| Business Unit |  Revenue |  Expense |   Profit | Profit Margin |
| ------------- | -------: | -------: | -------: | ------------: |
| Technology    | ₹4.92 Cr | ₹3.22 Cr | ₹1.70 Cr |        34.59% |
| Operations    | ₹4.87 Cr | ₹3.22 Cr | ₹1.65 Cr |        33.89% |
| Commercial    | ₹4.77 Cr | ₹3.38 Cr | ₹1.39 Cr |        29.23% |
| Corporate     | ₹4.57 Cr | ₹3.33 Cr | ₹1.23 Cr |        27.04% |

---

## 8. Top Expense Category Within Each Department

Used `DENSE_RANK()` with `PARTITION BY` to identify the largest expense category for every department.

| Department             | Top Expense Category    | Total Expense |
| ---------------------- | ----------------------- | ------------: |
| Customer Support       | Equipment               |   ₹28.54 Lakh |
| Finance                | Utilities               |   ₹25.16 Lakh |
| Human Resources        | Professional Fees       |   ₹28.19 Lakh |
| Marketing              | Professional Fees       |   ₹27.57 Lakh |
| Operations             | Equipment               |   ₹24.76 Lakh |
| Research & Development | Marketing               |   ₹23.20 Lakh |
| Sales                  | Equipment               |   ₹29.27 Lakh |
| Technology             | Other Operating Expense |   ₹24.76 Lakh |

The analysis shows that expense drivers differ significantly across departments.

---

## 9. Department Financial Health

Departments were classified using profit margin:

```text
Strong    >= 34%
Moderate  >= 30% and < 34%
Lower     < 30%
```

### Results

* **Strong:** 3 departments
* **Moderate:** 2 departments
* **Lower:** 3 departments

The highest margin was recorded by Research & Development at **35.10%**, while Human Resources had the lowest at **26.44%**.

---

# Management Summary

Based on the completed 2025 financial transactions:

1. **Technology generated the highest departmental profit of ₹85.50 lakh**, with a profit margin of 34.09%.

2. **Research & Development recorded the highest profit margin at 35.10%**, showing that the department with the highest absolute profit and the department with the highest margin were different.

3. **Technology was the highest-margin business unit at 34.59%**, generating approximately **₹1.70 crore profit**.

4. **Professional Fees was the largest company-wide expense category**, with total expenses of approximately **₹1.67 crore**, contributing 12.70% of total expenses.

5. **Department-level expense drivers varied across the organization.** Equipment was the largest expense for Customer Support, Operations, and Sales, while Professional Fees was the largest for Human Resources and Marketing. Other departments had different leading expense categories.

---

# SQL Skills Demonstrated

This project demonstrates practical SQL skills including:

* `SELECT`
* `WHERE`
* `GROUP BY`
* `ORDER BY`
* `CASE`
* `JOIN`
* `CTE`
* `SUM()`
* Aggregate Functions
* Calculated Columns
* `DENSE_RANK()`
* `PARTITION BY`
* Window Functions
* Profit & Margin Calculations
* Financial Data Analysis
* Business Insight Generation

---

# Tools Used

* **MySQL**
* **SQL**
* **GitHub**

---

# Project Structure

```text
Finance-Database-Analysis/
│
├── finance_database.sql
├── finance_analysis.sql
└── README.md
```

### `finance_database.sql`

Contains the database schema and financial transaction dataset.

### `finance_analysis.sql`

Contains SQL queries used for financial analysis and business insights.

### `README.md`

Contains project documentation, analysis, results, and management summary.

---

# How to Run

### 1. Create the Database

Run:

```sql
SOURCE finance_database.sql;
```

### 2. Select the Database

```sql
USE finance_analysis;
```

### 3. Run the Analysis

Execute `finance_analysis.sql` in MySQL Workbench or another MySQL-compatible SQL environment.

---

# Key Takeaways

This project demonstrates how SQL can be used to move from raw financial transaction data to management-level insights.

The analysis covers:

**Raw Transactions → Revenue & Expense Analysis → Profitability → Margin Analysis → Expense Drivers → Financial Health → Management Insights**

The project is designed to demonstrate practical SQL and financial analysis skills relevant to **Financial Analyst and Data Analyst roles**.
