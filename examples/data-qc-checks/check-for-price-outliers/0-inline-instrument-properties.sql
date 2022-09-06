-- ===============================================================
-- Description:
-- In this query, make properties available to Luminesce.
--   we create instrument properties needed for the QC
-- This approach appends rather than overwrites the current inline property configuration
-- See the following page for further details:
-- https://support.lusid.com/knowledgebase/article/KA-01702/en-us
-- ===============================================================

-- 1. Get the contents of the current instrument provider factory

@@currentFileContent = 
select Content from Sys.File where Name = 'instrumentequityproviderfactory';

@currentFileLines = 
select Value from Tools.Split
where Original = @@currentFileContent
    and Delimiters = '
' -- newline
    and [Index] <> 1 -- skip header
    and Value is not null
    and Trim(Value, ' ') <> '';

@splitFileLines =
select OriginalIndex, 
    case when [Index] = 1 then Value else null end as PropertyKey, 
    case when [Index] = 2 then Value else null end as DataType, 
    case when [Index] = 3 then Value else null end as Alias,
    case when [Index] = 4 then Value else null end as [Description]
from Tools.Split
where Original in @currentFileLines and Delimiters = ',';

@currentProperties = 
select group_concat(PropertyKey) as column1, 
    group_concat(DataType) as column2, 
    case when group_concat(Alias) <> '' then group_concat(Alias) else null end as column3, -- convert to null to avoid duplicates in union
    group_concat(Description) as column4
from @splitFileLines 
group by OriginalIndex
;

-- 2. Add new properties HERE:

@newProperties = values
('Instrument/ibor/QualityControlStatus', 'Text', 'QualityControlStatus', 'The quality control status of the instrument.'),
('Instrument/ibor/SourceFile', 'Text', 'SourceFile', 'The source file of the instrument.'),
('Instrument/ibor/Sector', 'Text', 'Sector', 'The sector that the instrument belongs to.'),
('Instrument/ibor/InternalRating', 'Text', 'InternalRating', 'The internal rating of the instrument.'),
('Instrument/ibor/SharesOutstanding', 'Decimal', 'SharesOutstanding', 'The number of shares outstanding for the instrument.'),
('Instrument/ibor/RegFlag', 'Text', 'RegFlag', 'Red flag.'),
('Instrument/ibor/MissingFields', 'Text', 'MissingFields', 'Missing fields.');

-- 3. Join new and old properties

@updatedProperties = 
select * from @currentProperties
where column1 not in (select column1 from @newProperties)
union
select * from @newProperties;

-- 4. Write new and old properties into LUSID

@inlinePropertiesInstrument = use Sys.Admin.File.SaveAs with @updatedProperties
--path=/config/lusid/factories/
--type:Csv
--fileNames
instrumentequityproviderfactory
enduse;

-- 5. View system properties which have been saved

select Content from Sys.File wait 5 where Name like '%instrumentequityproviderfactory';

-- 6 Upsert properties into LUSID

@property_definition = select
Column3 as [DisplayName],
'Instrument' as [Domain],
'ibor' as [PropertyScope],
Column3 as [PropertyCode],
'Property' as [ConstraintStyle],
'system' as [DataTypeScope],
case when Column2 == 'Text' then 'string' else 'number' end as [DataTypeCode]
from @updatedProperties;

@create_properties = select * from Lusid.Property.Definition.Writer
where ToWrite = @property_definition;

-- Query the results from the Equity Instruments provider
-- The properties above will be returned as columns

select * from Lusid.Instrument.Equity wait 5 limit 10