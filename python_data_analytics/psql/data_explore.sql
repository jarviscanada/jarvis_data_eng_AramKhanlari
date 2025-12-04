-- Show table schema 
\d+ retail;

-- Q1: Show first 10 rows
SELECT * FROM retail limit 10;

-- Q2: Check # of records
SELECT COUNT(*) FROM retail;
--count
-----------
-- 1067371
--(1 row)

-- Q3: number of clients (e.g. unique client ID)
SELECT COUNT(DISTINCT customer_id) FROM retail;
-- count
---------
--  5942
--(1 row)

--- Q4: invoice date range (e.g. max/min dates)
SELECT MAX(invoice_date), MIN(invoice_date) FROM retail;
--             max         |         min
--    ---------------------+---------------------
--     2011-12-09 12:50:00 | 2009-12-01 07:45:00
--    (1 row)
--    
--- Q5: number of SKU/merchants (e.g. unique stock code)
SELECT COUNT(DISTINCT stock_code) FROM retail;
--      count
--    -------
--      5305
--    (1 row)
--    
--- Q6: Calculate average invoice amount excluding invoices with a negative amount (e.g. canceled orders have negative amount)
--    - an invoice consists of one or more items where each item is a row in the df
--    - hint: you need to use GROUP BY and HAVING
SELECT AVG(amount)
    FROM (
    SELECT invoice_no, SUM(quantity * unit_price) AS amount
    FROM retail
    GROUP by invoice_no
    HAVING SUM(quantity * unit_price)>0 )
    t;
--      avg
--    -----------------
--     523.30375861254
--    
--- Q7: Calculate total revenue (e.g. sum of unit_price * quantity)
SELECT SUM(unit_price * quantity) AS sum FROM retail;
--       sum
--    -------------------
--     19287250.48156795
--    (1 row)
--    
--- Q8: Calculate total revenue by YYYYMM
--    - hints
--        - Create a new YYYMM column
--        e.g. you want convert 2010-10-28 (datetime) to 201010 (integer). 201010 = 2010 *100 + 10.
--        - The following functions might be useful: [extract](https://www.postgresqltutorial.com/postgresql-extract/), [cast](https://www.postgresqltutorial.com/postgresql-cast/)
SELECT EXTRACT(YEAR FROM invoice_date)*100+EXTRACT(MONTH FROM invoice_date) AS yyyymm, SUM(unit_price * quantity) AS sum
FROM retail
GROUP BY yyyymm
ORDER BY yyyymm;
--    yyyymm |        sum
--    --------+--------------------
--     200912 |  799847.1070248298
--     201001 |  624032.8889988398
--     201002 |  533091.4239873991
--     201003 |  765848.7573522086
--     201004 |  590580.4292229896
--     201005 |  615322.8275831081
--     201006 |  679786.6066389903
--     201007 |  575236.3583013527
--     201008 |  656776.3375795335
--     201009 |  853650.4280918705
--     201010 | 1045168.3456046395
--     201011 | 1422654.6357879487
--     201012 | 1126445.4660070688
--     201101 |  560000.2572612464
--     201102 |   498062.648327291
--     201103 |  683267.0775260255
--     201104 |  493207.1188206653
--     201105 |  723333.5063029006
--     201106 |  691123.1159918569
--     201107 |  681300.1073726917
--     201108 |  682680.5073843151
--     201109 | 1019687.6165212316
--     201110 | 1070704.6637893468
--     201111 | 1461756.2424829267
--     201112 | 433686.00760667026
--    (25 rows)
--    ```