-- =============================================================
-- Description:
-- In this query, we create the issuer itself, using the 
-- identifier we created in previous step
-- =============================================================
@le_data =
select 
'2138002658CPO9NBH955' as IssuerId,
'GLENCORE PLC' as DisplayName, 
'GLENCORE PLC' as Description
;

select * from Lusid.LegalEntity.Writer where ToWrite = @le_data;