-- ============================================================

-- Description:
-- In this query, make properties available to Luminesce.
-- This approach appends rather than overwrites the current
-- inline property configuration
-- See the following page for further details:
-- https://support.lusid.com/knowledgebase/article/KA-01702/en-us

-- ============================================================

-- 1. Get the contents of the current instrument provider factory

@@currentFileContent = 
select Content from Sys.File where Name = 'instrumentsimpleinstrumentproviderfactory';

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
    case when [Index] = 3 then Value else null end as Alias
from Tools.Split
where Original in @currentFileLines and Delimiters = ',';

@currentProperties = 
select group_concat(PropertyKey) as column1, 
    group_concat(DataType) as column2, 
    case when group_concat(Alias) <> '' then group_concat(Alias) else null end as column3 -- convert to null to avoid duplicates in union
from @splitFileLines 
group by OriginalIndex
;

-- 2. Add new properties HERE:

@newProperties = 
values 
('Instrument/ibor/Rating', 'Decimal', 'Rating'),
('Instrument/ibor/Country', 'Text', 'Country');

-- 3. Join new and old properties

@updatedProperties = 
select * from @currentProperties
union
select * from @newProperties;

-- 4. Write new and old properties into LUSID

@inlinePropertiesInstrument = use Sys.Admin.File.SaveAs with @updatedProperties
--path=/config/lusid/factories/
--type:Csv
--fileNames
instrumentsimpleinstrumentproviderfactory
enduse;

-- 5. View system properties which have been saved

select Content from Sys.File wait 5 where Name like '%instrumentsimpleinstrumentproviderfactory%';