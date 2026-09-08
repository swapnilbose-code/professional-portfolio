# Insurance Claims & Policy Performance Analytics

# Project Overview
Performed insurance claims and policy performance analysis using Power BI to understand portfolio performance, claim behavior, customer risk, agent performance, product profitability, and regional trends.

The project analyzes 25K+ insurance policies and 10K+ claims and converts the data into an interactive 5-page Power BI dashboard for business decision-making.

# Business Problem
Insurance organizations need to monitor premiums, claims, settlements, loss ratios, and customer and agent performance to identify high-risk areas and improve profitability.

However, insurance data is often spread across multiple datasets, making it difficult to identify high-risk products, customers, regions, and agents.

This project provides a consolidated analytical view of insurance portfolio and claims performance through an interactive Power BI dashboard.

## 📊 Dashboard Preview

### Executive Overview
![Executive Overview](Screenshots/Page1_Executive_Overview.png)

### Product & Regional Performance
![Product & Regional Performance](Screenshots/Page2_Product_Regional_Performance.png)

### Claims & Customer Risk
![Claims & Customer Risk](Screenshots/Page3_Claims_Customer_Risk.png)

### Customer & Agent Insights
![Customer & Agent Insights](Screenshots/Page4_Customer_Agent_Insights.png)

### Customer Segment & Severity Analysis
![Customer Segment & Severity Analysis](Screenshots/Page5_Customer_Segment_Severity.png)

# Tools & Technologies
- Power BI (Dashboard & Data Visualization)
- DAX (Measures & KPIs)
- Power Query (Data Cleaning & Transformation)
- SQL (Data Analysis & Validation)
- Excel / CSV
- Data Modeling

# Dataset
Insurance dataset containing customer, policy, claims, claim payment, product, agent, and regional information.

| Table | Records |
|---|---:|
| Customers | 15,002 |
| Policies | 25,001 |
| Claims | 10,001 |
| Claim Payments | 7,174 |
| Products | 7 |

# Data Cleaning & Validation
- Identified duplicate Customer IDs
- Handled missing customer occupation values
- Standardized gender values
- Corrected date formats
- Validated negative premium values
- Handled missing claim and approved amounts
- Performed foreign-key and relationship validation
- Verified referential integrity across major datasets

# Key Analysis
- Insurance premium performance by product and region
- Claim amount and loss ratio analysis
- Claim share by product
- Settlement performance
- Claim turnaround time (TAT)
- Claim rejection reason analysis
- Customer risk and segment analysis
- Agent premium and claim performance
- Agent loss ratio analysis
- Claim severity analysis

# Dashboard Features
- KPI Cards (Total Policies, Total Premium, Total Claims, Average Claim Amount)
- Loss Ratio and Settlement Ratio KPIs
- Product and Regional Performance Analysis
- Claims Status and Rejection Reason Analysis
- Top 10 Customers by Claim Amount
- Top 10 Agents by Premium
- Top 10 Agents by Claim Amount
- Top 10 Agents by Loss Ratio
- Customer Segment and Severity Analysis
- Interactive filters for Region, Customer Segment, and Product

# Key Insights
- Travel Insurance recorded a significantly high loss ratio of approximately 169%, indicating a major profitability risk.
- Retail customers had the highest customer-segment loss ratio at approximately 44.85%.
- Medium-severity claims represented the largest share of claims at approximately 40.8%.
- Fraud Suspected was the leading claim rejection reason, followed by Late Notification.
- Agent 0082 recorded the highest loss ratio among the displayed Top 10 agents at approximately 78.3%.
- Overall settlement ratio was approximately 55.12%.

# Recommendations
- Review pricing and underwriting strategies for high-loss-ratio products.
- Investigate the high loss ratio of Travel Insurance.
- Analyze fraud-related claim rejection patterns.
- Review agents with consistently high loss ratios.
- Investigate products and regions with higher claim exposure.
- Improve claim processing and settlement efficiency.
- Monitor high-risk customer segments and severity patterns.

# Conclusion
The analysis provides actionable insights into insurance portfolio performance, claims behavior, customer risk, agent performance, and operational efficiency.

The Power BI dashboard enables stakeholders to identify high-risk areas and make data-driven decisions to improve profitability and claims management.
