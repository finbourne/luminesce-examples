/*

-------------------------------
Create Journal Entry (JE) Lines
-------------------------------

In this snippet we create an ABOR.

For more details on LUSID providers, see this page:

https://support.lusid.com/knowledgebase/category/?id=CAT-01099

Prerequisite setup steps:

    1. Create the ABOR referenced below


*/

@@scope = select 'luminesce-examples';
@@code = select 'standardAbor';

--Step 1: Generate JE Lines

select * from Lusid.Abor.JELine
where AborScope = @@scope 
and AborCode = @@code
and StartDate = '2023-01-02'
and EndDate = '2023-03-03';