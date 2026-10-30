# E-Commerce SQL Analytics

## Project Overview

This project analyzes an E-Commerce database using PostgreSQL to extract business insights through SQL queries.

The main objective is to analyze sales performance, customer behavior, product performance, payments, orders, and shipping operations.

The project demonstrates practical SQL skills used in Data Analysis and provides a foundation for further development toward Data Engineering.

## Tools & Technologies

- PostgreSQL
- pgAdmin 4
- SQL
- Visual Studio Code
- Git & GitHub

## Database Structure

The database contains seven tables:

| Table | Description |
|---|---|
| customers | Customer information |
| products | Product details and stock |
| categories | Product categories |
| orders | Customer orders and order statuses |
| order_items | Products and quantities within each order |
| payments | Payment amounts, methods, and statuses |
| shipping | Shipping and delivery information |

## Analysis Scope

The project is organized into the following analytical areas:

1. **Sales Performance Analysis**
   - Total orders and cancelled orders
   - Total order value
   - Valid sales value
   - Paid, pending, and failed payment values
   - Average Order Value (AOV)

2. **Customer Analysis**
   - Customer spending
   - Order frequency
   - Top customers
   - Customer rankings

3. **Product & Category Analysis**
   - Best-selling products
   - Product revenue
   - Category performance
   - Unsold products
   - Low-stock products

4. **Order Analysis**
   - Order status distribution
   - Cancellation rate
   - Unpaid orders
   - Order and payment consistency

5. **Payment Analysis**
   - Payment status distribution
   - Payment method performance
   - Missing payment records

6. **Shipping Analysis**
   - Shipping status distribution
   - Delivery performance
   - Shipping duration
   - Missing shipping records

7. **Data Quality Analysis**
   - Missing and inconsistent data
   - Order value and payment discrepancies
   - Data validation checks

## Repository Structure

```text
ecommerce-sql-analytics/
│
├── 01_sales_performance.sql
├── 02_customer_analysis.sql
├── README.md
└── ...
```

## Business Metric Definitions

| Metric | Definition |
|---|---|
| Total Order Value | Sum of all order item values, including cancelled orders |
| Valid Sales Value | Sum of order item values excluding cancelled orders |
| Paid Revenue | Sum of payments with a paid status |
| Pending Payment Value | Sum of payments with a pending status |
| Failed Payment Value | Sum of payments with a failed status |
| Average Order Value (AOV) | Valid Sales Value divided by the number of non-cancelled orders |
| Total Spent | Sum of a customer's non-cancelled order item values |
| Customer AOV | Customer's total spent divided by their number of non-cancelled orders |
| Customer Rank | Customer ranking based on total spending, using DENSE_RANK() |

Order item values are calculated using:

```sql
quantity * unit_price
```

Historical transaction prices from `order_items` are used instead of current product prices.

## Current Progress

- [x] Sales Performance Overview
- [x] Customer Analysis
- [ ] Product & Category Analysis
- [ ] Order Analysis
- [ ] Payment Analysis
- [ ] Shipping Analysis
- [ ] Data Quality Analysis

## Important Notes

- Cancelled orders are excluded from Valid Sales Value and AOV.
- Pending and failed payments are not included in Paid Revenue.
- Order Value and Paid Revenue represent different business metrics.
- Profit analysis is outside the current scope because product cost data is not available.
- The database is a small synthetic dataset intended for SQL practice and portfolio development.

## Author

Abdelrahman Mohamed

GitHub: [abdelrahman9o9](https://github.com/abdelrahman9o9)