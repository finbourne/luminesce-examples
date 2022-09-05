-- ================================================================
-- Description:
-- This query shows you how to load an Excel file from LUSID Drive
-- We use the worksheet parameter to load a specific worksheet
-- See further details on the Drive.Excel provider here:
-- https://support.lusid.com/knowledgebase/article/KA-01682/en-us
-- ================================================================

@@worksheet = select 'holdings';

@holdings = use Drive.Excel with @@worksheet
--file=/luminesce-examples/equity_holding.xlsx
--worksheet={@@worksheet}
enduse;

select * from @holdings;
