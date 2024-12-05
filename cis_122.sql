-- Question 2

--Update the table with the following Primary and Foreign keys
ALTER TABLE my_project_cis.orders
ADD PRIMARY KEY (order_id) NOT ENFORCED;

ALTER TABLE my_project_cis.products
ADD PRIMARY KEY (product_id) NOT ENFORCED;

ALTER TABLE my_project_cis.orders
ADD CONSTRAINT fk_product_id
FOREIGN KEY (product_id) REFERENCES my_project_cis.products (product_id) NOT ENFORCED;

--Question 3

--JOIN the Product and Orders table based on product id and 
--find the total number of orders by Product Categories sorted by descending name of product category

SELECT 
    p.product_category_name, 
    COUNT(o.order_id) AS total_orders
FROM 
    `my_project_cis.orders` AS o
JOIN 
    `my_project_cis.products` AS p
ON 
    o.product_id = p.product_id
GROUP BY 
    p.product_category_name
ORDER BY 
    p.product_category_name DESC;

--Question 4.1

--Write a SELECT query to find the product category that has the highest total orders (use GROUP and subqueries)
SELECT 
    product_category_name, 
    total_orders
FROM (
    SELECT 
        p.product_category_name, 
        COUNT(o.order_id) AS total_orders
    FROM 
        `my_project_cis.orders` AS o
    JOIN 
        `my_project_cis.products` AS p
    ON 
        o.product_id = p.product_id
    GROUP BY 
        p.product_category_name
) AS category_orders
ORDER BY 
    total_orders DESC
LIMIT 1;

--Question 4.2

--Write a SELECT query to list the top 10 records in the Orders table sorted by price.

SELECT 
    * 
FROM 
    `my_project_cis.orders`
ORDER BY 
    price DESC
LIMIT 10;


--Question 6.1

--This query is to track cumulative revenue by month and see how it grows throughout each year.

SELECT 
    year,
    month,
    ROUND(monthly_revenue, 0) AS monthly_revenue,
    ROUND(SUM(monthly_revenue) OVER (PARTITION BY year ORDER BY year,month), 0) AS cumulative_revenue
FROM (
    SELECT 
        EXTRACT(YEAR FROM o.shipping_limit_date) AS year,
        EXTRACT(MONTH FROM o.shipping_limit_date) AS month,
        SUM(o.price) AS monthly_revenue
    FROM 
        `my_project_cis.orders` AS o
    GROUP BY 
        year, month
) AS monthly_data
ORDER BY 
    year, month;


--Question 6.2

--"What are the top 5 product categories by average order value, and what are their overall sales?"

SELECT 
    p.product_category_name,
    ROUND(AVG(o.price), 2) AS avg_order_value,
    ROUND(SUM(o.price), 2) AS total_sales
FROM 
    `my_project_cis.orders` AS o
JOIN 
    `my_project_cis.products` AS p
ON 
    o.product_id = p.product_id
GROUP BY 
    p.product_category_name
ORDER BY 
    avg_order_value DESC
LIMIT 5;


--Question 6.3

--"Which months generate the highest revenue?"

SELECT 
    year,
    month,
    ROUND(SUM(monthly_revenue), 2) AS monthly_revenue
FROM (
    SELECT 
        EXTRACT(YEAR FROM o.shipping_limit_date) AS year,
        EXTRACT(MONTH FROM o.shipping_limit_date) AS month,
        SUM(o.price) AS monthly_revenue
    FROM 
        `my_project_cis.orders` AS o
    GROUP BY 
        year, month
) AS monthly_data
GROUP BY 
    year, month
ORDER BY 
    monthly_revenue DESC
LIMIT 10;
