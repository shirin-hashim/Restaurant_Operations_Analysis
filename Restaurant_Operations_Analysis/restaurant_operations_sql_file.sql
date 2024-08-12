/*
The Situation:
You’ve just been hired as a Data Analyst for the Taste of the World Café, a restaurant that has diverse menu offerings and serves generous portions.

The Assignment:
The Taste of the World Café debuted a new menu at the start of the year. You’ve been asked to dig into the customer data to see which menu items are doing well / not well and what the top customers seem to like best.

The Data Set:
A quarter's worth of orders from a fictitious restaurant serving international cuisine, including the date and time of each order, the items ordered, and additional details on the type, name and price of the items.

The Objectives:
•	Explore the menu_items table to get an idea of what’s on the new menu.
•	Explore the order_details table to get an idea of the data that’s been collected.
•	Use both tables to understand how customers are reacting to the new menu.

Objective 1 - Explore the items table:
1.	View the menu_items table and write a query to find the number of items on the menu
2.	What are the least and most expensive items on the menu?
3.	How many Italian dishes are on the menu? What are the least and most expensive Italian dishes on the menu?
4.	How many dishes are in each category? What is the average dish price within each category?

Objective 2 - Explore the orders table:
5.	View the order_details table. What is the date range of the table?
6.	How many orders were made within this date range? How many items were ordered within this date range?
7.	Which orders had the most number of items?
8.	How many orders had more than 12 items?

Objective 3 - Analyze customer behavior:
9.	Combine the menu_items and order_details tables into a single table
10.	What were the least and most ordered items? What categories were they in?
11.	What were the top 5 orders that spent the most money?
12.	View the details of the highest spend order. Which specific items were purchased?
13.	View the details of the top 5 highest spend orders
*/

/*
Objective 1 - Explore the items table:
1.	View the menu_items table and write a query to find the number of items on the menu
*/
USE restaurant_db;
SELECT 
    COUNT(*) AS number_of_items
FROM
    menu_items;

/*
2.	What are the least and most expensive items on the menu?
*/
SELECT 
    *
FROM
    menu_items
ORDER BY price DESC;

/*
3.	How many Italian dishes are on the menu? What are the least and most expensive Italian dishes on the menu?
*/
SELECT 
    category, COUNT(item_name) AS count_of_items
FROM
    menu_items
WHERE
    category = 'Italian'
GROUP BY category;

/*
4.	How many dishes are in each category? What is the average dish price within each category?
*/
SELECT 
    category,
    COUNT(item_name) AS num_of_dishes,
    AVG(price) AS average_price
FROM
    menu_items
GROUP BY category;

/*
Objective 2 - Explore the orders table:
5.	View the order_details table. What is the date range of the table?
*/
SELECT 
    *
FROM
    order_details;

SELECT 
    MIN(order_date),
    MAX(order_date)
FROM
    order_details

/*
6.	How many orders were made within this date range? How many items were ordered within this date range?
*/
SELECT 
    COUNT(DISTINCT order_id) AS num_of_orders,
    COUNT(*) AS num_of_items_orderd
FROM
    order_details;
    
/*
7.	Which orders had the most number of items?
*/
SELECT 
    order_id, COUNT(item_id) AS num_of_items
FROM
    order_details
GROUP BY order_id
ORDER BY num_of_items DESC;

/*
8.	How many orders had more than 12 items?
*/
SELECT COUNT(num_of_items) AS num_orders
FROM
(SELECT 
    order_id,
    COUNT(item_id) AS num_of_items
FROM
    order_details
GROUP BY order_id
ORDER BY num_of_items DESC) AS num_items_table
WHERE num_of_items > 12

/*
Objective 3 - Analyze customer behavior:
9.	Combine the menu_items and order_details tables into a single table
*/
SELECT 
    *
FROM
    order_details
        LEFT JOIN
    menu_items ON order_details.item_id = menu_items.menu_item_id;

/*
10.	What were the least and most ordered items? What categories were they in?
*/
SELECT 
    item_name,
    category,
    COUNT(order_details_id) AS num_of_times_ordered
FROM
    (SELECT 
        *
    FROM
        order_details
    LEFT JOIN menu_items ON order_details.item_id = menu_items.menu_item_id) AS combined_table
GROUP BY item_name , category
ORDER BY num_of_times_ordered
LIMIT 1;

/*
11.	What were the top 5 orders that spent the most money?
*/

SELECT 
    order_id, SUM(price) AS total_spend
FROM
    (SELECT 
        *
    FROM
        order_details
    LEFT JOIN menu_items ON order_details.item_id = menu_items.menu_item_id) AS combined_table
GROUP BY order_id
ORDER BY total_spend DESC
LIMIT 5;

/*
12.	View the details of the highest spend order. Which specific items were purchased?
*/
SELECT 
    *
FROM
    (SELECT 
        *
    FROM
        order_details
    LEFT JOIN menu_items ON order_details.item_id = menu_items.menu_item_id) AS combined_table
WHERE order_id = 440;

/*
13.	View the details of the top 5 highest spend orders
*/
SELECT 
    *
FROM
    (SELECT 
        *
    FROM
        order_details
    LEFT JOIN menu_items ON order_details.item_id = menu_items.menu_item_id) AS combined_table
WHERE order_id IN (440, 2075, 1957, 330, 2675);