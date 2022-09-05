-- ===============================================================
-- Description:
-- 1. In this query, we create two Transaction Portfolios in LUSID
-- ===============================================================

-- Defining scope and code variables
@@portfolioScope =

select 'LuminesceReconExample';

@@portfolioCode1 =

select 'UkEquityTracker';

@@portfolioCode2 =

select 'UkEquityActive';

@@base_currency =

select 'GBP';

@@created_date = select #2000-01-01#;

-- Define the portfolio data
@create_portfolio =

select 'Transaction' as PortfolioType, @@portfolioScope as PortfolioScope, @@portfolioCode1 as
   PortfolioCode, @@portfolioCode1 as DisplayName, '' as Description, @@created_date as Created,
   '' as SubHoldingKeys, @@base_currency as BaseCurrency

union all

values (
   'Transaction', @@portfolioScope, @@portfolioCode2, @@portfolioCode2, '', @@created_date, '',
   @@base_currency
   );

-- Upload the portfolio into LUSID
@response_create_portfolio =

select *
from Lusid.Portfolio.Writer
where ToWrite = @create_portfolio;

select *
from @response_create_portfolio;
