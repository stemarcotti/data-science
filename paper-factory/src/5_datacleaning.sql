-- In the accounts table, there is a column holding the website for each company. The last three digits specify what type of web address they are using. Pull these extensions and provide how many of each website type exist in the accounts table.
SELECT website_extension, COUNT(*)
    FROM(SELECT name,
                website,
                RIGHT(website, 3) AS website_extension
            FROM accounts) sub
    GROUP BY website_extension

-- There is much debate about how much the name (or even the first letter of a company name) matters. Use the accounts table to pull the first letter of each company name to see the distribution of company names that begin with each letter (or number).
SELECT initial, COUNT(*)
    FROM(SELECT name, LEFT(name, 1) AS initial
            FROM accounts) sub
    GROUP BY initial
    ORDER BY initial

-- Use the accounts table and a CASE statement to create two groups: one group of company names that start with a number and a second group of those company names that start with a letter. What proportion of company names start with a letter?
SELECT COUNT(*)
    FROM (SELECT name,
                CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9') THEN 0
                ELSE 1 END AS letter
            FROM accounts) sub
    GROUP BY sub.letter
    HAVING letter = 1

-- Consider vowels as a, e, i, o, and u. What proportion of company names start with a vowel, and what percent start with anything else?
SELECT COUNT(*)
    FROM (SELECT name,
                CASE WHEN LEFT(LOWER(name), 1) IN ('a', 'e', 'i', 'o', 'u') THEN 1
                ELSE 0 END as vowels
            FROM accounts) sub
    GROUP BY sub.vowels
    HAVING vowels = 1;

-- Use the accounts table to create first and last name columns that hold the first and last names for the primary_poc.
SELECT primary_poc,
        LEFT(primary_poc, POSITION(' ' IN primary_poc)-1) AS first_name,
        RIGHT(primary_poc, LENGTH(primary_poc) - POSITION(' ' IN primary_poc)) AS last_name
    FROM accounts;

-- Now see if you can do the same thing for every rep name in the sales_reps table. Again provide first and last name columns.
SELECT name,
        LEFT(name, POSITION(' ' IN name)-1) AS first_name,
        RIGHT(name, LENGTH(name) - POSITION(' ' IN name)) AS last_name
    FROM sales_reps;

-- Each company in the accounts table wants to create an email address for each primary_poc. The email address should be the first name of the primary_poc . last name primary_poc @ company name .com.
SELECT name,
        primary_poc,
        LEFT(primary_poc, POSITION(' ' IN primary_poc)-1) AS first_name,
        RIGHT(primary_poc, LENGTH(primary_poc) - POSITION(' ' IN primary_poc)) AS last_name,
        CONCAT(LOWER(LEFT(primary_poc, POSITION(' ' IN primary_poc)-1)), '.', LOWER(RIGHT(primary_poc, LENGTH(primary_poc) - POSITION(' ' IN primary_poc))), '@', LOWER(REPLACE(name, ' ', '')), '.com') AS email_address
    FROM accounts;

-- We would also like to create an initial password, which they will change after their first log in. The first password will be the first letter of the primary_poc's first name (lowercase), then the last letter of their first name (lowercase), the first letter of their last name (lowercase), the last letter of their last name (lowercase), the number of letters in their first name, the number of letters in their last name, and then the name of the company they are working with, all capitalized with no spaces.
SELECT name,
        primary_poc,
        LEFT(primary_poc, POSITION(' ' IN primary_poc)-1) AS first_name,
        RIGHT(primary_poc, LENGTH(primary_poc) - POSITION(' ' IN primary_poc)) AS last_name,
        CONCAT(LOWER(LEFT(primary_poc, 1)),
            RIGHT(LOWER(LEFT(primary_poc, POSITION(' ' IN primary_poc)-1)),1),
            LEFT(LOWER(RIGHT(primary_poc, LENGTH(primary_poc) - POSITION(' ' IN primary_poc))),1),
            RIGHT(LOWER(RIGHT(primary_poc, LENGTH(primary_poc) - POSITION(' ' IN primary_poc))),1),
            LENGTH(LEFT(primary_poc, POSITION(' ' IN primary_poc)-1)),
            LENGTH(RIGHT(primary_poc, LENGTH(primary_poc) - POSITION(' ' IN primary_poc))),
            UPPER(REPLACE(name, ' ', ''))) AS password
    FROM accounts;

-- use COALESCE for data cleaning
SELECT COALESCE(a.id, a.id) filled_id,
        a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id,
        COALESCE(o.account_id, a.id) account_id, o.occurred_at,
        COALESCE(o.standard_qty,0) standard_qty, COALESCE(o.gloss_qty,0) gloss_qty,
        COALESCE(o.poster_qty,0) poster_qty, COALESCE(o.total,0) total,
        COALESCE(o.standard_amt_usd,0) standard_amt_usd, COALESCE(o.gloss_amt_usd,0) gloss_amt_usd,
        COALESCE(o.poster_amt_usd,0) poster_amt_usd, COALESCE(o.total_amt_usd,0) total_amt_usd
    FROM accounts a
    LEFT JOIN orders o
    ON a.id = o.account_id
    WHERE o.total IS NULL;
