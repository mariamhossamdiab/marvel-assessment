🚀 Marvel Assessment | End-to-End Data Project (Excel + SQL + Power BI)

 I built a complete data workflow starting from raw data to business-ready insights.

🔹 Part 1: Excel – Data Cleaning & Transformation

Cleaned and standardized raw sales data

Formatted dates and ensured correct data types (Units, Price, numeric fields)

Removed duplicates

Used XLOOKUP / INDEX-MATCH to map Region and Product details

Created calculated fields including:

Value = Units × Price

Month ID and Day ID extracted from Date

Exported the final structured dataset as cleaned_sales.csv

🔹 Part 2: SQL – Data Matching & Updates

Wrote SQL queries to update unified_id and rep_id in u1sales_raw

Applied matching logic based on:

month_id

day_id

region_id

product_id

Included a refresh for a materialized view (u1sales_analysis)

Focused on writing optimized and production-ready SQL logic

🔹 Part 3: Power BI – Data Modeling & Visualization
Built an interactive dashboard including:

📊 Units by Region (Bar Chart)

🍩 Value by Product Line (Donut Chart)

📈 Units Trend Over Time (Line Chart)

Created a DAX measure:
Total Value = SUM(raw_sales[Value])

This project demonstrates my ability to work across the full data pipeline — from cleaning and transformation to SQL-based data integration and business intelligence visualization.
<img width="1377" height="737" alt="Screenshot 2025-12-04 004334" src="https://github.com/user-attachments/assets/048b425a-3a8a-4820-bcf3-a777a7ec51cc" />
<img width="953" height="712" alt="Screenshot 2025-12-04 015521" src="https://github.com/user-attachments/assets/8c1090d0-abb4-44a4-b655-0f40f3db6977" />
