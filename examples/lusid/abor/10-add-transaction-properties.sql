/*

---------------------------------
Assign properties to Transactions
---------------------------------

In this snippet we assign properties to the Transactions.

For more details on LUSID providers, see this page:

https://support.lusid.com/knowledgebase/category/?id=CAT-01099

Prerequisite setup steps:

    1. Setup the property definitions referenced below 
    2. Setup the transactions referenced below

*/

@@scope = select 'luminesce-examples';
@@portfolioCode = select 'aborPortfolio';

@newProperties =
values
('txn_017', 'CashType', 'Collateral'),
('txn_018', 'CashType', 'TaxRebate'),
('txn_019', 'CashType', 'Collateral'),
('txn_020', 'CashType', 'ManagementFees'),
('txn_021', 'CashType', 'Collateral');

@tableOfData = 
select @@scope as PortfolioScope, 
@@portfolioCode as PortfolioCode,
@@scope as PropertyScope, 
column1 as TxnId, 
column2 as PropertyCode, 
column3 as Value
from @newProperties
;

select * from Lusid.Portfolio.Txn.Property.Writer where ToWrite = @tableOfData;