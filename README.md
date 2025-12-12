# 🛒 Zepto Data Analysis 

This project contains a complete analysis of a Zepto-style grocery dataset using **PostgreSQL** and **pgAdmin**.  
It demonstrates SQL skills used in Data Analyst, Product Analyst, and Business Analyst roles.

---

## 📌 Project Overview

- Imported raw Zepto-like grocery dataset into PostgreSQL  
- Cleaned, validated, and explored the data  
- Performed price, discount, and unit-value analysis  
- Detected duplicates in product listings  
- Calculated price-per-gram for value-for-money insights  
- Generated category-level insights  

---

## 🛠️ Tools Used

| Tool | Purpose |
|------|---------|
| **PostgreSQL** | Database storage & SQL execution |
| **pgAdmin 4** | GUI for query execution & table inspection |
| **GitHub** | Documentation & version control |

---

## 📂 Dataset Columns

- sku_id  
- name  
- category  
- mrp  
- discountPercent  
- discountedSellingPrice  
- availableQuantity  
- weightInGms  
- outOfStock  
- quantity  

---

## 🧹 Data Cleaning Steps

- Removed duplicate rows  
- Identified & handled NULL values  
- Removed products with `mrp = 0`  
- Converted MRP & selling price from paise → rupees  
- Verified discount percentage logic  

---

## 📊 SQL Analysis Performed

### ✔ 1. Duplicate Product Check
Detect products listed multiple times:

```sql
select name, count(*) 
from zepto
group by name
having count(*) > 1;
```

---

### ✔ 2. High MRP & Discount Analysis

```sql
select name, mrp, discountPercent
from zepto
order by discountPercent desc
limit 10;
```

---

### ✔ 3. Out-of-Stock Expensive Products

```sql
select name, mrp, outOfStock
from zepto
where outOfStock = true and mrp > 300;
```

---

### ✔ 4. Total Revenue by Category

```sql
select category, 
       sum(discountedSellingPrice * availableQuantity) as total_revenue
from zepto
group by category
order by total_revenue desc;
```

---

### ✔ 5. Expensive Products with Low Discounts

```sql
select name, mrp, discountPercent
from zepto
where mrp > 500 and discountPercent < 10
order by mrp desc;
```

---

### ✔ 6. Price Per Gram (Value Score)

```sql
select name, weightInGms, discountedSellingPrice,
       round(discountedSellingPrice / weightInGms, 2) as price_per_gm
from zepto
where weightInGms >= 100
order by price_per_gm;
```

---

### ✔ 7. Weight Category Classification

```sql
select name, weightInGms,
case 
    when weightInGms < 1000 then 'Low'
    when weightInGms < 5000 then 'Medium'
    else 'Bulk'
end as weight_category
from zepto;
```

---

### ✔ 8. Total Inventory Weight per Category

```sql
select category,
       sum(weightInGms * availableQuantity) as total_weight
from zepto
group by category
order by total_weight desc;
```

---

## 📁 Project Structure

```
📦 zepto-sql-analysis
 ┣ 📂 sql_queries
 ┃ ┣ data_cleaning.sql
 ┃ ┣ duplicates.sql
 ┃ ┣ pricing.sql
 ┃ ┣ discount.sql
 ┃ ┣ price_per_gram.sql
 ┃ ┗ category_insights.sql
 ┣ 📄 zepto_dataset.csv
 ┗ 📄 README.md
```

---

## ▶️ How to Run

1. Install PostgreSQL  
2. Open pgAdmin  
3. Create a database:

```sql
CREATE DATABASE zepto;
```

4. Import the CSV using pgAdmin  
5. Run the SQL queries  
6. View insights in the query results  

---

## 📝 Key Insights Found

- Some products appear multiple times with different weights  
- High discounts did not always mean best value  
- Category-level price variation is large  
- Price-per-gram helped identify overpriced items  
- Some categories had significantly higher inventory weight  

---

