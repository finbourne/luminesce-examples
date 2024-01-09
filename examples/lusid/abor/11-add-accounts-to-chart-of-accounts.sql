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
('A0001-Investments', 'Asset'),

-- Cash, commitments
('A0002-Settled-Cash', 'Asset'),

-- Sales and purchases for settlement
('A0003-Sales-To-Settle', 'Asset'),
('A0004-Purchases-To-Settle', 'Asset'),
('A0005-Long-FX-To-Settle', 'Asset'),
('A0006-Short-FX-To-Settle', 'Asset'),

--Capital
('A0007-Capital', 'Capital'),

-- Gains and Losses
('A0008-Realised-Market-Gains', 'Income'),
('A0009-Realised-Fx-Gains', 'Income'),
('A0010-UnrealisedGains', 'Income'),

-- Subs, reds and accruals
('A0011-Accruals', 'Income'),
('A0012-Subscriptions', 'Asset'),
('A0013-Redemptions', 'Asset'),

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
