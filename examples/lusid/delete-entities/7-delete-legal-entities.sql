/*

----------------------------------
Delete all Legal Entities in scope
----------------------------------

WARNING: This script will bulk delete data from LUSID.

https://support.lusid.com/knowledgebase/category/?id=CAT-01099

*/

@all_legal_entities = select 
*,
'Delete' as WriteAction
from Lusid.LegalEntity limit 1000;

select * from Lusid.LegalEntity.Writer
where ToWrite = @all_legal_entities 