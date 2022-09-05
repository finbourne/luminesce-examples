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
--file=/luminesce-examples/performance_data.csv
enduse;

-- Define the Returns data
@performance_data = 

select  @@portfolioScope as PortfolioScope, 
        @@portfolioCode1 as PortfolioCode, 
        'Production' as ReturnScope, 
        'Performance' as ReturnCode,
        'Daily' as Period, 
        return_date as EffectiveAt, 
        mv as OpeningMarketValue, 
        returns as RateOfReturn
from @performance_data_csv;

-- Upload returns into LUSID
@response_performance_data =

select *
from Lusid.Portfolio.Return.Writer
where ToWrite = @performance_data;

select *
from @response_performance_data;
