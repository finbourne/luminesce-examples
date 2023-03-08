-- ==================================================
-- Description:
-- 1. In this query, we load transactions into LUSID
-- ===================================================

@@file_date =

select strftime('20221001');

@@portfolioScope =

select 'abor-recon-test';

@transactions_from_excel =

use Drive.Excel with @@file_date
--file=/luminesce-examples/equity_holdings_{@@file_date}.xlsx
--worksheet=abor_transactions
--addFileName
enduse;

@txns =
select
'EQ' || InstrumentId as ClientInternal,
portfolio as PortfolioCode,
scope as PortfolioScope,
'GBP' as TradeCurrency,
'GBP' as SettlementCurrency,
#2022-02-01# as TransactionDate,
#2022-02-01# as SettlementDate,
price as TradePrice,
TxnId as TxnId,
transaction_type as Type,
total_consideration as TotalConsideration,
units as Units,
'Upsert' as WriteAction
from @transactions_from_excel;

-- step 3: load a transaction

@load_txn =
select * from Lusid.Portfolio.Txn.Writer
where ToWrite = @txns;

select * from @load_txn;