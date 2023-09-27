-- =============================================================
-- Description:
-- In this query, we create a set of LE identifier and
-- upload values for default and custom properties
-- =============================================================
@le_data =
select 
'2138002658CPO9NBH955' as IssuerId,
'GLENCORE PLC' as DisplayName, 
'GLENCORE PLC' as Description
;

select * from Lusid.LegalEntity.Writer where ToWrite = @le_data;