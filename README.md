# Olist E-commerce SQL Analysis

## Project Overview

This project analyzes customer behavior and revenue patterns for Olist, a Brazilian e-commerce marketplace, using advanced SQL techniques. The goal was to build reusable analytical tables and answer business-relevant questions related to revenue concentration, customer lifetime value (LTV), geographic performance, and customer retention.

Using multi-level aggregation, window functions, and segmentation, the analysis surfaces how revenue is distributed across customers and regions, identifies high-value customer cohorts, and highlights opportunities for growth and retention. The project emphasizes scalable query design and mirrors real-world analytical workflows commonly used in data analytics roles.

## Data Model & Baseline Tables

This analysis utilized a Brazilian e-commerce public dataset of orders made at Olist Store. The dataset contains information on 100k orders from 2016 to 2018 made across multiple marketplaces in Brazil and can be found here:  
https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce/data

Specifically, this project used the `olist_order_payments_dataset`, `olist_orders_dataset`, and `olist_order_customer_dataset` tables.

I first created two “baseline tables” to serve as the foundation of the analysis: one order-level and one customer-level.

The query creating the order-level view (found in `order_metrics_view.sql`) started by collapsing/summing the payment table to the order level, as multiple payments could be made for a single order. This order/order amount sub-table was then joined with the orders and customers tables, and various relevant order attributes were selected and calculated. The resulting order-level view contains:

- Order ID  
- Customer ID (each order has a unique customer ID, even if made by the same customer)  
- Customer unique ID (identifies unique individuals across multiple orders/customer IDs)  
- Order amount  
- Customer state  
- Order purchase timestamp  
- Order quarter (quarter of the year the purchase was made)

From there, the customer-level baseline table was created (found in `customer_metrics.sql`). This table built off of the order-level view by collapsing it to the unique customer ID level. Additional metrics, ranks, aggregates, and attributes were calculated to enable downstream analysis. The final customer-level table contains:

- Customer unique ID  
- Average order value  
- Order count  
- Realized cost (total spend across all customer orders)  
- First purchase date  
- Last purchase date  
- Active period (first purchase date to last purchase date)  
- Repeat customer flag (repeat vs one-off)  
- LTV rank (overall realized cost rank)  
- Segment rank (LTV rank within repeat vs non-repeat segments)

These baseline tables were reused across all subsequent analyses.

---

## Key Questions and Analysis

After building the analytical foundation, the following key questions were explored—two at the order level (`order_level_insights.sql`) and two at the customer level (`customer_level_insights.sql`):

- Which states bring in the most revenue?
- Which times of the year (quarters) tend to have the highest revenue?
- What is the distribution of customers and revenue? How much do top customers contribute relative to the rest?
- What percent of customers are repeat customers, and how do repeat and non-repeat customers compare?

The main insights from each analysis are summarized below.

---

## State-Level Analysis

São Paulo was the highest revenue-earning state, making up **37.47% of all revenue**, despite having the **smallest average order amount** of all 27 states. This indicates that consumers in São Paulo tend to make smaller but more frequent purchases relative to other states.

The top three states—São Paulo, Rio de Janeiro, and Minas Gerais—account for **62.56% of total revenue**. These states ranked 27th, 21st, and 24th respectively in average order size, further indicating that higher revenue is driven more by order volume than order size.

Roraima generated the smallest share of revenue at **0.06%**, which aligns with expectations as it is Brazil’s least populous state.

### Revenue Share by State (Top States)

| State | % of Total Revenue |
|------|-------------------|
| São Paulo | 37.47% |
| Rio de Janeiro | 14.12% |
| Minas Gerais | 10.97% |
| All Other States | 37.44% |

---

## Quarter Analysis

Across the three years of data, **Quarter 2** generated the highest share of revenue at **30.36%**, followed by Quarter 1 (25.91%) and Quarter 3 (25.54%). Quarter 4 generated the lowest share of revenue at **18.19%**.

### Revenue Share by Quarter

| Quarter | % of Revenue |
|--------|--------------|
| Q1 | 25.91% |
| Q2 | 30.36% |
| Q3 | 25.54% |
| Q4 | 18.19% |

---

## Customer Distribution Analysis

Customer revenue contribution was highly skewed toward top customers.

- The **top 5% of customers** accounted for **27.04% of total revenue**.
- The **top 10% of customers** accounted for **38.52% of total revenue**.
- Revenue was heavily concentrated among higher-spending customers despite similar order counts across customer segments.

Each customer quartile contributed the following shares of revenue:

| Customer Quartile | % of Revenue | Avg Order Value (R$) | Avg Order Count |
|------------------|-------------|---------------------|----------------|
| Top 1–25% | 59.65% | 397.48 | 26,214 |
| 26–50% | 21.23% | 141.47 | 24,808 |
| 51–75% | 12.57% | 83.77 | 24,338 |
| Bottom 76–100% | 6.55% | 43.66 | 24,080 |

While the average number of orders per quartile was relatively similar, revenue differences were driven primarily by differences in average order value.

---

## Repeat Customer Analysis

Only **3.12% of customers** were repeat customers (customers who placed more than one order), representing **2,997 customers**.

- The average number of orders per customer across the dataset was **2.12**.
- Repeat customers spent slightly less per order on average (R$148.50) than non-repeat customers (R$161.82), though this comparison is less meaningful due to the highly imbalanced customer distribution.
- Repeat customers had an average active period of **87.31 days** between their first and last purchase.

### Repeat vs One-Off Customers

| Segment | % of Customers | Avg Order Value (R$) | Avg Orders |
|--------|----------------|---------------------|------------|
| Repeat | 3.12% | 148.50 | 2.12 |
| One-off | 96.88% | 161.82 | 1.00 |

---

## Technical Highlights

This analysis leverages several advanced SQL concepts, including:

- Common Table Expressions (CTEs)
- Window functions (`RANK`, `NTILE`, cumulative sums)
- Multi-level aggregation across payments, orders, and customers
- Segmentation and cohort-style analysis
- Reusable views for analytical workflows

---

## Next Steps / Applications

This analysis provides insights into orders, revenue, and customer behavior that could inform various business decisions:

- High-value states were identified and could be targeted for increased sales or strategic expansion.
- High-value customer cohorts were identified and could be targeted for retention or upsell initiatives.
- Low customer retention was observed, suggesting opportunities to reduce churn through targeted marketing or loyalty programs.

Additionally, the baseline tables created in this analysis enable many further explorations. For example, customer- or order-level tables could be loaded into a data visualization tool (e.g., Excel or a BI tool) to create visual dashboards. Further analyses could explore year-over-year or quarter-over-quarter growth, customer acquisition and retention cohorts, or incorporate additional tables from the dataset to surface new insights.

