/*

-------------------------------
Delete all GL Profiles in scope
-------------------------------

WARNING: This script will bulk delete data from LUSID.

https://support.lusid.com/knowledgebase/category/?id=CAT-01099

*/

@@scope =
select 'luminesce-examples';

@allDataInScope =
select *, 'Delete' as WriteAction
from Lusid.GeneralLedgerProfile
where ChartOfAccountsScope = @@scope;

select *
from Lusid.GeneralLedgerProfile.Writer
where ToWrite = @allDataInScope;