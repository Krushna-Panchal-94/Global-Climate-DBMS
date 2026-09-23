# 🌍 Global Climate Change Impact & Sustainability Monitoring

A Database Management System (DBMS) project for storing, managing, and analyzing global climate-change data using a normalized relational database.

The project transforms raw climate datasets into structured relational tables and provides SQL-based analysis, reporting, automation, auditing, and query optimization.

---

## 📌 Project Overview

Climate datasets contain large amounts of information collected across different countries, regions, indicators, and years. Raw datasets are often difficult to analyze because they contain repeated information, missing values, inconsistent formats, and yearly observations stored across multiple columns.

This project addresses these issues by designing and implementing a normalized relational database for climate-change and sustainability monitoring.

The database stores:

- Countries and their regions
- Income groups
- Lending types
- Climate indicators
- Indicator metadata
- Climate measurements
- Source organizations

---

## 🎯 Objectives

- Design a normalized relational database based on the TAE-1 schema.
- Convert raw climate data into structured relational records.
- Reduce redundancy using normalization.
- Store yearly climate measurements efficiently.
- Perform advanced SQL-based climate analysis.
- Implement stored procedures for controlled data insertion.
- Implement triggers for database-level auditing.
- Create views for simplified reporting.
- Use indexes to improve query performance.
- Analyze query execution using `EXPLAIN`.

---

## 🛠️ Technology Stack

| Component | Technology |
|---|---|
| Database | MySQL |
| Database Tool | MySQL Workbench |
| Programming | Python |
| Data Processing | Pandas |
| Development Environment | VS Code |
| Query Language | SQL |
| Source Dataset | World Bank Climate Indicators Dataset |
| Version Control | Git & GitHub |

---

## 🗂️ Project Structure

```text
Global_Climate_DBMS/
│
├── raw_data/
│   ├── API_19_DS2_en_csv_v2_42074.csv
│   ├── Metadata_Country_API_19_DS2_en_csv_v2_42074.csv
│   └── Metadata_Indicator_API_19_DS2_en_csv_v2_42074.csv
│
├── cleaned_data/
│   ├── climate_indicator.csv
│   ├── climate_measurement.csv
│   ├── country.csv
│   ├── income_group.csv
│   ├── indicator_metadata.csv
│   ├── region.csv
│   └── source_organization.csv
│
├── sql/
│   ├── 01_schema.sql
│   ├── 02_data.sql
│   ├── 03_views.sql
│   ├── 04_procedure.sql
│   ├── 05_trigger.sql
│   ├── 06_transactions.sql
│   └── 07_optimization.sql
│
├── presentation/
│   └── Presentation_Deck.pdf
│
├── clean_dataset.py
├── populate.py
├── README.md
└── .gitignore