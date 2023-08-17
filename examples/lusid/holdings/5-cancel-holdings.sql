/*

---------------
Cancel Holdings
---------------

Description:

    - In this query, we cancel the two holdings.

More details:

    - https://support.lusid.com/knowledgebase/category/?id=CAT-01099

*/

-- Defining scope and code variables
@@portfolioScope =
select 'luminesce-examples';

@@portfolioCode1 =
select 'UkEquity';

-- Defining the attributes of a cancellation
@deletion_table = 
select 
@@portfolioScope as PortfolioScope,
@@portfolioCode1 as PortfolioCode,
#2022-04-21# as EffectiveAt,
'Cancel' as WriteAction;

-- Performs the holdings cancellation 
select * 
from Lusid.Portfolio.Holding.Writer 
where toWrite = @deletion_table;