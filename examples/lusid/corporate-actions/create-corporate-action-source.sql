-- ===============================================================
-- Description:
-- In this query, we write a corporate action source to LUSID.
-- ===============================================================

-- Defining corporate action scope and code.

@@corporateActionScope = select 'luminesce-examples';
@@corporateActionCode = select 'uk-equity';

-- Define a table containing sample information.
@corporate_action_source_table = 

select  "Sample Actions Source" as DisplayName,
        @@corporateActionScope as CorporateActionSourceScope,
        @@corporateActionCode as CorporateActionSourceCode,
        @@corporateActionScope as InstrumentScope,
        #2000-01-01# as AsAt;

-- Write the corporate action source to LUSID.
select * from lusid.CorporateAction.Source.Writer
where toWrite = @corporate_action_source_table;