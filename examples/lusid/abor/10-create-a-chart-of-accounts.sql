/*

--------------------------
Create a Chart of Accounts
--------------------------

In this snippet we create a Chart of Accounts.

For more details on LUSID providers, see this page:

https://support.lusid.com/knowledgebase/category/?id=CAT-01099

*/

-- Step 1: Define the Chart of Accounts

@@scope = select 'luminesce-examples';
@@code = select 'standardChartOfAccounts';
@@name = select 'Standard Chart Of Accounts';
@@writeAction = select 'Upsert';

@chartOfAccounts =
select
@@scope as ChartOfAccountsScope,
@@code as ChartOfAccountsCode,
@@name as Name,
@@name as Description,
@@writeAction as WriteAction;

-- Step 2: Upload Chart of Account into LUSID

select * from Lusid.ChartOfAccounts.Writer where ToWrite = @chartOfAccounts;