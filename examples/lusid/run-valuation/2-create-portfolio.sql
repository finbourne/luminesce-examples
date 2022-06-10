-- #################### SUMMARY ##############################

-- 1. In this query, we create a Transaction Portfolio in LUSID

-- ###########################################################

-- Defining scope and code variables
@@portfolioScope =

select 'ibor';

@@portfolioCode1 =

select 'EQUITY_UK';

-- Define the portfolio data
@create_portfolio =

select 'Transaction' as PortfolioType, @@portfolioScope as PortfolioScope, @@portfolioCode1 as
   PortfolioCode, @@portfolioCode1 as DisplayName, '' as Description, #2000-01-01# as Created, ''
   as SubHoldingKeys, 'GBP' as BaseCurrency;

-- Upload the portfolio into LUSID
@response_create_portfolio =

select *
from Lusid.Portfolio.Writer
where ToWrite = @create_portfolio;

select *
from @response_create_portfolio;