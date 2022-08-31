-- ===============================================================
-- Description:
-- 1. In this query, make properties available to Luminesce.
-- 2. WARNING: running this will overwrite your current config.
-- 3. This configuration should be managed centrally.
-- Further details contained on this page:
-- https://support.lusid.com/knowledgebase/article/KA-01702/en-us
-- ===============================================================

-- Define properties to be exposed to Luminesce

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

-- Query the results from the SimpleInstruments provider
-- The properties above will be returned as columns 

select * from Lusid.Instrument.SimpleInstrument limit 10
