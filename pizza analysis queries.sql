SELECT * FROM order_details;
SELECT * FROM orders;
SELECT * FROM pizza_types;
SELECT * FROM pizzas;

-- The Great Pizza Analytics Challenge 

-- Questions to solve - 
-- Phase 1 : Foundation & Inspection 

-- 1. Install IDC_Pizza.dump as IDC_Pizza server
Downloaded IDC_pizza.dump file as i am using postgresql 
How to import dump file 
Open pgadmin -> create new database -> Right click on data base ->
Select Restore ->Select the downloaded dump file 

-- 2.List all unique pizza categories
SELECT DISTINCT(category) AS unique_pizza_categories
FROM pizza_types;

-- 3.Display pizza_type_id, name, and ingredients, replacing NULL
-- ingredients with "Missing Data". Show first 5 rows.
SELECT pizza_type_id, name,
CASE
    WHEN ingredients IS NULL THEN 'Missing Data'
	ELSE ingredients
	END AS ingredients
FROM pizza_types
LIMIT 5;

--4. Check for pizzas missing a price.
SELECT pizza_id, pizza_type_id, size
FROM pizzas
WHERE price IS NULL;

-- Phase 2 : Filtering & Exploration

-- 5.Orders placed on '2015-01-01'
SELECT order_id, time
FROM orders
WHERE date = '2015-01-01';

--6. List pizzas with price descending
SELECT pizza_id, pizza_type_id, size, price
FROM pizzas
ORDER BY price DESC;

-- 7.Pizzas sold in sizes 'L' or 'XL
SELECT pizza_id, pizza_type_id, size, price
FROM pizzas
WHERE size IN('L', 'XL');

-- 8.Pizzas priced between $15.00 and $17.00.
SELECT pizza_id, pizza_type_id, size, price
FROM pizzas
WHERE price BETWEEN 15.00 AND 17.00;

-- 9.Pizzas with "Chicken" in the name.
SELECT pizza_type_id, name, category, ingredients
FROM pizza_types
WHERE name LIKE '%Chicken%';

-- 10.Orders on '2015-02-15' or placed after 8 PM.
SELECT order_id AS orders, date, time
FROM orders
WHERE date = '2015-02-15' OR time > '20:00:00';

-- Phase 3: Sales Performance

-- 11.Total quantity of pizzas sold 
SELECT SUM(quantity) AS total_pizzas_sold
FROM order_details;

--12. Average pizza price
SELECT ROUND(AVG(price),2) AS avg_pizza_price
FROM pizzas;

-- 13.Total order value per order
SELECT od.order_id, SUM(od.quantity * p.price) AS total_order_value
FROM order_details od
JOIN pizzas p
ON od.pizza_id = p.pizza_id
GROUP BY od.order_id
ORDER BY total_order_value DESC;

-- 14.Total quantity sold per pizza category
SELECT 
    pt.category,
    SUM(od.quantity) AS total_quantity_sold
FROM order_details od
JOIN pizzas p 
    ON od.pizza_id = p.pizza_id
JOIN pizza_types pt
    ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY total_quantity_sold DESC;

-- 15. Categories with more than 5,000 pizzas sold 
SELECT 
    pt.category,
    SUM(od.quantity) AS total_quantity_sold
FROM order_details od
JOIN pizzas p 
    ON od.pizza_id = p.pizza_id
JOIN pizza_types pt
    ON p.pizza_type_id = pt.pizza_type_id
GROUP BY  pt.category
HAVING SUM(od.quantity) > 5000
ORDER BY  total_quantity_sold DESC

-- 16. Pizzas never ordered
SELECT
    p.pizza_id,
    p.pizza_type_id,
    p.size,
    p.price
FROM pizzas p
LEFT JOIN  order_details od
    ON p.pizza_id = od.pizza_id
WHERE od.pizza_id IS NULL;

-- 17. Price differences between different sizes of the same pizza 
SELECT 
    p1.pizza_type_id,
    p1.size AS size_1,
    p1.price AS price_1,
    p2.size AS size_2,
    p2.price AS price_2,
    p2.price - p1.price AS price_difference
FROM pizzas p1
JOIN pizzas p2
    ON p1.pizza_type_id = p2.pizza_type_id   
   AND p1.size <> p2.size                    
ORDER BY   
    p1.pizza_type_id,
    size_1,
    size_2;





