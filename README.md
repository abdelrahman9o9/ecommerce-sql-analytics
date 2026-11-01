# E-Commerce SQL Analytics

## Project Overview

This project analyzes a synthetic E-Commerce database using PostgreSQL to extract business insights and evaluate operational performance through SQL queries.

The analysis covers sales performance, customer behavior, product performance, order management, payment operations, shipping operations, and data quality.

The project demonstrates practical SQL skills commonly used in Data Analysis and provides a foundation for further development toward Data Engineering.

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
| `customers` | Customer information |
| `products` | Product details and stock |
| `categories` | Product categories |
| `orders` | Customer orders and order statuses |
| `order_items` | Products, quantities, and historical prices within each order |
| `payments` | Payment amounts, methods, and statuses |
| `shipping` | Shipping and delivery information |

## Analysis Scope

### 1. Sales Performance Analysis

- Total orders and cancelled orders
- Total order value
- Valid sales value
- Paid, pending, and failed payment values
- Average Order Value (AOV)

### 2. Customer Analysis

- Customer spending
- Order frequency
- Top customers
- Customer rankings

### 3. Product & Category Analysis

- Best-selling products
- Product revenue
- Category performance
- Unsold products
- Product ranking within each category

### 4. Order Analysis

- Total, valid, and cancelled orders
- Order status distribution
- Cancellation rate
- Order details and order value
- Order and payment consistency
- Identification of orders requiring payment review

### 5. Payment Analysis

- Payment status distribution
- Payment amount and average amount by status
- Payment method performance
- Paid, pending, and failed payment counts by method
- Missing payment records

### 6. Shipping Analysis

- Shipping status distribution
- Delivered shipments and delivery rate
- Shipping duration per shipment
- Average, longest, and shortest shipping duration
- Missing shipping records

### 7. Data Quality Analysis

- Completeness checks for missing values
- Uniqueness checks for duplicate records and database constraints
- Validity checks for numeric values, timestamps, and categorical values
- Referential integrity checks for orphan records
- Consistency checks between orders, payments, and shipping
- Comparison of payment amounts with calculated order values

## Repository Structure

```text
ecommerce-sql-analytics/
│
├── 01_sales_performance.sql
├── 02_customer_analysis.sql
├── 03_product_category_analysis.sql
├── 04_order_analysis.sql
├── 05_payment_analysis.sql
├── 06_shipping_analysis.sql
├── 07_data_quality_analysis.sql
└── README.md
```

## Business Metric Definitions

| Metric | Definition |
|---|---|
| Total Order Value | Sum of all order item values, including cancelled orders |
| Valid Sales Value | Sum of order item values excluding cancelled orders |
| Paid Revenue | Sum of payments with a paid status |
| Pending Payment Value | Sum of payments with a pending status |
| Failed Payment Value | Sum of payments with a failed status |
| Average Order Value (AOV) | Valid Sales Value divided by the number of distinct non-cancelled orders |
| Total Spent | Sum of a customer's non-cancelled order item values |
| Customer AOV | Customer's total spent divided by their number of non-cancelled orders |
| Customer Rank | Customer ranking based on total spending, using `DENSE_RANK()` |
| Units Sold | Total quantity sold for each product, excluding cancelled orders |
| Total Orders per Product | Number of distinct non-cancelled orders containing each product |
| Total Product Revenue | Sum of quantity multiplied by historical unit price for each product |
| Product Rank | Product ranking based on revenue within its category, using `DENSE_RANK()` |
| Cancellation Rate | Cancelled orders divided by total orders, multiplied by 100 |
| Delivered Shipments | Number of shipments with a `delivered` status |
| Delivery Rate | Delivered shipments divided by total shipments, multiplied by 100 |
| Shipping Duration | Time difference between `shipped_at` and `delivered_at` for delivered shipments |
| Average Shipping Duration | Average shipping duration across delivered shipments |
| Longest Shipping Duration | Maximum shipping duration among delivered shipments |
| Shortest Shipping Duration | Minimum shipping duration among delivered shipments |

Order item values are calculated using:

```sql
quantity * unit_price
```

Historical transaction prices from `order_items` are used instead of current product prices to preserve the prices recorded when orders were placed.

Payment consistency is evaluated by comparing order statuses with payment statuses using predefined business rules. This classification does not confirm that payment was collected.

## Key Findings

### Sales & Payments

- The dataset contains 15 orders: 13 non-cancelled and 2 cancelled.
- Total Order Value: 19,110.00.
- Valid Sales Value: 17,700.00.
- Paid Revenue: 15,750.00.
- Pending Payment Value: 1,950.00.
- Failed Payment Value: 1,410.00.
- Average Order Value: approximately 1,361.54.
- Payment status distribution: 10 paid, 3 pending, and 2 failed.

### Customers & Products

- Customer spending and rankings were calculated using non-cancelled orders.
- Products with no sales were retained in the analysis.
- Product rankings were calculated independently within each category.
- Historical order item prices were used for revenue calculations.

### Shipping

- Shipping status distribution: 7 delivered, 3 in transit, 3 pending, and 2 cancelled.
- Delivery Rate: 46.67% (7 delivered shipments out of 15).
- All 7 delivered shipments have a shipping duration of 2 days in the current dataset.
- Every order has a corresponding shipping record.

### Data Quality

- Five payment records have missing payment dates: three pending and two failed payments.
- Missing shipping information is associated with pending or cancelled shipments.
- No duplicate customer emails or multiple payment or shipping records per order were found.
- No negative product prices, stock quantities, payment amounts, or unit prices were found.
- No non-positive order item quantities were found.
- No invalid shipping timestamp order was identified.
- No orphan records were found in the tested foreign key relationships.
- All observed order, payment, and shipping status combinations matched the business rules used in the analysis.
- Payment amounts matched calculated order values for all 15 orders.
- No data was modified during the data quality analysis. Missing values were investigated rather than automatically replaced.

## Limitations & Assumptions

- The database contains a small synthetic dataset intended for SQL practice and portfolio development.
- The current dataset contains one payment record and one shipping record per order.
- Payment consistency checks evaluate status alignment; they do not independently verify successful fund collection.
- Missing payment dates for failed transactions require further business context before they can be classified as errors.
- Formal allowed-value definitions for categorical fields were not available.
- Profit analysis is outside the current scope because product cost data is not available.
- The delivery rate represents the current proportion of delivered shipments, not necessarily the final delivery success rate.

## Author

Abdelrahman Mohamed

GitHub: [abdelrahman9o9](https://github.com/abdelrahman9o9)