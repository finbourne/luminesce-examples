-- ====================================================
-- Description:
-- 1. In this query, we create Transaction Portfolios in LUSID
-- in two scopes
-- ===========================================================

-- Defining scope and code variables

@@file_date = select strftime('20221001');
@@base_currency = select 'GBP';
@@created_date = select #2000-01-01#;

@portfolios_from_excel = use Drive.Excel with @@file_date
--file=/luminesce-examples/equity_holdings_{@@file_date}.xlsx
--worksheet=portfolios
--addFileName
enduse;


-- Define the portfolio data

@create_portfolio =

select
'Transaction' as PortfolioType,
portfolio_scope as PortfolioScope,
portfolio_code as PortfolioCode,
portfolio_code as DisplayName,
portfolio_code as Description,
@@created_date as Created,
'' as SubHoldingKeys,
@@base_currency as BaseCurrency
from @portfolios_from_excel;

-- Upload the portfolio into LUSID

@response_create_portfolio =

select *
from Lusid.Portfolio.Writer
where ToWrite = @create_portfolio;

select *
from @response_create_portfolio;