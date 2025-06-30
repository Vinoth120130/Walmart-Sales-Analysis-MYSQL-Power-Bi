# 🛍️ Walmart Sales Analysis Dashboard

## 📌 Project Overview

This project presents an end-to-end **Sales Analysis Dashboard** built using **MySQL**, **Power Query**, and **Power BI**, focusing on uncovering actionable business insights and performance metrics (KPIs). The dataset was extracted from MySQL using custom queries, transformed via Power Query, and visualized using Power BI to assist stakeholders in understanding trends, customer behavior, product performance, and operational efficiency.

---

## 🎯 Objective

To design an interactive and insightful dashboard for Walmart’s retail sales data to help business stakeholders make data-driven decisions by addressing key questions related to sales, products, time, and customer behavior.

---

## 🚀 Tools & Technologies Used

- **MySQL**: Data storage, cleaning, and analysis through SQL queries.
- **Power BI**: Interactive dashboard design and business storytelling.
- **Power Query**: Data transformation and loading into Power BI.
- **DAX** (Basic): Used for calculated KPIs and formatting.
- **Data Visualization**: Clean and action-focused charts, KPIs, and filters.

---

## 🗃️ Data Source

Data was extracted from a MySQL table named `sales_data`, and included attributes such as:
- `Branch`, `City`, `Customer Type`, `Gender`, `Product Line`, `Payment Method`
- `Total`, `Gross Income`, `Quantity`, `Rating`, `Time of Day`, `Date`

---

## ❓ Key Business Questions Addressed in MySQL

1. **What are the top-selling product lines by revenue and quantity?**
2. **Which customer type contributes more to total revenue?**
3. **What is the average transaction value per branch?**
4. **Which product lines have high gross income despite lower average sales?**
5. **What time of day generates the highest revenue per branch?**
6. **Which payment method is most preferred per product line?**
7. **Monthly trend: How do total revenues vary across months?**
8. **What is the return on cost per product line?**
9. **What is the correlation between customer rating and revenue generated?**
10. **Branch performance: Which branch performs best in terms of KPIs?**

> SQL queries were written for aggregations, filtering, grouping, and identifying key KPIs.

---

## 📊 KPIs Displayed in Dashboard

- **Total Revenue**  
- **Total Quantity Sold**  
- **Profit Margin %**  
- **Revenue by Customer Type**  
- **Sales by Time of Day & Branch**  
- **Revenue by Product Line**  
- **Top 5 Performing Products**  
- **Monthly Revenue Trend**  
- **Preferred Payment Methods**  
- **Rating-Based Slicer**

---
## 📈 Dashboard Preview

![Dashboard Preview](https://github.com/Vinoth120130/Walmart-Sales-Analysis-MYSQL-Power-Bi/blob/main/Power%20Bi.jpg)

---

## 💡 Business Insights

- **Evening time** records the **highest total sales** across all branches.
- **Branch C** generates the **highest average transaction value (₹337)**.
- **Food and Beverages**, **Sports and Travel**, and **Fashion Accessories** are the **top 3 product lines by revenue**.
- Despite lower average sales, **Fashion Accessories** yield **high gross income**, indicating premium pricing or loyalty.
- **Customer Type** has minimal variance in revenue—both **Member** and **Normal** customers are equally valuable.
- **Ewallet** and **Cash** are the top payment preferences across most product lines.
- **Return on cost** for high-performing categories is approximately **8.7%** for certain product lines.

---

## ✅ Key Outcomes (Results)

- Delivered a **production-ready dashboard** suitable for business presentations.
- Implemented **dynamic KPIs** and **drill down charts** for user-friendly insights.
- Transformed raw MySQL data into clean visual stories using **Power BI best practices**.
- Used **Power Query for transformation**, eliminating the need for external Excel prep.
