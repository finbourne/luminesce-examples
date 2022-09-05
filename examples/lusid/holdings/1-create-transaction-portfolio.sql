-- ===============================================================
-- Description:
-- In this query, we create a Transaction Portfolio in LUSID
-- ===============================================================

-- Defining scope and code variables
@@portfolioScope =

select 'luminesce-examples';

@@portfolioCode1 =

select 'UkEquity';

-- Defining base currency and creation date
@@base_currency =

select 'GBP';

@@created_date = select #2000-01-01#;

-- Define the portfolio data
@create_portfolio =

select   'Transaction' as PortfolioType, 
         @@portfolioScope as PortfolioScope, 
         @@portfolioCode1 as PortfolioCode, 
         @@portfolioCode1 as DisplayName, 
         '' as Description, 
         @@created_date as Created,
         '' as SubHoldingKeys, 
         @@base_currency as BaseCurrency;

-- Upload the portfolio into LUSID
@response_create_portfolio =

select *
from Lusid.Portfolio.Writer
where ToWrite = @create_portfolio;

select *
from @response_create_portfolio;