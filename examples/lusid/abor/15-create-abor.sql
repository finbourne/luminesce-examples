/*

--------------
Create an ABOR
--------------

In this snippet we create an ABOR.

For more details on LUSID providers, see this page:

https://support.lusid.com/knowledgebase/category/?id=CAT-01099

Prerequisite setup steps:

    1. Setup Abor Configuration referenced below
    2. Setup portfolio referenced below


*/

@@scope = select 'luminesce-examples';
@@code = select 'standardAbor';
@@aborConfigCode = select 'standardAborConfiguration';
@@portfolioCode = select 'aborPortfolio';
@@writeAction = select 'Upsert';

-- Step 1: Define an ABOR

@aborForUpload = select
@@scope as AborScope,
@@code as AborCode,
'SinglePortfolio' as PortfolioEntityType,
@@scope  as PortfolioScope,
@@portfolioCode as PortfolioCode,
@@portfolioCode as Description,
@@scope  as AborConfigurationScope,
@@aborConfigCode as AborConfigurationCode,
@@writeAction as WriteAction;

-- Step 2: Load ABOR into LUSID

select * from Lusid.Abor.Writer 
where ToWrite = @aborForUpload