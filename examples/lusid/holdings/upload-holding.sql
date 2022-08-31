-- ============================================================
-- Description:
-- 1. In this query, we run an ETL process on holdings.
-- 2. First, we load a CSV file of holdings from Drive.
-- 3. Next, we transform the shape of the holdings data.
-- 4. Finally we upload the holding data into LUSID.
-- ============================================================

-- Extract holding data from LUSID Drive

@holding_data = use Drive.Csv
--file=/luminesce-examples/holdings.csv
enduse;

-- Set variables for the portfolio's scope and code

@@portfolio_scope = SELECT 'IBOR';

@@portfolio_code = SELECT 'uk-equity';

-- Set variable for the current date

@@today = SELECT #2022-01-01#;

-- Transform data using SQL@holdings =
SELECT @@portfolio_scope as portfolioscope,
       @@portfolio_code as portfoliocode,
       @@today as effectiveat,
       clientinternal as clientinternal,
       units as units,
       cost as costprice,
       'GBP' as costcurrency,
       purchasedate as purchasedate,
       settledate as settledate,
       'Set' as writeaction
FROM   @holding_data;

-- Upload the holding data into LUSID

SELECT *
FROM   lusid.portfolio.holding.writer
WHERE  towrite = @holdings;
