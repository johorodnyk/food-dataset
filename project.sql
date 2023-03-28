-- Count total number of customers and orders --
SELECT (SELECT COUNT(id) FROM customers) as total_customers,
	(SELECT COUNT(id) FROM orders) as total_orders


-- Display min, max and avg orders --
SELECT MIN(total_order)::money as min_order,
	MAX(total_order)::money as max_order,
	ROUND(AVG(total_order), 2)::money as avg_order 
FROM (
	SELECT SUM(price * item_quantity) as total_order
	FROM order_item
	GROUP BY order_id
) summary_orders


-- Orders trend over weeks --
SELECT date_part('week', created_at) as week,
	count(*) as orders
FROM orders
GROUP BY week
ORDER BY week ASC


-- Select 3 customers with higher tips --
SELECT first_name, 
	SUM(tips) as sum_tips
FROM customers as c 
INNER JOIN orders as o ON c.id = o.customer_id
GROUP BY first_name
ORDER BY sum_tips DESC
LIMIT 3


-- Count number of orders per each customer--
SELECT CONCAT("first_name",' ', "last_name") as full_name,
	city, 
    COUNT(o.id) as total_order
FROM customers as c
INNER JOIN orders as o ON c.id = o.customer_id
GROUP BY full_name, city
ORDER BY total_order DESC


--Find customers with referrences --
SELECT c.id, 
	CONCAT(c."first_name",' ', c."last_name") as customer_name, 
	c.referral_customer_id,
	CONCAT(r."first_name",' ', r."last_name") as referring_name
FROM customers as c
INNER JOIN customers as r ON c.referral_customer_id = r.id
WHERE c.referral_customer_id is not null


-- Count number of referred customers per referrer--
 WITH max_refer as(SELECT c.id, 
	CONCAT(c."first_name",' ', c."last_name") as customer_name, 
	c.referral_customer_id,
	CONCAT(r."first_name",' ', r."last_name") as referring_name
FROM customers as c
INNER JOIN customers as r ON c.referral_customer_id = r.id
WHERE c.referral_customer_id is not null)

SELECT referring_name,
	COUNT(id) as referred_count 
FROM max_refer
GROUP BY referring_name
ORDER BY referred_count DESC

-- -- Look for top 5 popular products --
SELECT MIN(p.name) as name, 
	SUM(o.item_quantity) as product_count
FROM product as p
INNER JOIN order_item as o ON p.id = o.product_id
GROUP BY p.id
ORDER BY product_count DESC
LIMIT 5


-- Select top 5 product by revenue --
SELECT MIN(p.name) as name, 
	SUM(o.item_quantity * o.price) as product_revenue
FROM product as p
INNER JOIN order_item as o ON p.id = o.product_id
GROUP BY p.id
ORDER BY product_revenue DESC
LIMIT 10


-- Use dense_rank to compare top 10 sales by product count and revenue --
WITH top_product as (
	SELECT p.id, MIN(p.name) as name, 
	SUM(o.item_quantity) as product_count
	FROM product as p
	INNER JOIN order_item as o ON p.id = o.product_id
	GROUP BY p.id
	ORDER BY product_count DESC
	LIMIT 10
), revenue as (
	SELECT p.id, 
	MIN(p.name) as name, SUM(o.item_quantity * o.price) as product_revenue
	FROM product as p
	INNER JOIN order_item as o ON p.id = o.product_id
	GROUP BY p.id
	ORDER BY product_revenue DESC
	LIMIT 10
)
SELECT r.name, 
	product_count, 
	product_revenue,
	DENSE_RANK () OVER (ORDER BY product_count DESC) as product_rank,
	DENSE_RANK () OVER (ORDER BY product_revenue DESC) as revenue_rank
FROM top_product as t
INNER JOIN revenue as r ON t.id = r.id


-- Optimised way to dense_rank revenue and product count --
SELECT p.id, 
	MIN(p.name) as name,
	SUM(o.item_quantity * o.price) as product_revenue,
	SUM(o.item_quantity) as product_count,
	DENSE_RANK () OVER (ORDER BY SUM(o.item_quantity) DESC) as product_rank,
	DENSE_RANK () OVER (ORDER BY SUM(o.item_quantity * o.price) DESC) as revenue_rank
FROM product as p
INNER JOIN order_item as o ON p.id = o.product_id
GROUP BY p.id
ORDER BY product_revenue DESC
LIMIT 10


-- -- Sentimental analysis over rating score-- 
SELECT 
	CASE 
		WHEN rating = 5 THEN  'Excellent'
		WHEN rating = 4 THEN  'Good'
		WHEN rating = 3 THEN  'Not Satisfied'
		WHEN rating = 2 THEN  'Bad'
		WHEN rating = 1 or rating = 0 THEN 'Terrible'
	END as sentiment,
	COUNT(*) as rating_count,
	CONCAT(ROUND((COUNT(*)::float/(SELECT COUNT(*) FROM orders)*100)::numeric, 2), '%') as percent_distribution
FROM orders
GROUP BY sentiment


-- Calculate a percentage of returning customers ---
WITH returned as (SELECT customer_id, 
	COUNT(DISTINCT customer_id) as total_customers, 
	COUNT(customer_id) as order_count
FROM orders
GROUP BY customer_id)

SELECT CONCAT(ROUND((COUNT(customer_id):: float/(SELECT COUNT(DISTINCT customer_id) FROM returned) * 100) ::numeric, 1), '%') as returned_persent
FROM returned
WHERE order_count > 1


-- Calculate net profit margin ratio = (revenue - cost) / revenue --
WITH summarized AS (
	SELECT p.id, 
		MIN(p.name) as name, 
		SUM(o.item_quantity * o.price)::money as product_revenue, 
		SUM(o.item_quantity * p.cost)::money as product_cost,
		CONCAT(ROUND((SUM(o.item_quantity * o.price)::numeric - SUM(o.item_quantity * p.cost)::numeric) / SUM(o.item_quantity * o.price) * 100, 2), '%') as net_profit
	FROM product as p
	INNER JOIN order_item as o ON p.id = o.product_id
	GROUP BY p.id
	ORDER BY product_revenue DESC
)
SELECT *, CONCAT(ROUND((product_revenue - product_cost)::float / product_revenue * 100, 2), '%') as net_profit
FROM summarized as p
ORDER BY product_revenue DESC
