/*

-------------------------------
Create Corporate Action Sources
-------------------------------

Description:

    - In this query, we create a corporate action source in LUSID

More details:

    https://support.lusid.com/knowledgebase/article/KA-02066/en-us

*/

@@corporateActionSourceScope = select 'luminesce-examples';
@@corporateActionSourceCode = select 'example-corp-act-source';

/*

Step 1: Define a table containing sample information.

*/

@corporate_action_source_table =
select  
"Sample Action Source" as DisplayName,
"Source description" as Description,
@@corporateActionSourceScope as CorporateActionSourceScope,
@@corporateActionSourceCode as CorporateActionSourceCode,
"Insert" as WriteAction;

/*

Step 2: Write the corporate action source to LUSID.

*/

select * 
from Lusid.CorporateAction.Source.Writer
where ToWrite = @corporate_action_source_table;