/*

------------------
Create transaction
------------------

In this snippet we create some cash Transactions.

For more details on LUSID providers, see this page:

https://support.lusid.com/knowledgebase/category/?id=CAT-01099

Prerequisite setup steps:

    1. Setup a portfolio with scope/code per below
    2. Setup FundsIn Transaction Types

*/


@@scope = select 'luminesce-examples';
@@portfolioCode = select 'aborPortfolio';



/*  
    Step 1: Define some cash transactions
    
    In the step below, we create a transaction type called AborFundsIn which is configured to create
    Capital movements in the Journal Entry

*/

@transactions = 
values
(@@scope, @@portfolioCode, 'csh_001', 'FundsIn', '2023-01-01', '2023-01-03', 1000000, 1, 1000000, 'GBP', 'CCY_GBP', 1, 1),
(@@scope, @@portfolioCode, 'csh_002', 'FundsIn', '2023-01-01', '2023-01-03', 1000000, 1, 1000000, 'USD', 'CCY_USD', 0.79, 1),
(@@scope, @@portfolioCode, 'csh_003', 'FundsOut', '2023-02-01', '2023-02-03', 200000, 1, 200000, 'GBP', 'CCY_GBP', 1, 1),
(@@scope, @@portfolioCode, 'csh_004', 'FundsOut', '2023-02-01', '2023-02-03', 200000, 1, 200000, 'USD', 'CCY_USD', 0.81, 1),

--Fx Spots
(@@scope, @@portfolioCode, 'txn_015', 'FxSpotBuy', '2023-02-15', '2023-02-17', 100000, 1, 80000, 'GBP', 'CCY_USD', 0.8, 0.8),
(@@scope, @@portfolioCode, 'txn_016', 'FxSpotBuy', '2023-02-16', '2023-02-18', 50000, 1, 40000, 'GBP', 'CCY_USD', 0.8, 0.8),

--Fees, Collateral and other cash
(@@scope, @@portfolioCode, 'txn_017', 'CashIn', '2023-02-15', '2023-02-17', 10000, 1, 10000, 'GBP', 'CCY_GBP', 1, 1),
(@@scope, @@portfolioCode, 'txn_018', 'CashIn', '2023-02-16', '2023-02-18', 20000, 1, 30000, 'GBP', 'CCY_GBP', 1, 1),
(@@scope, @@portfolioCode, 'txn_019', 'CashIn', '2023-02-15', '2023-02-17', 10000, 1, 10000, 'GBP', 'CCY_GBP', 1, 1),
(@@scope, @@portfolioCode, 'txn_020', 'CashIn', '2023-02-16', '2023-02-18', 40000, 1, 40000, 'GBP', 'CCY_GBP', 1, 1),
(@@scope, @@portfolioCode, 'txn_021', 'CashIn', '2023-02-16', '2023-02-18', 40000, 1, 40000, 'USD', 'CCY_USD', 1, 1)
;


@createTransactions = 
select
column1 as PortfolioScope,
column2 as PortfolioCode,
column3 as TxnId,
column4 as Type,
column5 as TransactionDate,
column6 as SettlementDate,
column7 as Units,
column8 as TradePrice,
column9 as TotalConsideration,
column10 as SettlementCurrency,
column11 as LusidInstrumentId,
Column12 as TradeToPortfolioRate,
column13 as ExchangeRate,
'abor' as Source
from @transactions;

-- Step 2: Load transactions into LUSID

select *
from Lusid.Portfolio.Txn.Writer
where ToWrite = @createTransactions;