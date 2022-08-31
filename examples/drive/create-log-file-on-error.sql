-- ============================================================
-- Description:
-- 1. In this query, we create a table of two transactions.
-- 2. These transactions are saved to LUSID Drive.
-- ============================================================

-- Define some variables for file and folder name

@@file_name = select 'daily_transactions_20220215.csv';
@@folder_name = select '/luminesce-examples/new';

-- populate a variable with a table of transactions

@transactions = 
select "GB" as ClientInternal,
"Test" as PortfolioCode,
"IborTest" as PortfolioScope, 
"GBP" as TradeCurrency,
"GBP" as SettlementCurrency,
#2022-01-01# as TradeDate,
#2022-01-03#  as SettlementDate,
100 as TradePrice,
"trd_001" as TxnId, 
"StockIn" as Type,
10 as Units
union
select
"GB" as ClientInternal,
"Test" as PortfolioCode,
"IborTest" as PortfolioScope, 
"GBP" as TradeCurrency,
"GBP" as SettlementCurrency,
#2022-01-01# as TradeDate,
#2022-01-03#  as SettlementDate,
100 as TradePrice,
"trd_002" as TxnId, 
"StockIn" as Type,
10 as Units;

-- Write the transaction table to LUSID Drive
-- You can pass in the @@file_name and @@folder_name as variables.
-- You can also pass the file_name as folder name as strings

@save_to_drive = use Drive.SaveAs with @transactions, @@file_name, @@folder_name
--path=/{@@folder_name}
--fileNames={@@file_name}
enduse;

select * from @save_to_drive;