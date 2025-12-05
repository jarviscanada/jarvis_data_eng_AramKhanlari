# Introduction

This project aims to solve business questions to support the growth of London Gift Shop (LGS). LGS is a UK-based online retailer specializing in wholesale giftware. Despite operating for over a decade, the shop's sales are not improving, and they want to analyze their data to make stronger business decisions.

Jarvis Consulting delivered a proof of concept (PoC) to improve data processing and analysis. The team was not allowed to work in the LGS Azure environment; however, after removing sensitive information, the data was transferred to the Jarvis servers by the LGS IT team. As a Data Engineer on the Jarvis side, I extracted, transformed, and analyzed transactional data to understand patterns and segment customers. The LGS marketing team may use these analytical results - recency, frequency, monetary (RFM) scores, monthly trends, and cohort analyzes to:
# Implementation
## Project Architecture

The PoC environment is isolated from LGS's Azure setup. Data ingestion occurs via a dumped SQL file (retail.sql) or CSV export. This file is free of personal information as a part of ETL guidelines. All processing and visualizations are executed in a Jupyter Notebook, and delivered via GitHub.

## Dataset Information
The LGS IT team provided CSV file with data of gift purchases between 01/12/2009 and 09/12/2011 into a SQL file.

- **invoice_no**: Invoice number. Nominal. A 6-digit integral number uniquely assigned to each transaction. If this code starts with the letter 'c', it indicates a cancellation.
- **stock_code**: Product (item) code. Nominal. A 5-digit integral number uniquely assigned to each product.
- **description**: Product (item) name. Nominal.
- **quantity**: The quantities of each product (item) per transaction. Numeric.
- **invoice_date**: Invoice date and time. Numeric. The day and time when a transaction was generated.
- **unit_price**: Unit price. Numeric. Product price per unit in sterling.
- **customer_id**: Customer number. Nominal. A 5-digit integral number uniquely assigned to each customer.
- **country**: Country name. Nominal. The name of the country where a customer resides.

## Data Analytics and Wrangling

- Here is the [Notebook for Data Wrangling and Analytics]( ./python_data_wrangling/retail_data_analytics_wrangling.ipynb)

A Recency-Frequency-Monetary (RFM) model was used to classify customers based on recent activity, purchase frequency, and total spending. Below are four key segments with high strategic importance.

### Champions (834 customers)
- **Recency**: 6.8 days

- **Frequency**: 437.7 purchases

- **Monetary**: £10,564 spent

**Insight**: Most valuable and highly engaged customers.

**Recommendation**: Maintain loyalty through exclusive offers and VIP experiences.

### Loyal Customers (1,161 customers)

- **Recency**: 63.7 days

- **Frequency**: 230 purchases

- **Monetary**: £3,888 spent

**Insight**: Strong recurring buyers who continue to engage.

**Recommendation**: Reward with loyalty programs, early access, and personalised bundles.

### At Risk (805 customers)

- **Recency**: 392 days

- **Frequency**: 72 purchases

- **Monetary**: £1,199 spent

**Insight**: Previously valuable customers who haven't purchased in a long time.

**Recommendation**: Win-back campaigns with targeted incentives and product-based reactivation offers.

### Hibernating (1,468 customers)

- **Recency**: 459 days

- **Frequency**: 15.4 purchases

- **Monetary**: £311 spent

**Insight**: Large inactive group with minimal recent engagement.

**Recommendation**: Broad, low-cost promotions such as seasonal discounts or re-introduction campaigns.

## Improvements

- **Interactive Dashboard** 
  - Build a Power BI or Tableau dashboard to visualise RFM segments, sales trends, and churn risks, allowing stakeholders to explore insights in real time.

- **Automated Data Pipeline**
  - Implement an ETL/ELT process to automatically ingest, clean, and update data. Schedule regular refreshes so RFM scores and metrics stay up-to-date.

- **Predictive Models**
  - Add churn prediction and Customer Lifetime Value (CLV) models to anticipate customer behaviour and prioritise reactivation or retention efforts.

- **Automated Alerts & Recommendations**
  - Enable the system to flag declining customers or segments and propose targeted actions e.g., win-back offers for At Risk, loyalty rewards for top customers.