/*

-------------------------------
Delete all Instruments in scope
-------------------------------

WARNING: This script will bulk delete data from LUSID.

https://support.lusid.com/knowledgebase/category/?id=CAT-01099

*/

@@scope =
select 'luminesce-examples';

@allDataInScope =
select *, 'SoftDelete' as WriteAction
from Lusid.Instrument
where Scope = @@scope
limit 500;

select *
from Lusid.Instrument.Writer
where ToWrite = @allDataInScope;
