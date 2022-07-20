-- In this example, we create some properties in LUSID, loaded from a CSV files

-- Load a CSV file of properties from LUSID Drive

@properties = use Drive.csv
--file=/luminesce-examples/lusid_properties.csv
enduse;

-- Transform the CSV data into a LUSID format

@property_definition = select
PropertyName as [DisplayName],
Domain as [Domain],
Scope as [PropertyScope],
PropertyCode as [PropertyCode],
'Property' as [ConstraintStyle],
'system' as [DataTypeScope],
DataType as [DataTypeCode]
from @properties;

-- Upload the properties into LUSID

select * from Lusid.Property.Definition.Writer
where ToWrite = @property_definition;

-- To inline properties, so they can be used in other Luminesce queries,
-- see this page here: https://support.lusid.com/knowledgebase/article/KA-01702/en-us