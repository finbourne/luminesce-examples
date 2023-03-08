-- =============================================================
-- Description:
-- In this query, we create a set of LE identifier properties
-- =============================================================
-- 1. Create new property definition
@@propertyScope = select 'ibor';

@property_definition = select
'Custodian' as [DisplayName],
'LegalEntity' as [Domain],
@@propertyScope as [PropertyScope],
'Custodian' as [PropertyCode],
'Identifier' as [ConstraintStyle],
'system' as [DataTypeScope],
'string' as [DataTypeCode]
union all
values
('CustomLegalEntityId',  'LegalEntity',  @@propertyScope, 'CustomLegalEntityId', 'Identifier', 'system', 'string'),
('Country',  'LegalEntity',  @@propertyScope, 'Country', 'Property', 'system', 'string');

-- 2. Upload new properties to LUSID and print result to console here:
select * from Lusid.Property.Definition.Writer
where ToWrite = @property_definition;