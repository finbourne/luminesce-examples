-- ==================================================================
-- Description:
-- 1. In this example, we create some custom properties in LUSID,
-- loaded from an Excel file.
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
'ibor' as [PropertyScope],
PropertyCode as [PropertyCode],
'Property' as [ConstraintStyle],
'system' as [DataTypeScope],
DataType as [DataTypeCode]
from @properties;

-- Upload the properties into LUSID

select * from Lusid.Property.Definition.Writer
where ToWrite = @property_definition;