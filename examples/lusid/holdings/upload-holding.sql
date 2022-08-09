-- ============================================================

-- Description:
-- 1. In this query, we run an ETL process on holdings.
-- 2. First, we load a CSV file of holdings from Drive.
-- 3. Next, we transform the shape of the holdings data.
-- 4. Finally we upload the holding data into LUSID.

-- ============================================================

-- Extract holding data from LUSID Drive
@holding_data =
use Drive.Csv
--file=/luminesce-examples/holdings.csv
enduse;

-- Set variables for the portfolio's scope and code
@@portfolio_scope =
select 'IBOR';

@@portfolio_code =
select 'uk-equity';

-- Set variable for the current date
@@today =
select date ('now');

-- Transform data using SQL
@holdings = select 
@@portfolio_scope as PortfolioScope, 
@@portfolio_code as PortfolioCode, 
@@today as EffectiveAt, 
ClientInternal as ClientInternal, 
Units as Units, 
Cost as CostPrice, 
'GBP' as CostCurrency, 
PurchaseDate as PurchaseDate, 
SettleDate as SettleDate, 
'Set' as WriteAction
from @holding_data;

-- Upload the holding data into LUSID
select *
from Lusid.Portfolio.Holding.Writer
where toWrite = @holdings;