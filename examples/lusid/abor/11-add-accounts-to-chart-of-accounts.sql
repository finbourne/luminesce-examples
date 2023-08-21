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
('A0001-Investments-UK', 'Investments', 'Asset', 'Manual', 'Active'),
('A0002-Investments-USA', 'Investments', 'Asset', 'Manual', 'Active'),
('A0003-Investments-General', 'Investments', 'Asset', 'Manual', 'Active'),

-- Cash, commitments and capital
('A0004-Cash', 'Cash', 'Asset', 'Manual', 'Active'),
('A0005-Commitments', 'Commitments', 'Asset', 'Manual', 'Active'),
('A0006-Capital', 'Capital', 'Capital', 'Manual', 'Active'),

-- Gains and Losses
('A0007-RealisedGains', 'RealisedGains', 'Revenue', 'Manual', 'Active'),
('A0008-UnrealisedGains', 'UnrealisedGains', 'Income', 'Manual', 'Active'),
('A0009-Accruals', 'UnrealisedGains', 'Income', 'Manual', 'Active'),

-- Unknown catch alls
('A0010-Unknown-NA', 'Investments', 'Asset', 'Manual', 'Active'),
('A0011-Unknown-PL', 'P&L Other', 'Revenue', 'Manual', 'Active'),
('A0011-Unknown-CA', 'Capital', 'Capital', 'Manual', 'Active');


@chartsOfAccountsAccounts = select
@@scope as ChartOfAccountsScope,
@@code as ChartOfAccountsCode,
column1 as AccountCode,
column2 as Description,
column3 as Type,
column4 as Control,
column5 as Status
from @accounts;

-- Step 2: Assign Accounts onto a ChartOfAccount

select * from Lusid.ChartOfAccounts.Account.Writer 
where ToWrite = @chartsOfAccountsAccounts;