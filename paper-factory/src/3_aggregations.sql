-- Find the total amount of poster_qty paper ordered in the orders table.
SELECT SUM(poster_qty)
    FROM orders;

-- Find the total amount of standard_qty paper ordered in the orders table.
SELECT SUM(standard_qty)
    FROM orders;

-- Find the total dollar amount of sales using the total_amt_usd in the orders table.
SELECT SUM(total_amt_usd)
    FROM orders;

-- Find the total amount spent on standard_amt_usd and gloss_amt_usd paper for each order in the orders table. This should give a dollar amount for each order in the table.
SELECT id, standard_amt_usd + gloss_amt_usd AS total_spent
    FROM orders;

-- Find the standard_amt_usd per unit of standard_qty paper. Your solution should use both an aggregation and a mathematical operator.
SELECT SUM(standard_amt_usd) / SUM(standard_qty) AS unit_price
    FROM orders;

--  When was the earliest order ever placed? You only need to return the date.
SELECT MIN(occurred_at)
    FROM orders;

-- Try performing the same query as in question 1 without using an aggregation function.
SELECT occurred_at
    FROM orders
    ORDER BY occurred_at
    LIMIT 1;

-- When did the most recent (latest) web_event occur?
SELECT MAX(occurred_at)
    FROM web_events;

-- Try to perform the result of the previous query without using an aggregation function.
SELECT occurred_at
    FROM web_events
    ORDER BY occurred_at DESC
    LIMIT 1;

-- Find the mean (AVERAGE) amount spent per order on each paper type, as well as the mean amount of each paper type purchased per order. Your final answer should have 6 values - one for each paper type for the average number of sales, as well as the average amount.
SELECT AVG(standard_qty) mean_standard, AVG(gloss_qty) mean_gloss,
           AVG(poster_qty) mean_poster, AVG(standard_amt_usd) mean_standard_usd,
           AVG(gloss_amt_usd) mean_gloss_usd, AVG(poster_amt_usd) mean_poster_usd
    FROM orders;

-- Which account (by name) placed the earliest order? Your solution should have the account name and the date of the order.
SELECT a.name, o.occurred_at
    FROM accounts a
    JOIN orders o
        ON a.id = o.account_id
    ORDER BY occurred_at
    LIMIT 1;

-- Find the total sales in usd for each account. You should include two columns - the total sales for each company's orders in usd and the company name.
SELECT a.name, SUM(o.total_amt_usd)
    FROM accounts a
    JOIN orders o
        ON a.id = o.account_id
    GROUP BY a.name;

-- Via what channel did the most recent (latest) web_event occur, which account was associated with this web_event? Your query should return only three values - the date, channel, and account name.
SELECT MIN(w.occurred_at), w.channel, a.name
    FROM web_events w
    JOIN accounts a
        ON w.account_id = a.id
    GROUP BY a.name, w.channel
    LIMIT 1;

-- Find the total number of times each type of channel from the web_events was used. Your final table should have two columns - the channel and the number of times the channel was used.
SELECT channel, COUNT(channel)
    FROM web_events
    GROUP BY channel;

-- Who was the primary contact associated with the earliest web_event?
SELECT a.primary_poc, MIN(w.occurred_at)
    FROM web_events w
    JOIN accounts a
        ON w.account_id = a.id
    GROUP BY a.primary_poc
    LIMIT 1;

-- What was the smallest order placed by each account in terms of total usd. Provide only two columns - the account name and the total usd. Order from smallest dollar amounts to largest.
SELECT a.name, MIN(o.total_amt_usd)
    FROM accounts a
    JOIN orders o
        ON a.id = o.account_id
    GROUP BY a.name
    ORDER BY MIN(o.total_amt_usd);

-- Find the number of sales reps in each region. Your final table should have two columns - the region and the number of sales_reps. Order from fewest reps to most reps.
SELECT r.name, COUNT(s.name)
    FROM region r
    JOIN sales_reps s
        ON r.id = s.region_id
    GROUP BY r.name;

-- For each account, determine the average amount of each type of paper they purchased across their orders. Your result should have four columns - one for the account name and one for the average quantity purchased for each of the paper types for each account.
SELECT a.name, AVG(o.standard_qty) avg_standard, AVG(o.gloss_qty) avg_gloss, AVG(o.poster_qty) avg_poster
    FROM accounts a
    JOIN orders o
        ON a.id = o.account_id
    GROUP BY a.name
    ORDER BY a.name;

-- For each account, determine the average amount spent per order on each paper type. Your result should have four columns - one for the account name and one for the average amount spent on each paper type.
SELECT a.name, AVG(o.standard_amt_usd) avg_standard, AVG(o.gloss_amt_usd) avg_gloss, AVG(o.poster_amt_usd) avg_poster
    FROM accounts a
    JOIN orders o
        ON a.id = o.account_id
    GROUP BY a.name
    ORDER BY a.name;

-- Determine the number of times a particular channel was used in the web_events table for each sales rep. Your final table should have three columns - the name of the sales rep, the channel, and the number of occurrences. Order your table with the highest number of occurrences first.
SELECT s.name, w.channel, COUNT(*) as counts
    FROM sales_reps s
    JOIN accounts a
        ON s.id = a.sales_rep_id
    JOIN web_events w
        ON a.id = w.account_id
    GROUP BY s.name, w.channel
    ORDER BY s.name, counts DESC;

-- Determine the number of times a particular channel was used in the web_events table for each region. Your final table should have three columns - the region name, the channel, and the number of occurrences. Order your table with the highest number of occurrences first.
SELECT r.name, w.channel, COUNT(*) as channel_count
    FROM region r
    JOIN sales_reps s
        ON r.id = s.region_id
    JOIN accounts a
        ON s.id = a.sales_rep_id
    JOIN web_events w
        ON a.id = w.account_id
    GROUP BY r.name, w.channel
    ORDER BY channel_count DESC;

-- Use DISTINCT to test if there are any accounts associated with more than one region.
SELECT a.name account, r.name region
    FROM accounts a
    JOIN sales_reps s
        ON a.sales_rep_id = s.id
    JOIN region r
        ON r.id = s.region_id;

SELECT DISTINCT id, name
    FROM accounts;

-- Have any sales reps worked on more than one account?
SELECT s.id, s.name, COUNT(*) num_accounts
    FROM accounts a
    JOIN sales_reps s
        ON s.id = a.sales_rep_id
    GROUP BY s.id, s.name
    ORDER BY num_accounts;

SELECT DISTINCT id, name
    FROM sales_reps;

-- How many of the sales reps have more than 5 accounts that they manage?
SELECT s.id, s.name, COUNT(*) num_accounts
    FROM accounts a
    JOIN sales_reps s
        ON s.id = a.sales_rep_id
    GROUP BY s.id, s.name
    HAVING COUNT(*) > 5
    ORDER BY num_accounts;

-- How many accounts have more than 20 orders?
SELECT a.id, a.name, COUNT(*) num_orders
    FROM accounts a
    JOIN orders o
        ON a.id = o.account_id
    GROUP BY a.id, a.name
    HAVING COUNT(*) > 20
    ORDER BY num_orders;

-- Which account has the most orders?
SELECT a.id, a.name, COUNT(*) num_orders
    FROM accounts a
    JOIN orders o
        ON a.id = o.account_id
    GROUP BY a.id, a.name
    HAVING COUNT(*) > 20
    ORDER BY num_orders DESC
    LIMIT 1;

-- How many accounts spent more than 30,000 usd total across all orders?
SELECT a.id, a.name, SUM(o.total_amt_usd) total_usd
    FROM accounts a
    JOIN orders o
        ON a.id = o.account_id
    GROUP BY a.id, a.name
    HAVING SUM(o.total_amt_usd) > 30000
    ORDER BY total_usd;

-- How many accounts spent less than 1,000 usd total across all orders?
SELECT a.id, a.name, SUM(o.total_amt_usd) total_usd
    FROM accounts a
    JOIN orders o
        ON a.id = o.account_id
    GROUP BY a.id, a.name
    HAVING SUM(o.total_amt_usd) < 1000
    ORDER BY total_usd;

-- Which account has spent the most with us?
SELECT a.id, a.name, SUM(o.total_amt_usd) max_usd
    FROM accounts a
    JOIN orders o
        ON a.id = o.account_id
    GROUP BY a.id, a.name
    ORDER BY max_usd DESC
    LIMIT 1;

-- Which account has spent the least with us?
SELECT a.id, a.name, SUM(o.total_amt_usd) min_usd
    FROM accounts a
    JOIN orders o
        ON a.id = o.account_id
    GROUP BY a.id, a.name
    ORDER BY min_usd
    LIMIT 1;

-- Which accounts used facebook as a channel to contact customers more than 6 times?
SELECT a.id, a.name, COUNT(*) contact_count
    FROM accounts a
    JOIN web_events w
        ON a.id = w.account_id
    GROUP BY a.id, a.name, w.channel
    HAVING w.channel = 'facebook' AND COUNT(*) > 6
    ORDER BY contact_count;

-- Which account used facebook most as a channel?
SELECT a.id, a.name, COUNT(*) contact_count
    FROM accounts a
    JOIN web_events w
        ON a.id = w.account_id
    GROUP BY a.id, a.name, w.channel
    HAVING w.channel = 'facebook'
    ORDER BY contact_count DESC
    LIMIT 1;

-- Which channel was most frequently used by most accounts?
SELECT w.channel, COUNT(*) contact_count
    FROM accounts a
    JOIN web_events w
        ON a.id = w.account_id
    GROUP BY w.channel
    ORDER BY contact_count DESC
    LIMIT 1;

-- Find the sales in terms of total dollars for all orders in each year, ordered from greatest to least. Do you notice any trends in the yearly sales totals?
SELECT DATE_PART('year', occurred_at) AS year, SUM(total_amt_usd) AS total_spent
    FROM orders
    GROUP BY DATE_PART('year', occurred_at)
    ORDER BY total_spent DESC;

-- Which month did Parch & Posey have the greatest sales in terms of total dollars? Are all months evenly represented by the dataset?
SELECT DATE_PART('month', occurred_at) AS month,
        SUM(total_amt_usd) AS total_spent,
        COUNT(*) AS num_orders
    FROM orders
    GROUP BY DATE_PART('month', occurred_at)
    ORDER BY total_spent DESC;

-- Which year did Parch & Posey have the greatest sales in terms of total number of orders? Are all years evenly represented by the dataset?
SELECT DATE_PART('year', occurred_at) AS year,
        COUNT(*) AS num_orders
    FROM orders
    GROUP BY DATE_PART('year', occurred_at)
    ORDER BY num_orders DESC;

-- Which month did Parch & Posey have the greatest sales in terms of total number of orders? Are all months evenly represented by the dataset?
SELECT DATE_PART('month', occurred_at) AS month,
        COUNT(*) AS num_orders
    FROM orders
    GROUP BY DATE_PART('month', occurred_at)
    ORDER BY num_orders DESC;

-- In which month of which year did Walmart spend the most on gloss paper in terms of dollars?
SELECT DATE_PART('month', o.occurred_at) AS month,
        DATE_PART('year', o.occurred_at) AS year,
        SUM(o.gloss_amt_usd) AS gloss_spent
    FROM orders o
    JOIN accounts a
        ON o.account_id = a.id
    GROUP BY DATE_PART('month', o.occurred_at), DATE_PART('year', o.occurred_at), a.name
    HAVING a.name = 'Walmart'
    ORDER BY gloss_spent DESC
    LIMIT 1;

-- We would like to understand 3 different levels of customers based on the amount associated with their purchases. The top branch includes anyone with a Lifetime Value (total sales of all orders) greater than 200,000 usd. The second branch is between 200,000 and 100,000 usd. The lowest branch is anyone under 100,000 usd. Provide a table that includes the level associated with each account. You should provide the account name, the total sales of all orders for the customer, and the level. Order with the top spending customers listed first.
SELECT  a.name AS account,
        SUM(o.total_amt_usd) AS total_sales,
        CASE WHEN SUM(o.total_amt_usd) > 200000 THEN 'greater than 200,000'
            WHEN SUM(o.total_amt_usd) > 100000 AND SUM(o.total_amt_usd) < 200000 THEN '200,000 and 100,000'
            ELSE 'under 100,000' END AS level
    FROM orders o
    JOIN accounts a
        ON a.id = o.account_id
    GROUP BY 1
    ORDER BY 1;

-- We would now like to perform a similar calculation to the first, but we want to obtain the total amount spent by customers only in 2016 and 2017. Keep the same levels as in the previous question. Order with the top spending customers listed first.
SELECT  a.name AS account,
        SUM(o.total_amt_usd) AS total_sales,
        CASE WHEN SUM(o.total_amt_usd) > 200000 THEN 'greater than 200,000'
            WHEN SUM(o.total_amt_usd) > 100000 AND SUM(o.total_amt_usd) < 200000 THEN '200,000 and 100,000'
            ELSE 'under 100,000' END AS level
    FROM orders o
    JOIN accounts a
        ON a.id = o.account_id
    GROUP BY 1, o.occurred_at
    HAVING o.occurred_at BETWEEN '01-01-2016' AND '01-01-2017'
    ORDER BY 2 DESC;

-- We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders. Create a table with the sales rep name, the total number of orders, and a column with top or not depending on if they have more than 200 orders. Place the top sales people first in your final table.
SELECT  s.name AS sales_rep,
        COUNT(*) AS num_orders,
        CASE WHEN COUNT(*) > 200 THEN 'top'
            ELSE 'not' END AS top_performing
    FROM orders o
    JOIN accounts a
        ON a.id = o.account_id
    JOIN sales_reps s
        ON s.id = a.sales_rep_id
    GROUP BY 1
    ORDER BY 3 DESC, 2 DESC;

-- The previous didn't account for the middle, nor the dollar amount associated with the sales. Management decides they want to see these characteristics represented as well. We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders or more than 750000 in total sales. The middle group has any rep with more than 150 orders or 500000 in sales. Create a table with the sales rep name, the total number of orders, total sales across all orders, and a column with top, middle, or low depending on this criteria. Place the top sales people based on dollar amount of sales first in your final table. You might see a few upset sales people by this criteria!
SELECT  s.name AS sales_rep,
        COUNT(*) AS num_orders,
        SUM(o.total_amt_usd) AS total_sales,
        CASE WHEN (COUNT(*) > 200 OR SUM(o.total_amt_usd) > 750000) THEN 'top'
            WHEN (COUNT(*) > 150 OR SUM(o.total_amt_usd) > 500000) THEN 'middle'
            ELSE 'low' END AS top_performing
    FROM orders o
    JOIN accounts a
        ON a.id = o.account_id
    JOIN sales_reps s
        ON s.id = a.sales_rep_id
    GROUP BY 1
    ORDER BY 4 DESC;
