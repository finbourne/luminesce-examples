/*

----------------------------
Create an ABOR configuration
----------------------------

In this snippet we create an ABOR Configurtion.

For more details on LUSID providers, see this page:

https://support.lusid.com/knowledgebase/category/?id=CAT-01099

Prerequisite setup steps:

    1. Setup Chart of Accounts referenced below
    2. Setup a Posting Module wuth the scope/code referenced below
    3. Setup the recipe referenced below


*/

@@scope = select 'luminesce-examples';
@@chartOfAccountsCode = select 'standardChartOfAccounts';
@@code = select 'standardAborConfiguration';
@@writeAction = select 'Upsert';
@@PostingModuleIds = select 'luminesce-examples/standardPostingModule';

-- Step 1: Create an ABOR configuration

@aborConfigurationForUpload = select
@@code as AborConfigurationCode,
@@scope as AborConfigurationScope,
@@code as Description,
@@chartOfAccountsCode as ChartOfAccountsCode,
@@scope as ChartOfAccountsScope,
@@PostingModuleIds as PostingModuleIds,
@@code as Name,
@@scope as RecipeScope,
'marketValue' as RecipeCode,
@@writeAction as WriteAction;

-- Step 2: Load ABOR configurtion into LUSID

select * from Lusid.AborConfiguration.Writer
where ToWrite = @aborConfigurationForUpload;