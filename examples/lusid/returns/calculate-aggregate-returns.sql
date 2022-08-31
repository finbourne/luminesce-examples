-- #################### SUMMARY ##############################

-- 1. In this query, we use the portfolio created in Steps 1 
--    and 2 to aggreate our returns and view various metrics

-- ###########################################################

-- Defining scope and code variables
@@portfolioScope =

select 'IBOR';

@@portfolioCode1 =

select 'uk-equity';

-- Read portfolio data
select * from Lusid.Portfolio.AggregatedReturn 
                   where ToLookUp = @returns