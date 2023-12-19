/*

-----------------------
Delete all COA in scope
-----------------------

WARNING: This script will bulk delete data from LUSID.

https://support.lusid.com/knowledgebase/category/?id=CAT-01099

*/

@@scope =
select 'luminesce-examples';

@allDataInScope =
select *, 'Delete' as WriteAction
from Lusid.ChartOfAccounts
where ChartOfAccountsScope = @@scope;

select *
from Lusid.ChartOfAccounts.Writer
where ToWrite = @allDataInScope;
