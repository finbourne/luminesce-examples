/*

----------------------
Create posting modules
----------------------

In this snippet we create a posting module.

For more details on LUSID providers, see this page:

https://support.lusid.com/knowledgebase/category/?id=CAT-01099

Prerequisite setup steps:

    1. Setup a Chart of Accounts with the scope/code referenced below

*/

-- Step 1: Define a posting module

@@scope = select 'luminesce-examples';
@@code = select 'standardPostingModule';
@@writeAction = select 'Upsert';

@postingModule = 
select @@scope as PostingModuleScope, 
@@code as PostingModuleCode,
@@scope as ChartOfAccountsScope, 
'Active' as Status,
'standardChartOfAccounts' as ChartOfAccountsCode,
'Daily NAV' as Name,
'Posting module for daily NAV' as Description,
@@writeAction as WriteAction;

-- Step 2: Upload posting module into LUSID

select * from Lusid.PostingModule.Writer where ToWrite = @postingModule;