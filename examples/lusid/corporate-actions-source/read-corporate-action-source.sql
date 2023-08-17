/*

-----------------------------
Read Corporate Action Sources
-----------------------------

Description:

    - In this query, we read a corporate action source from LUSID.

More details:

    https://support.lusid.com/knowledgebase/article/KA-02065/en-us

*/

@@corporateActionSourceScope = select 'luminesce-examples';
@@corporateActionSourceCode = select 'example-corp-act-source';


/*

Step 1: Retrieve corresponding corporate action source from LUSID.

*/

select * 
from Lusid.CorporateAction.Source
where CorporateActionSourceScope=@@corporateActionSourceScope
and CorporateActionSourceCode=@@corporateActionSourceCode