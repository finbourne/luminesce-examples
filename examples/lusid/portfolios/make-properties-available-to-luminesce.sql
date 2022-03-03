-- WARNING: running this will overwrite your current config

-- Description: Make properties available to Luminesce
-- This only needs to be completed once

@propertiesToReturn = values
('Instrument/IBOR/Sector', 'Text', 'Sector'),
('Instrument/IBOR/CashType', 'Text', 'CashType'),
('Instrument/IBOR/InstrumentType', 'Text', 'InstrumentType');

-- Upload properties to Luminesce factory

@inlinePropertiesInstrument = use Sys.Admin.File.SaveAs with @propertiesToReturn
--path=/config/lusid/factories/
--type:Csv
--fileNames
instrumentsimpleinstrumentproviderfactory
enduse;

-- View system properties which have been saved

select * from Sys.File where Name like '%providerfactory';