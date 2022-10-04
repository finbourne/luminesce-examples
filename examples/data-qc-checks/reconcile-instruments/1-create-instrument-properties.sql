-- ==================================================================
-- Description:
-- 1. In this example, we create some properties in LUSID,
-- loaded from an Excel files. To inline properties, so they can be used
-- in other Luminesce queries, see this page here:
-- https://support.lusid.com/knowledgebase/article/KA-01702/en-us
-- ===================================================================

-- Load a CSV file of properties from LUSID Drive

@properties = use Drive.Excel
--file=/luminesce-examples/fi_instrument_master.xlsx
--worksheet=properties
enduse;

-- Transform the CSV data into a LUSID format

@property_definition = select
PropertyCode as [DisplayName],
'Instrument' as [Domain],
Scope as [PropertyScope],
PropertyCode as [PropertyCode],
'Property' as [ConstraintStyle],
'system' as [DataTypeScope],
DataType as [DataTypeCode]
from @properties;

-- Upload the properties into LUSID

select * from Lusid.Property.Definition.Writer
where ToWrite = @property_definition;