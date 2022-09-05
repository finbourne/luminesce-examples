-- =========================================================
-- Description:
-- 1. In this query, we cancel the ownership of two holdings.
-- =========================================================

-- Defining scope and code variables
@@portfolioScope =

select 'LuminesceHoldingsExample';

@@portfolioCode1 =

select 'UkEquity';

-- Create new table to store holding's data
@holding_data = 

select  @@portfolioScope as PortfolioScope,
        @@portfolioCode1 as PortfolioCode,
        #2022-04-21# as EffectiveAt,
        'LUID_00003D6Z' as LusidInstrumentId,
        'Cancel' as WriteAction

        union all 

select  @@portfolioScope as PortfolioScope,
        @@portfolioCode1 as PortfolioCode,
        #2022-04-21# as EffectiveAt,
        'LUID_00003D76' as LusidInstrumentId,
        'Cancel' as WriteAction;


-- Write table to the portfolio
select * from Lusid.Portfolio.Holding.Writer where toWrite = @holding_data;