-- ===============================================================
-- Description:
-- In this file, we create instrument properties needed for the QC
-- We also make these properties available to Luminesce
-- ===============================================================

-- Define properties

@propertiesToReturn = values
('Instrument/ibor/QualityControlStatus', 'Text', 'QualityControlStatus'),
('Instrument/ibor/SourceFile', 'Text', 'SourceFile'),
('Instrument/ibor/Sector', 'Text', 'Sector'),
('Instrument/ibor/InternalRating', 'Text', 'InternalRating'),
('Instrument/ibor/SharesOutstanding', 'Decimal', 'SharesOutstanding'),
('Instrument/ibor/RegFlag', 'Text', 'RegFlag'),
('Instrument/ibor/MissingFields', 'Text', 'MissingFields');

-- Upsert properties into LUSID

@property_definition = select
Column3 as [DisplayName],
'Instrument' as [Domain],
'ibor' as [PropertyScope],
Column3 as [PropertyCode],
'Property' as [ConstraintStyle],
'system' as [DataTypeScope],
case when Column2 == "Text" then "string" else "number" end as [DataTypeCode]
from @propertiesToReturn;

@create_properties = select * from Lusid.Property.Definition.Writer
where ToWrite = @property_definition;

-- Upload properties to Luminesce factory

@inlinePropertiesInstrument = use Sys.Admin.File.SaveAs with @propertiesToReturn
--path=/config/lusid/factories/
--type:Csv
--fileNames
instrumentequityproviderfactory
enduse;

-- View system properties which have been saved

select * from Sys.File where Name like '%instrumentequityproviderfactory';

-- Query the results from the SimpleInstruments provider
-- The properties above will be returned as columns

select * from Lusid.Instrument.Equity wait 5 limit 10