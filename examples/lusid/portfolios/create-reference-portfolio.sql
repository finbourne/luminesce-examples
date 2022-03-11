-- #################### SUMMARY ############################

-- 1. In this query, we crate a Reference Portfolio in LUSID

-- #########################################################

-- Defining scope and code variables
@@portfolioScope = select 'IBOR';
@@portfolioCode1 = select 'uk-equity-model';

-- Define the portfolio data
@create_portfolio = select 'Reference' as PortfolioType,
@@portfolioScope as PortfolioScope,
@@portfolioCode1 as PortfolioCode,
@@portfolioCode1 as DisplayName,
'' as Description,
#2000-01-01# as Created,
'GBP' as BaseCurrency;

-- Upload the portfolio into LUSID
@response_create_portfolio = select * from Lusid.Portfolio.Writer where ToWrite = @create_portfolio;

select * from @response_create_portfolio;