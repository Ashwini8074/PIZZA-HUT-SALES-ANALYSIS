use pizzahut;

-- Find the total number of orders placed.

SELECT COUNT(order_id) AS total_orders
FROM orders;


-- 2. Calculate the total revenue from pizza sales.

SELECT SUM(od.quantity * p.price) AS total_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id;

-- 3. Identify the highest-priced pizza.

SELECT name, MAX(price) AS max_price 
FROM pizzas;

-- 4. Determine the most frequently ordered pizza size.

SELECT size, COUNT(size) AS order_count
FROM order_details
JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id
GROUP BY size
ORDER BY order_count DESC
LIMIT 1;

-- 5. List the top 5 pizzas by order quantity.

SELECT pt.name, SUM(od.quantity) AS total_quantity
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_quantity DESC
LIMIT 5;

-- 6. Calculate the total quantity ordered for each pizza category.

SELECT pt.category, SUM(od.quantity) AS total_quantity
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category;

-- 7. Analyze the distribution of orders by hour of day.

SELECT HOUR(o.order_time) AS order_hour, COUNT(o.order_id) AS total_orders
FROM orders o
GROUP BY order_hour
ORDER BY total_orders DESC;

-- 8. Determine the order distribution of pizzas by category.

SELECT pt.category, COUNT(DISTINCT od.pizza_id) AS pizza_count
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category;

-- 9. Calculate the average number of pizzas ordered each day.

SELECT DATE(o.order_date) AS order_date, AVG(od.quantity) AS average_daily_orders
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY order_date;

-- 10. Identify the top 3 pizzas based on revenue.

SELECT pt.name, SUM(od.quantity * p.price) AS total_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_revenue DESC
LIMIT 3;

-- 11. Calculate each pizza type’s percentage contribution to total revenue.

SELECT pt.name, 
       SUM(od.quantity * p.price) AS pizza_revenue, 
       (SUM(od.quantity * p.price) / (SELECT SUM(od2.quantity * p2.price) 
        FROM order_details od2 
        JOIN pizzas p2 ON od2.pizza_id = p2.pizza_id) * 100) AS revenue_percentage
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name;

-- 12. Track cumulative revenue growth over time.

SELECT o.order_date, 
       SUM(od.quantity * p.price) OVER (ORDER BY o.order_date) AS cumulative_revenue
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN pizzas p ON od.pizza_id = p.pizza_id;

-- 13. Determine the top 3 pizzas by revenue within each category.

SELECT pt.category, pt.name, 
       SUM(od.quantity * p.price) AS total_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category, pt.name
ORDER BY pt.category, total_revenue DESC
LIMIT 3;
