-- ============================================================
-- Description:
-- In this query, we then add some constituents with different
-- weights to the two new reference portfolios
-- ============================================================

-- Extract portfolio constituent data from LUSID Drive

@portfolio_data = use Drive.Excel
--file=/luminesce-examples/reference_port.xlsx
--worksheet=constituents
enduse;

@@scope = select 'luminesce-examples';

-- Transform extracted data

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
