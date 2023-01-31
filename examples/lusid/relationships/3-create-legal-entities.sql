-- =============================================================
-- Description:
-- In this query, we create a set of LE identifier entities
-- =============================================================

@le_data = use Drive.Excel
--file=/luminesce-examples/custodians.xlsx
--worksheet=custodians
enduse;

@table_of_data = select custodian_code as Custodian, 
lei as CustomLegalEntityId,
custodian_name as DisplayName, 
custodian_name as Description,
country_code as Country
from @le_data;

select * from Lusid.LegalEntity.Writer where ToWrite = @table_of_data;