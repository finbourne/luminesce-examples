-- ===============================================================
-- Description:
-- In this query, we upsert a portfolio, instruments and transactions
-- using the data pulled from a file in LUSID Drive.
-- ===============================================================

-- Extract transaction data from LUSID Drive

@txn_data =
use Drive.Excel
--file=/luminesce-examples/pdf-report-data.xlsx
enduse;

-- Set variables for the portfolio's scope and code

@@portfolio_scope = select 'pdf-report';
@@portfolio_code = select 'uk-equity';
@@portfolio_name = select 'UK EQUITY';

-- Define the portfolio data

@create_portfolio =
select 'Transaction' as PortfolioType,
@@portfolio_scope as PortfolioScope,
@@portfolio_code as PortfolioCode,
@@portfolio_name as DisplayName,
'' as Description,
#2000-01-01# as Created,
''as SubHoldingKeys,
'GBP' as BaseCurrency;

-- Upload the portfolio into LUSID

@response_create_portfolio =
select *
from Lusid.Portfolio.Writer
where ToWrite = @create_portfolio;

-- Get instrument data

@equity_instruments =
select
Name as DisplayName,
ISIN as Isin,
ClientInternal as ClientInternal,
SEDOL as Sedol,
'GBP' as DomCcy
from @txn_data;

-- Upload the transformed data into LUSID

@response_write = 
select *
from Lusid.Instrument.Equity.Writer
where ToWrite = @equity_instruments;

--Transform data using SQL

@transactions =
select
@@portfolio_scope as PortfolioScope,
@@portfolio_code as PortfolioCode,
t.TransactionID as TxnId,
t.Type as Type,
t.TransactionDate as TransactionDate,
t.SettlementDate as SettlementDate,
t.Units as Units,
t.Price as TradePrice,
t.TotalConsideration as TotalConsideration,
t.Currency as SettlementCurrency,
t.ClientInternal as ClientInternal,
r.LusidInstrumentId as LusidInstrumentId
from @txn_data t
inner join @response_write r
where t.ClientInternal = r.ClientInternal;

-- Upload the transformed data into LUSID

@response = 
select *
from Lusid.Portfolio.Txn.Writer
wait 5
where ToWrite = @transactions;

select * from @response;