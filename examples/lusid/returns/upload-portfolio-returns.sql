-- #################### SUMMARY ##############################

-- 1. In this query, we upload performance data into LUSID 

-- ###########################################################

-- Defining scope and code variables
@@portfolioScope =

select 'IBOR';

@@portfolioCode1 =

select 'uk-equity';

-- Load performance data from .csv
@performance_data_csv = 
use Drive.Csv
--file=/luminesce-examples/performance-data.csv
enduse;

-- Define the Returns data
@performance_data = 

select 
    'Transaction' as PortfolioType
    @@portfolio_scope as PortfolioScope,
    @@portfolio_code as PortfolioCode,
    -- RG this probably doesn't work
    date as Date,
    mv as MarketValue,
    returns as Returns
from @performance_data_csv;

-- Upload returns into LUSID
@response_performance_data = 

select *
from Lusid.Portfolio.Return.Writer
where ToWrite = @performance_data;

select *
from @response_create_portfolio;
