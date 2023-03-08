-- =============================================================
-- Description:
-- In this query, we create a set of LE identifier and
-- upload values for default and custom properties
-- =============================================================
@le_data =

use Drive.Excel
--file=/lib-luminesce-examples/custodians.xlsx
--worksheet=custodians
enduse;

-- 1. Create LE identifiers and write in built properties to Lusid.LegalEntity
@legalentity_properties =
select custodian_name as DisplayName, custodian_name as Description, lei as LEI
from @le_data;

select * from Lusid.LegalEntity.Writer where ToWrite = @legalentity_properties;

-- 2. Write custom properties values for LE identifiers to Lusid.Property
@inst_properties =
select le.LEI, 'LEI' as EntityIdType, 'LegalEntity' as Domain, 'ibor' as PropertyScope, a.PropertyCode, a.Value, a.
   EntityId
from Lusid.LegalEntity le
inner join (
   select 'Custodian' as PropertyCode, custodian_code as Value, lei as EntityId
   from @le_data
   union
   select 'Country' as PropertyCode, country_code as Value, lei as EntityId
   from @le_data
   ) a
   on le.LEI = a.EntityId;

select * from Lusid.Property.Writer where ToWrite = @inst_properties;
