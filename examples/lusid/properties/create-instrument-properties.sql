-- ==========================================================
-- Description:
-- 1. In this query, we create a set of instrument properties
-- ==========================================================


@@propertyScope = select 'IBOR';

@property_definition =

select
'Sector' as [DisplayName],
'Instrument' as [Domain],
@@propertyScope as [PropertyScope],
'Sector' as [PropertyCode],
'Property' as [ConstraintStyle],
'system' as [DataTypeScope],
'string' as [DataTypeCode];

select * from Lusid.Property.Definition.Writer
where ToWrite = @property_definition;