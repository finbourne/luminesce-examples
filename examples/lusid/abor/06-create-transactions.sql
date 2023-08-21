/*

------------------
Create transactions
------------------

In this snippet we create some Transactions.

For more details on LUSID providers, see this page:

https://support.lusid.com/knowledgebase/category/?id=CAT-01099

Prerequisite setup steps:

    1. Setup a portfolio with scope/code per below
    2. Setup Buy and Sell Transaction Types
    3. Setup instruments with the ClientInternal instrument IDs referenced below

*/


@@scope = select 'luminesce-examples';
@@portfolioCode = select 'aborPortfolio';

-- Step 1: Define some transactions

@transactions = 
values

-- Equity Transactions
(@@scope, @@portfolioCode, 'txn_001', 'Buy', '2023-01-01', '2023-01-02', 1000, 10, 10000, 'GBP', 'FBNABOR001', 1),
(@@scope, @@portfolioCode, 'txn_002', 'Buy', '2023-01-01', '2023-01-02', 2000, 12, 10000, 'GBP', 'FBNABOR002', 1),
(@@scope, @@portfolioCode, 'txn_003', 'Buy', '2023-01-01', '2023-01-02', 3000, 13, 10000, 'USD', 'FBNABOR003', 0.8),
(@@scope, @@portfolioCode, 'txn_004', 'Buy', '2023-01-01', '2023-01-02', 4000, 14, 10000, 'USD', 'FBNABOR004', 0.8),
(@@scope, @@portfolioCode, 'txn_005', 'Buy', '2023-01-01', '2023-01-02', 5000, 15, 10000, 'GBP', 'FBNABOR005', 1),
(@@scope, @@portfolioCode, 'txn_006', 'Sell', '2023-02-01', '2023-02-02', 1000, 21, 21000, 'GBP', 'FBNABOR001', 1),
(@@scope, @@portfolioCode, 'txn_007', 'Sell', '2023-02-01', '2023-02-02', 1000, 22, 22000, 'GBP', 'FBNABOR002', 1),
(@@scope, @@portfolioCode, 'txn_008', 'Sell', '2023-02-01', '2023-02-02', 1000, 23, 23000, 'USD', 'FBNABOR003', 0.78),
(@@scope, @@portfolioCode, 'txn_009', 'Sell', '2023-02-01', '2023-02-02', 1000, 24, 24000, 'USD', 'FBNABOR004', 0.78),
(@@scope, @@portfolioCode, 'txn_010', 'Sell', '2023-02-01', '2023-02-02', 1000, 25, 25000, 'GBP', 'FBNABOR005', 1),

--Bond transactions
(@@scope, @@portfolioCode, 'txn_011', 'Buy', '2023-01-01', '2023-01-02', 100000, 100, 100000, 'USD', 'FBNBND001', 0.8),
(@@scope, @@portfolioCode, 'txn_012', 'Buy', '2023-01-01', '2023-01-02', 200000, 98, 200000, 'GBP', 'FBNBND003', 1),
(@@scope, @@portfolioCode, 'txn_013', 'Sell', '2023-02-01', '2023-02-02', 50000, 100, 50000, 'USD', 'FBNBND001', 0.78),
(@@scope, @@portfolioCode, 'txn_014', 'Sell', '2023-02-01', '2023-02-02', 100000, 102, 100000, 'GBP', 'FBNBND003', 1);


-- Step 2: Load transactions into LUSID

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
column11 as ClientInternal,
column12 as TradeToPortfolioRate
from @transactions;

-- Upload the transformed data into LUSID

select *
from Lusid.Portfolio.Txn.Writer
where ToWrite = @createTransactions;