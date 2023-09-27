/*

------------------------------
Create a Transaction portfolio
------------------------------

In this snippet we load a Transaction portfolio into LUSID.

For more details on LUSID providers, see this page:

https://support.lusid.com/knowledgebase/category/?id=CAT-01099

*/

-- Step 1: Define the portfolio details

@@scope = select 'luminesce-examples';
@@portfolioCode = select 'CapitalStructureHierarchyExample';
@@writeAction = select 'Upsert';

@createPortfolio = select 'Transaction' as PortfolioType,
@@scope as PortfolioScope,
@@portfolioCode as PortfolioCode,
@@scope  as InstrumentScopes,
@@portfolioCode as DisplayName,
@@portfolioCode  as Description,
#2000-01-01# as Created,
'' as SubHoldingKeys,
'GBP' as BaseCurrency,
@@writeAction as WriteAction
;

-- Step 2: Load portfolio into LUSID

select *
from Lusid.Portfolio.Writer
where ToWrite = @createPortfolio;