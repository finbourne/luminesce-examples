-- ============================================================

-- Description:
-- 1. In this query, we run an ETL process on some transactions.
-- 2. First, we load a XML file of transactions from Drive.
-- 3. Next, we transform the shape of the transaction data.
-- 4. Finally we upload the transaction data into LUSID.

-- ============================================================

-- Extract transaction data from LUSID Drive
@txn_data = 
use Drive.Xml
--file=/luminesce-examples/transactions.xml
--nodePath=transactions/transaction
--columns
TransactionID=transactionId
Type=type
TransactionDate=transactionDate
SettlementDate=settlementDate
Units=units
Price=price
TotalConsideration=totalConsideration
Currency=price/@currency
ClientInternal=clientInternal
enduse;

-- Set variables for the portfolio's scope and code
@@portfolio_scope = select 'IBOR';
@@portfolio_code = select 'uk-equity';

--Transform data using SQL
@transactions = 
select
@@portfolio_scope as PortfolioScope,
@@portfolio_code as PortfolioCode,
TransactionID as TxnId,
Type as Type,
TransactionDate as TransactionDate,
SettlementDate as SettlementDate,
Units as Units,
Price as TradePrice,
TotalConsideration as TotalConsideration,
Currency as SettlementCurrency,
ClientInternal as ClientInternal
from @txn_data;

-- Upload the transformed data into LUSID
select *
from Lusid.Portfolio.Txn.Writer
where ToWrite = @transactions;
