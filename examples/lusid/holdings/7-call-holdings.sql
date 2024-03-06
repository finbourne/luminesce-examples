/*

-----------
call Holding
-----------

Description:

    - In this query, we will call the holding for the holdings that i just set

More details:

    - https://support.lusid.com/knowledgebase/category/?id=CAT-01099

*/

-- Defining scope and code variables
@@portfolioScope =
select 'luminesce-examples';

@@portfolioCode =
select 'UkEquity';

select * from Lusid.Portfolio.Holding
where PortfolioScope= @@portfolioScope
and PortfolioCode= @@portfolioCode