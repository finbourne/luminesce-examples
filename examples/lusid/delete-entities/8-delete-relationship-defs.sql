/*

--------------------------------------------
Delete all non system relationships in scope
--------------------------------------------

WARNING: This script will bulk delete data from LUSID.

https://support.lusid.com/knowledgebase/category/?id=CAT-01099

*/

@table_of_data = 
select *, 
'Delete' as WriteAction 
from Lusid.Relationship.Definition
where Scope in (select Scope from Lusid.Scope where Scope not in ('system', 'default'));

select * from Lusid.Relationship.Definition.Writer
where ToWrite = @table_of_data