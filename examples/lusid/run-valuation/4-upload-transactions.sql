-- ============================================================

-- Description:
-- In this file, we load transaction data from the Excel sheet

-- ============================================================

-- Load transaction from Excel file on Drive

@transactions_data = use Drive.Excel
--file=/luminesce-examples/simplified_valuation_data.xlsx
--worksheet=transactions
enduse;

-- Transform transactions data

@txns =
select
instrument_id as Figi,
portfolio_code as PortfolioCode,
'ibor' as PortfolioScope,
currency as TradeCurrency,
currency as SettlementCurrency,
txn_trade_date as TradeDate,
txn_settle_date  as SettlementDate,
txn_price as TradePrice,
txn_id as TxnId,
txn_type as Type,
txn_consideration as TotalConsideration,
txn_units as Units,
'Upsert' as WriteAction
from @transactions_data;

-- load transactions into LUSID

select * from Lusid.Portfolio.Txn.Writer
where ToWrite = @txns;
