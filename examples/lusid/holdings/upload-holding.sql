-- ============================================================

-- Description:
-- 1. In this query, we upload a holding into LUSID.
-- 2. First, we specify the portfolio code and scope and date.
-- 3. Next, we create a table for the holding data.
-- 4. Finally we upload the holding data into LUSID.

-- ============================================================

-- Set variables for the portfolio's scope and code
@@portfolio_scope =
select 'IBOR';

@@portfolio_code =
select 'uk-equity';

-- Set variable for the current date
@@today =
select date ('now');

-- Create table for an equity holding 
@holding_data =
select @@portfolio_scope as PortfolioScope, @@portfolio_code as PortfolioCode, @@today as 
   EffectiveAt, 'EQ77FCE7E4310C4' as ClientInternal, 100 as Units, 23.5 as CostPrice, 'GBP' as 
   CostCurrency, #2022-05-01# as PurchaseDate, #2022-05-04# as SettleDate, 'Set' as WriteAction;

-- Upload the holding data into LUSID
select *
from Lusid.Portfolio.Holding.Writer
where toWrite = @holding_data;