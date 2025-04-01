# Alex The Analyst Bootcamp

The bootcamp provided comprehensive, hands-on experience in data analysis and visualization using industry-standard tools and programming languages, including SQL, Excel, Tableau, Power BI, Python, and cloud platforms such as Azure and AWS.

Throughout the program, I gained proficiency in:

**MySQL:** SELECT statements, WHERE and HAVING clauses, GROUP BY and ORDER BY, LIMIT and aliasing, joins, unions, string functions, CASE statements, subqueries, window functions, Common Table Expressions (CTEs), temporary tables, stored procedures, triggers, and events.

**Excel:** Conditional formatting, formulas, XLOOKUP and VLOOKUP, pivot tables, and charts.

**Tableau:** Bins and calculated fields, joins, and various visualization techniques.

**Power BI:** Power Query Editor, building relationships, DAX, drill-down, conditional formatting, bins and lists, and data visualizations.

**Python:** Variables, data types, operators, control structures (if-elif-else statements, loops), functions, file sorting, and web scraping.

**Pandas:** Reading files, filtering and ordering, indexing, GROUP BY and aggregation, merging/joining/concatenation, data extraction using APIs, data cleaning, exploratory data analysis (EDA), and visualization.

**Azure:** Storage accounts, SQL databases, Data Factory, and Synapse Analytics.

**AWS:** S3, Amazon Athena, Glue, Glue DataBrew, and QuickSight.   

This repository contains the projects completed during the Alex The Analyst Bootcamp, showcasing the practical application of these skills.

## MYSQL
Two projects were completed in related to SQL. The first project focused on `data cleaning`, where I learned SQL queries to clean and standardize data by removing duplicates, checking for spelling errors, handling null and blank fields, and removing unnecessary columns or rows. The second project involved `exploratory data analysis`, where I applied SQL queries to identify general patterns in the data.

## Excel
For my Excel project, I created a dashboard displaying bike sales data, as shown below. The dashboard includes three different charts that dynamically update based on the slicer filters located on the left side.

![Excel dashboard](<Assets/bike_sales_dashboard.png>)


## Tableau
AirBnB data from Kaggle was used in this project. Three tables from the dataset were joined using an Inner Join, followed by detailed visualizations, and an interactive dashboard was created. View this dashboard live on [Tableau Public](https://public.tableau.com/app/profile/shree.ram.bhusal/viz/AirBnBFullProject_17412840279140/Dashboard1).

![Tableau dashboard](<Assets/tableau_airbnb.png>)

## Power BI
In this project, a real dataset about data professionals from Alex The Analyst was utilized. The raw data was first transformed using Power Query, followed by the creation of visualizations and an interactive dashboard.

![Tableau dashboard](<Assets/powerbi_dataprofessionals.PNG>)

## Python
Two projects were done using Python.

### 1. Web Scraping
- In this project, product data was extracted from the Amazon website and stored in a CSV file. An automated data update system was implemented to ensure daily updates, allowing any changes in the product data to be reflected automatically in the CSV file.

### 2. Crypto API
- In this project, cryptocurrency data was extracted from the CoinMarketCap API. An automation script was developed to append data every minute, followed by basic data cleaning. The cleaned data was then visualized using Matplotlib and Seaborn libraries for in-depth analysis.

The first graph presents the value fluctuations of the top 15 cryptocurrencies over time, providing insights into market trends and volatility. The second graph specifically highlights the price trajectory of Bitcoin over time.

![Cryptocurrency values over time](<Assets/python_crypto_api.png>)

![Bitcoin price over time](<Assets/bitcoin_graph.png>)
