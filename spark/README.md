# Introduction

This project focuses on practicing **Apache PySpark** in distributed data processing environments. The goal is to rebuild and scale data analytics workflows that would normally run on a single machine, and make them suitable for larger datasets and production-like setups.

The project was implemented using both **Databricks** and **Zeppelin**, allowing me to explore how PySpark behaves in different environments. The work emphasizes using Sparks structured APIs (DataFrames and SQL) to clean data, perform aggregations, and generate analytical insights efficiently.

---

# Implementation

## Databricks

In the Databricks part of the project, I worked with a structured transactional dataset and implemented the full analytics workflow using PySpark. The focus was on writing scalable transformations rather than optimizing for a single-machine solution.

Key tasks include:
- Loading and cleaning raw data
- Performing aggregations and metric calculations
- Analyzing customer behavior using purchasing patterns
- Organizing results as structured tables for further analysis

This part of the project demonstrates how analytics logic can be migrated to a managed Spark environment and executed in a distributed manner.

## Zeppelin

The Zeppelin implementation was more exploratory and learning-oriented. I worked with Hive-managed data and used PySpark to query and transform datasets directly from a Hadoop-based cluster.

This section focuses on:
- Querying Hive tables using PySpark
- Comparing DataFrame operations with Spark SQL
- Understanding how Spark executes transformations in a cluster environment
- Exploring data interactively using Zeppelin notebooks

---

# Future Improvements

- Automate data ingestion and transformation steps
- Add data validation and quality checks
- Introduce incremental data processing
- Extend the analysis with machine learning techniques
- Connect results to BI or visualization tools
