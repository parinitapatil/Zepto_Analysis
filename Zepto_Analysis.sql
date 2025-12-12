drop table if exists zepto;

CREATE TABLE zepto (
  sku_id SERIAL PRIMARY KEY,
  category VARCHAR(120),
  name VARCHAR(150) NOT NULL,
  mrp NUMERIC(8,2),
  discountPercent NUMERIC(5,2),
  availableQuantity INTEGER,
  discountedSellingPrice NUMERIC(8,2),
  weightInGms INTEGER,
  outOfStock BOOLEAN,
  quantity INTEGER
);

-- Data Exploration

-- count Rows
select count(*) from zepto;

-- Check Data
select * from zepto;

-- null values
select * from zepto
where category is null or
	name is null or
	mrp is null or
	discountpercent is null or
	availablequantity is null or
	discountedsellingprice is null or
	weightingms is null or
	outofstock is null or
	quantity is null;

-- Explore Product Category
select distinct(category) from zepto
order by category

-- Product in stock & out of stock
select outofstock, count(*) from zepto
group by outofstock

-- Product name present multiple times
select name, count(*) from zepto
group by name
having count(*)>1
order by name desc

-- Data Cleaning
-- Product where price might be 0
select * from zepto
where mrp = 0 or discountedsellingprice = 0

delete from zepto
where mrp = 0


-- convert paise to rupees
update zepto
set mrp = mrp/100.0, discountedsellingprice = discountedsellingprice/100.0;

select mrp, discountedsellingprice from zepto

Found top 10 best-value products based on discount percentage

-- 📊 Business Insights

-- Found top 10 best-value products based on discount percentage
select distinct name, mrp, discountpercent
from zepto
order by discountpercent desc
limit 10

-- Identified high-MRP products that are currently out of stock
select distinct name, mrp, outofstock 
from zepto
where outofstock = false and mrp>300
order by mrp desc

-- Estimated potential revenue for each product category
select category, sum(discountedsellingprice * availableQuantity) Total_Revenue
from zepto
group by category
order by Total_Revenue

-- Filtered expensive products (MRP > ₹500) with minimal discount is less than 10%
select distinct name, mrp, discountpercent
from zepto
where mrp>500 and discountpercent<10
order by mrp desc, discountpercent desc

-- Ranked top 5 categories offering highest average discounts
select category, round(avg(discountpercent),2) Highest_avg_Discount 
from zepto
group by category
order by Highest_avg_Discount desc
limit 5

-- Q6. Find the price per gram for products above 100g and sort by best value.
select name, weightingms, discountedsellingprice, round(discountedsellingprice/weightingms,2) as price_per_gms
from zepto
where weightingms>=100
order by price_per_gms  

-- Grouped products based on weight into Low, Medium, and Bulk categories
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'Low'
	WHEN weightInGms < 5000 THEN 'Medium'
	ELSE 'Bulk'
	END AS weight_category
FROM zepto;

-- Measured total inventory weight per product category
SELECT category,
SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;




