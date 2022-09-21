-- ===============================================================
-- Description:
-- In this query, we read a corporate action source from LUSID.
-- ===============================================================

-- Defining corporate action scope and code.

@@corporateActionScope = select 'luminesce-examples';
@@corporateActionCode = select 'uk-equity';

-- Retrieve corresponding corporate action source from LUSID.
select * from lusid.CorporateAction.Source
where CorporateActionSourceScope=@@corporateActionScope
and CorporateActionSourceCode=@@corporateActionCode