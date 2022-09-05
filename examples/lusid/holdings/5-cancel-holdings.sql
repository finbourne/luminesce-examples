-- =========================================================
-- Description:
-- 1. In this query, we cancel the ownership of two holdings.
-- =========================================================

-- Defining scope and code variables
@@portfolioScope =

select 'luminesce-examples';

@@portfolioCode1 =

select 'UkEquity';

-- Defining the attributes of a cancellation
@deletion_table = 
select @@portfolioScope as PortfolioScope,
        @@portfolioCode1 as PortfolioCode,
        #2022-04-21# as EffectiveAt,
        'Cancel' as WriteAction;

-- Performs the holdings cancellation 
select * 
from Lusid.Portfolio.Holding.Writer 
where toWrite = @deletion_table;