@@file_name = select 'daily_transactions_20220215.csv';
@@folder_name = select '/test-transactions/new';

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

@save_to_drive = use Drive.SaveAs with @transactions, @@file_name, @@folder_name
--path=/{@@folder_name}
--fileNames={@@file_name}
enduse;

select * from @save_to_drive;