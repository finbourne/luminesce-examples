/*

---------------------------------
Add Accounts to Chart of Accounts
---------------------------------

In this snippet we add Accounts to a Chart of Accounts.

For more details on LUSID providers, see this page:

https://support.lusid.com/knowledgebase/category/?id=CAT-01099

Prerequisite setup steps:

    1. Setup a Chart of Accounts with the scope/code referenced below

*/

-- Step 1: Define some accounts

@@scope = select 'luminesce-examples';
@@code = select 'standardChartOfAccounts';

@accounts = values
-- Investments
('A0001-Investments-GovernmentBonds', 'Asset'),
('A0002-Investments-Equity', 'Asset'),
('A0003-Investments-General', 'Asset'),

-- Cash, commitments
('A0004_GBP-Settled-Cash', 'Asset'),
('A0005_USD-Settled-Cash', 'Asset'),

-- Sales and purchases for settlement
('A0006_GBP-Sales-To-Settle', 'Asset'),
('A0007_USD-Sales-To-Settle', 'Asset'),
('A0008_GBP-purchases-for-settlement', 'Asset'),
('A0009_USD-purchases-for-settlement', 'Asset'),
('A0010_GBP-Long-FX-To-Settle', 'Asset'),
('A0011_USD-Long-FX-To-Settle', 'Asset'),
('A0012_GBP-Short-FX-To-Settle', 'Asset'),
('A0013_USD-Short-FX-To-Settle', 'Asset'),

--Capital
('A0014_GBP-Capital', 'Asset'),
('A0015_USD-Capital', 'Asset'),

-- Gains and Losses
('A0016-Realised-Market-Gains', 'Income'),
('A0017-Realised-Fx-Gains', 'Income'),
('A0018-UnrealisedGains', 'Income'),

-- Subs, reds and accruals
('A0019-Accruals', 'Income'),
('A0020-Subscriptions', 'Asset'),
('A0021-Redemptions', 'Asset'),

-- Unknown catch alls
('A0101-Unknown-NA',  'Asset'),
('A0102-Unknown-PL',  'Revenue'),
('A0103-Unknown-CA', 'Capital');

@chartsOfAccountsAccounts = select
@@scope as ChartOfAccountsScope,
@@code as ChartOfAccountsCode,
column1 as AccountCode,
column1 as Description,
column2 as Type,
'Manual' as Control,
'Active' as Status
from @accounts;

-- Step 2: Assign Accounts onto a ChartOfAccount

select * from Lusid.ChartOfAccounts.Account.Writer 
where ToWrite = @chartsOfAccountsAccounts;