-- ===============================================================
-- Description:
-- 1. In this query, we run an ETL process on a corporate action 
-- source.
-- 2. Firstly, create a corporate action source and assign it to 
-- a data table.
-- 3. We then write this table to LUSID using the provider.
-- ===============================================================

-- Defining corporate action scope and code.

@@corporateActionSourceScope = select 'luminesce-examples';
@@corporateActionSourceCode = select 'uk-equity';

-- Define a table containing sample information.

@corporate_action_source_table =

select  "Sample Action Source" as DisplayName,
        "Source description" as Description,
        @@corporateActionSourceScope as CorporateActionSourceScope,
        @@corporateActionSourceCode as CorporateActionSourceCode,
        "instrument-scope" as InstrumentScope,
        "Insert" as WriteAction,
        #2000-01-01# as AsAt;

-- Write the corporate action source to LUSID.

select * from lusid.CorporateAction.Source.Writer
where toWrite = @corporate_action_source_table;