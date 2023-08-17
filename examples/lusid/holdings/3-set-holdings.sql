/*

-----------
Set Holding
-----------

Description:

    - In this query, we add new holdings to the portfolio
    - The example assumes we have a holdings file in LUSID Drive

More details:

    - https://support.lusid.com/knowledgebase/category/?id=CAT-01099

*/

-- Defining date of holding
@@file_date =
select strftime('20220301');

-- Defining scope and code variables
@@portfolioScope =
select 'luminesce-examples';

@@portfolioCode1 =
select 'UkEquity';

-- Loading in holdings data from Excel spreadsheet
@holdings_from_spreadsheet = 
use Drive.Excel with @@file_date
--file=/luminesce-examples/equity_holdings_{@@file_date}.xlsx
--worksheet=lusid_holdings
--addFileName
enduse;

-- Create new table to store holding's data
@holding_data = 
select  
@@portfolioScope as PortfolioScope,
@@portfolioCode1 as PortfolioCode,
holding_date as EffectiveAt,
InstrumentId as ClientInternal,
currency as CostCurrency,
units as Units,
'Set' as WriteAction
from @holdings_from_spreadsheet;
        
-- Write table to the portfolio
select * from Lusid.Portfolio.Holding.Writer where toWrite = @holding_data;