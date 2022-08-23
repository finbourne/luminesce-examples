-- ============================================================
-- Description:
-- In this query, we create 2 reference portfolios.
-- We then add some constituents with different weights to
-- these reference portfolios
-- ============================================================

-- Extract portfolio constituent data from LUSID Drive

@portfolio_data = use Drive.Excel
--file=/luminesce-examples/reference_port.xlsx
--worksheet=constituents
enduse;

-- Define some variables for portfolio creation

@@scope = select 'luminesce-examples';
@@iso_currency = select 'GBP';
@portfolio_codes = select distinct port as [port_code], currency from @portfolio_data;

-- Define the upsert reference portfolio request

@create_portfolio_request = select 'Reference' as PortfolioType,
@@scope as PortfolioScope,
port_code as PortfolioCode,
port_code as DisplayName,
port_code as Description,
#2000-01-01# as Created,
currency  as BaseCurrency from @portfolio_codes;

-- Upload the portfolio into LUSID

select * from Lusid.Portfolio.Writer
where ToWrite = @create_portfolio_request;

-- Extract constituent data from excel

@constituents =
select
currency as Currency,
effective_date as EffectiveFrom,
port as PortfolioCode,
@@scope as PortfolioScope,
inst_id as ClientInternal,
weight as Weight
from @portfolio_data;

-- Add constituents to reference portfolios

select * from Lusid.Portfolio.Constituent.Writer
where ToWrite = @constituents;
