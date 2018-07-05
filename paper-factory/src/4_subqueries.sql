-- Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.
SELECT t3.rep_name, t3.region_name, t3.sum_usd
    FROM (SELECT region_name, MAX(sum_usd) AS sum_usd
            FROM (SELECT s.name rep_name, r.id AS region_name, SUM(o.total_amt_usd) AS sum_usd
                    FROM orders o
                    JOIN accounts a
                        ON o.account_id = a.id
                    JOIN sales_reps s
                        ON a.sales_rep_id = s.id
                    JOIN region r
                        ON s.region_id = r.id
                    GROUP BY s.name, r.id) t1
            GROUP BY region_name) t2
    JOIN (SELECT s.name AS rep_name, r.id AS region_name, SUM(o.total_amt_usd) AS sum_usd
            FROM orders o
            JOIN accounts a
                ON o.account_id = a.id
            JOIN sales_reps s
                ON a.sales_rep_id = s.id
            JOIN region r
                ON s.region_id = r.id
            GROUP BY s.name, r.id) t3
        ON t3.region_name = t2.region_name AND t3.sum_usd = t2.sum_usd;
-- Same query using with
WITH    t1 AS (SELECT s.name rep_name, r.id AS region_name, SUM(o.total_amt_usd) AS sum_usd
                FROM orders o
                JOIN accounts a
                    ON o.account_id = a.id
                JOIN sales_reps s
                    ON a.sales_rep_id = s.id
                JOIN region r
                    ON s.region_id = r.id
                GROUP BY s.name, r.id),
        t2 AS (SELECT region_name, MAX(sum_usd) AS sum_usd
                FROM t1
                GROUP BY region_name),
        t3 AS (SELECT s.name AS rep_name, r.id AS region_name, SUM(o.total_amt_usd) AS sum_usd
                FROM orders o
                JOIN accounts a
                    ON o.account_id = a.id
                JOIN sales_reps s
                    ON a.sales_rep_id = s.id
                JOIN region r
                    ON s.region_id = r.id
                GROUP BY s.name, r.id)

SELECT t3.rep_name, t3.region_name, t3.sum_usd
    FROM t2
    JOIN t3
        ON t3.region_name = t2.region_name AND t3.sum_usd = t2.sum_usd;



-- For the region with the largest (sum) of sales total_amt_usd, how many total (count) orders were placed?
SELECT r.name region_name, COUNT(o.total) AS total_orders
    FROM region r
    JOIN sales_reps s
        ON s.region_id = r.id
    JOIN accounts a
        ON a.sales_rep_id = s.id
    JOIN orders o
        ON o.account_id = a.id
    GROUP BY region_name
    HAVING SUM(o.total_amt_usd) = (
        SELECT MAX(sum_usd)
        FROM (SELECT r.name region_name, SUM(total_amt_usd) AS sum_usd
                FROM region r
                JOIN sales_reps s
                    ON s.region_id = r.id
                JOIN accounts a
                    ON a.sales_rep_id = s.id
                JOIN orders o
                    ON o.account_id = a.id
                GROUP BY region_name) sub);

-- For the name of the account that purchased the most (in total over their lifetime as a customer) standard_qty paper, how many accounts still had more in total purchases?
SELECT COUNT(*)
    FROM (SELECT a.name AS account_name, SUM(o.total) as total_paper
            FROM accounts a
            JOIN orders o
                ON a.id = o.account_id
            GROUP BY account_name
            HAVING SUM(o.total) > (
                SELECT SUM(o.standard_qty) AS std_paper
                    FROM accounts a
                    JOIN orders o
                        ON a.id = o.account_id
                    GROUP BY a.id
                    ORDER BY std_paper DESC
                    LIMIT 1)
            ORDER BY total_paper DESC) sub;

-- For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, how many web_events did they have for each channel?
SELECT w.channel, COUNT(*)
    FROM web_events w
    JOIN accounts a
        ON w.account_id = a.id
    GROUP BY a.name, w.channel
    HAVING a.name = (
        SELECT a.name AS account
            FROM accounts a
            JOIN orders o
                ON a.id = o.account_id
            GROUP BY account
            ORDER BY SUM(o.total_amt_usd) DESC
            LIMIT 1)
    ORDER BY COUNT(*) DESC

-- What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?
SELECT AVG(total_spent)
    FROM (SELECT SUM(o.total_amt_usd) AS total_spent
            FROM accounts a
            JOIN orders o
                ON a.id = o.account_id
            GROUP BY a.name
            ORDER BY total_spent DESC
            LIMIT 10) sub;

-- What is the lifetime average amount spent in terms of total_amt_usd for only the companies that spent more than the average of all orders.
SELECT AVG(spent)
    FROM (SELECT a.name AS account, AVG(o.total_amt_usd) AS spent
            FROM orders o
            JOIN accounts a
                ON a.id = o.account_id
            GROUP BY 1
            HAVING AVG(o.total_amt_usd) > (
                SELECT AVG(total_amt_usd)
                    FROM orders)) sub
