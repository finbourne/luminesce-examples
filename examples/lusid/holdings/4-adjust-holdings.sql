/*

---------------
Adjust holdings
---------------

Description:

    - In this query, we adjust the values of two holdings.

More details:

    - https://support.lusid.com/knowledgebase/category/?id=CAT-01099

*/

-- Defining scope and code variables
@@portfolioScope = select 'luminesce-examples';

@@portfolioCode1 = select 'UkEquity';

-- Create new table to store two holdings' data
@holding_data = 
select 
@@portfolioScope as PortfolioScope,
@@portfolioCode1 as PortfolioCode,
#2022-04-21# as EffectiveAt,
'GB0031348658' as ClientInternal,
'GBP' as CostCurrency,
100000 as Units,
'Adjust' as WriteAction
union all 
select 
@@portfolioScope as PortfolioScope,
@@portfolioCode1 as PortfolioCode,
#2022-04-21# as EffectiveAt,
'GB00BH0P3Z91' as ClientInternal,
'GBP' as CostCurrency,
500 as Units,
'Adjust' as WriteAction;

-- Write table to the portfolio
select * from 
Lusid.Portfolio.Holding.Writer
where toWrite = @holding_data;