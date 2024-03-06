/*

----------------------------
Create Transaction Portfolio
----------------------------

Description:

    - In this query, we create a Transaction Portfolio in LUSID

More details:

    - https://support.lusid.com/knowledgebase/category/?id=CAT-01099

*/

@@portfolioScope = select 'luminesce-examples';
@@portfolioCode1 = select 'UkEquity';

/*

Step 1: Defining base currency and creation date

*/

@@base_currency = select 'GBP';
@@created_date = select #2000-01-01#;

/*

Step 2: Define the portfolio data

*/

@create_portfolio =
select   'Transaction' as PortfolioType, 
         @@portfolioScope as PortfolioScope, 
         @@portfolioCode1 as PortfolioCode, 
         @@portfolioCode1 as DisplayName, 
         '' as Description, 
         @@created_date as Created,
         'Transaction/luminesce-examples/strategy' as SubHoldingKeys,
         @@base_currency as BaseCurrency;

/*

Step 3: Upload the portfolio into LUSID

*/

@response_create_portfolio =
select *
from Lusid.Portfolio.Writer
where ToWrite = @create_portfolio;

select *
from @response_create_portfolio;