/*

------------------------------
Delete all portfolios in scope
------------------------------

WARNING: This script will bulk delete data from LUSID.

https://support.lusid.com/knowledgebase/category/?id=CAT-01099

*/

@@scope =
select 'luminesce-examples';

@allDataInScope =
select *, 'Delete' as WriteAction
from Lusid.Portfolio
where PortfolioScope = @@scope;

select *
from Lusid.Portfolio.Writer
where ToWrite = @allDataInScope;