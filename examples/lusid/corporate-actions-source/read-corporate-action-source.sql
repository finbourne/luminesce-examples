-- ===============================================================
-- Description:
-- In this query, we read a corporate action source from LUSID.
-- ===============================================================

-- Defining corporate action scope and code.

@@corporateActionSourceScope = select 'luminesce-examples';
@@corporateActionSourceCode = select 'uk-equity';

-- Retrieve corresponding corporate action source from LUSID.
select * from lusid.CorporateAction.Source
where CorporateActionSourceScope=@@corporateActionSourceScope
and CorporateActionSourceCode=@@corporateActionSourceCode