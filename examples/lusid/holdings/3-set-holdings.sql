-- =======================================================
-- Description:
-- 1. In this query, we add a new holding to the portfolio
-- =======================================================

-- Defining date of holding
@@file_date =

date('20220301');

-- Defining scope and code variables
@@portfolioScope =

select 'luminesce-examples';

@@portfolioCode1 =

select 'UkEquity';

@holdings_from_spreadsheet = 

-- Loading in holdings data from Excel spreadsheet
use Drive.Excel with @@file_date
--file=/luminesce-examples/equity_holdings_{@@file_date}.xlsx
--worksheet=lusid_holdings
--addFileName
enduse;

-- Create new table to store holding's data
@holding_data = 

select  @@portfolioScope as PortfolioScope,
        @@portfolioCode1 as PortfolioCode,
        holding_date as EffectiveAt,
        InstrumentId as ClientInternal,
        currency as CostCurrency,
        units as Units,
        12.3 as CostPrice,
        #2022-04-19# as PurchaseDate,
        #2022-04-21# as SettleDate,
        'QuantitativeSignal' as Strategy,
        'Set' as WriteAction
from @holdings_from_spreadsheet;
        

-- Write table to the portfolio
select * from Lusid.Portfolio.Holding.Writer where toWrite = @holding_data;
