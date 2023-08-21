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
(@@scope, @@portfolioCode, 'csh_001', 'AborFundsIn', '2023-01-01', '2023-01-01', 1000000, 1, 1000000, 'GBP', 'CCY_GBP', 1),
(@@scope, @@portfolioCode, 'csh_002', 'AborFundsIn', '2023-01-01', '2023-01-01', 1000000, 1, 1000000, 'USD', 'CCY_USD', 0.79);


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
Column12 as TradeToPortfolioRate
from @transactions;

-- Step 2: Load transactions into LUSID

select *
from Lusid.Portfolio.Txn.Writer
where ToWrite = @createTransactions;