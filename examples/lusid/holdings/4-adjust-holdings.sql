-- =======================================================
-- Description:
-- 1. In this query, we adjust the values of two holdings.
-- =======================================================

-- Defining scope and code variables
@@portfolioScope =

select 'luminesce-examples';

@@portfolioCode1 =

select 'UkEquity';

-- Create new table to store two holdings' data
@holding_data = 

select  @@portfolioScope as PortfolioScope,
        @@portfolioCode1 as PortfolioCode,
        #2022-04-21# as EffectiveAt,
        'LUID_00003D6Z' as LusidInstrumentId,
        'GBP' as CostCurrency,
        100000 as Units,
        'Adjust' as WriteAction

        union all 

select  @@portfolioScope as PortfolioScope,
        @@portfolioCode1 as PortfolioCode,
        #2022-04-21# as EffectiveAt,
        'LUID_00003D76' as LusidInstrumentId,
        'GBP' as CostCurrency,
        500 as Units,
        'Adjust' as WriteAction;


-- Write table to the portfolio
select * from Lusid.Portfolio.Holding.Writer where toWrite = @holding_data;