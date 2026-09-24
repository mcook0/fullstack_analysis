AdventureWorks Full-Stack Sales Pipeline  |  MySQL · SQL · Power BI · Data Modeling · Business Intelligence

Identified territory-level performance gaps across 4,000 reseller orders in 10 global markets by building a full SQL pipeline — from raw CSV to cleaned database view — and presenting findings in an interactive 3-page Power BI dashboard.

Executive Summary
Using MySQL and Power BI, I analyzed reseller sales data from AdventureWorks across 10 territories, 632 resellers, and 17 salespersons. I built a full data pipeline — loading raw CSVs into a MySQL database, cleaning and transforming the data in SQL, creating an analytical view, and connecting Power BI directly to that view for live reporting.

After identifying that Australia and Germany are significantly underperforming relative to their peer territories, and that the performance gap is driven by reseller network coverage rather than salesperson quality, I recommend the sales leadership team focuses on three adjustments:

- Expand the reseller network in Australia and Germany to bring coverage in line with higher-performing markets
- Investigate France and United Kingdom specifically — both have adequate reseller counts but disproportionately low order volumes
- Study and replicate Tsvi Reiter's engagement model across the wider salesperson team

Business problem
AdventureWorks operates a global reseller sales network across North America, Europe, and the Pacific. Leadership needed to understand which territories were underperforming and whether the gap was caused by reseller coverage, salesperson performance, or product-category fit — before making headcount or expansion decisions.

Which sales territories are underperforming, and is the gap driven by who we have selling — or who we have selling through?

Methodology
- Loaded 7 raw CSV files into a MySQL database and ran 10 data quality checks covering nulls, duplicates, date format inconsistencies, whitespace, and character encoding errors.
- Wrote SQL cleaning queries to parse text dates into proper DATE format using STR_TO_DATE, strip currency formatting from cost columns, TRIM all text fields, and fix a character encoding issue on a salesperson name.
- Created a single analytical view (vw_sales_analysis) joining all 5 relevant tables — sales, product, reseller, salesperson, and region — so Power BI reads one clean object, not raw tables.
- Connected Power BI Desktop directly to the MySQL database via live connection — no CSV exports, no manual refreshes.
- Built 4 DAX measures and a 3-page interactive dashboard to answer the business question at executive, territory, and product level.

Skills
MySQL + SQL: data inspection, null checks, duplicate detection, date parsing, string cleaning, multi-table JOINs, analytical view architecture
Power BI: live database connection, DAX measures (DISTINCTCOUNT, DIVIDE), data modeling, tile slicers, cross-filtering, scatter plots, matrix visuals, 3-page dashboard

Results & Business Recommendation

Building a connected SQL-to-Power BI pipeline gives sales leadership full visibility into territory performance — overall and by category, salesperson, and reseller coverage — without manual reporting. Stakeholders can filter by year, sales group, or product category and see every visual update simultaneously.

This analysis showed that Australia and Germany together account for fewer than 230 total orders — compared to 717 for Southwest alone — and that the gap correlates directly with reseller network size, not salesperson headcount. France and United Kingdom present a different pattern: adequate reseller coverage but disproportionately low order conversion, pointing to a product-fit or sales engagement issue rather than a structural one.

Because the biggest performance gaps are structural — reseller coverage in two markets, and engagement effectiveness in two others — I recommend the following adjustments:

- Recruit 20–30 new reseller partners in Australia and Germany before adding salesperson headcount. The data shows coverage drives volume, not rep count.
- Conduct a sales review in France and United Kingdom specifically focused on Bikes — the category with the largest absolute gap relative to comparable territories.
- Document and share Tsvi Reiter's reseller engagement approach. At 400+ orders he operates at nearly double the team average — his methods should inform team-wide coaching.
- Use the monthly trend data (consistent growth from 50 to 185 orders per month across 2017–2020) to set territory-level growth targets rather than flat quotas.

I believe these adjustments will close the territory performance gap, reduce over-reliance on the strongest markets, and give leadership a repeatable framework for evaluating future expansion decisions.

Next steps
- Add sales target data from Targets.csv to the dashboard to show actual vs. target by territory and salesperson
- Connect the SalespersonRegion table to enable filtering by salesperson assignment rather than order geography
- Present findings to the regional sales leads and align on reseller recruitment targets for Australia and Germany
- Revisit in Q2 to measure whether order volume in underperforming territories has improved

Deliverables

adventureworks-fullstack-pipeline/
├── data/
│   ├── Sales.csv
│   ├── Product.csv
│   ├── Reseller.csv
│   ├── Salesperson.csv
│   ├── Region.csv
│   ├── SalespersonRegion.csv
│   └── Targets.csv
├── sql/
│   └── fullstack_project.sql
├── powerbi/
│   └── fullstack_analysis.pbix
└── README.md



How to view

File	How to open
fullstack_project.sql	MySQL Workbench (free) — run against an adventureworks schema
fullstack_analysis.pbix	Power BI Desktop (free) — powerbi.microsoft.com/desktop

Note: the .pbix file connects to a local MySQL database. To reconnect, point the data source to your MySQL instance running the adventureworks schema, or re-run fullstack_project.sql to recreate the database from the raw CSVs.


<img width="823" height="506" alt="image" src="https://github.com/user-attachments/assets/c01e4aeb-ab7d-4ade-95b2-9aa8b5ab297a" />

<img width="1007" height="473" alt="image" src="https://github.com/user-attachments/assets/fa6bb314-2884-4faa-94f7-393572cc2f12" />



<img width="995" height="490" alt="image" src="https://github.com/user-attachments/assets/37ff4dfd-4cda-4ee6-8ba8-224b24e8af4a" />
