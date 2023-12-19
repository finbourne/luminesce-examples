/*

------------------------------
Delete all properties in scope
------------------------------

WARNING: This script will bulk delete data from LUSID.

https://support.lusid.com/knowledgebase/category/?id=CAT-01099

*/

@@scope =
select 'luminesce-examples';

@allDataInScope =
select *, 'Delete' as WriteAction
from Lusid.Property.Definition
where PropertyScope = @@scope;

select *
from Lusid.Property.Definition.Writer
where ToWrite = @allDataInScope;