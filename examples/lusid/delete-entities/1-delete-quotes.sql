/*

--------------------------
Delete all quotes in scope
--------------------------

WARNING: This script will bulk delete data from LUSID.

https://support.lusid.com/knowledgebase/category/?id=CAT-01099

*/

@@scope =
select 'luminesce-examples';

@allDataInScope =
select *, 'Delete' as WriteAction
from Lusid.Instrument.Quote
where QuoteScope = @@scope;

select *
from Lusid.Instrument.Quote.Writer
where ToWrite = @allDataInScope;