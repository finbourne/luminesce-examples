-- =============================================================
-- Description:
-- 1. In this query, we create a set of LE identifier properties
-- =============================================================



@@scope = select 'ibor';

@portfolio_data = use Drive.Excel
--file=/luminesce-examples/custodians.xlsx
--worksheet=portfolios
enduse;

@portfolios_for_upload = select  'Transaction' as PortfolioType,
port_code as PortfolioCode, 
@@scope as PortfolioScope,
port_code as DisplayName,
portfolio_currency as BaseCurrency,
'FirstInFirstOut' as AccountingMethod,
'' as Description, 
#2000-01-01# as Created,
''  as SubHoldingKeys
from @portfolio_data;

select *
from Lusid.Portfolio.Writer
where ToWrite = @portfolios_for_upload;