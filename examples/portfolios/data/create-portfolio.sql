
-- Defining scope and code variables
@@portfolioScope = select 'luminesce-ibor';
@@portfolioCode1 = select 'uk-equity';

-- Create portfolio

@create_portfolio = select 'Transaction' as PortfolioType, 
@@portfolioScope as PortfolioScope,
@@portfolioCode1 as PortfolioCode,
@@portfolioCode1 as DisplayName,
 '' as Description,
#2000-01-01# as Created, 
'' as SubHoldingKeys,
'GBP' as BaseCurrency;

@response_create_portfolio = select * from Lusid.Portfolio.Writer where ToWrite = @create_portfolio;

select * from @response_create_portfolio

