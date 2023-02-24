-- ===============================================================
-- Description:
-- In this query, make properties available to Luminesce.
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
group by OriginalIndex;

-- 2. Add new properties
@newProperties = values
    ('Instrument/ibor/QualityControlStatus', 'Text', 'QualityControlStatus', 'The quality control status of the instrument.'),
    ('Instrument/ibor/SourceFile', 'Text', 'SourceFile', 'The source file of the instrument.'),
    ('Instrument/ibor/Sector', 'Text', 'Sector', 'The sector that the instrument belongs to.'),
    ('Instrument/ibor/InternalRating', 'Text', 'InternalRating', 'The internal rating of the instrument.'),
    ('Instrument/ibor/SharesOutstanding', 'Decimal', 'SharesOutstanding', 'The number of shares outstanding for the instrument.'),
    ('Instrument/ibor/RegFlag', 'Text', 'RegFlag', 'Red flag.'),
    ('Instrument/ibor/MissingFields', 'Text', 'MissingFields', 'Missing fields.'),
    ('Instrument/ibor/DomCcy', 'Text', 'DomCcy', 'Domestic Currency.'),
    ('Instrument/ibor/DisplayName', 'Text', 'DisplayName', 'Display Name.');

-- 3. Join new and old properties
@updatedProperties =
    select * from @currentProperties
        where column1
        not in (select column1 from @newProperties )
    union
    select *from @newProperties;

-- 4. Upsert properties into LUSID
@property_definition =
select Column3 as [DisplayName], 'Instrument' as [Domain], 'ibor' as [PropertyScope], Column3 as [PropertyCode], 'Property' as
   [ConstraintStyle], 'system' as [DataTypeScope], case
      when Column2 == 'Text'
         then 'string'
      else 'number'
      end as [DataTypeCode]
from @updatedProperties;

@create_properties =
select * from Lusid.Property.definition.Writer
    where ToWrite = @property_definition;

-- The results of writing the new property definitions can be seen from the query below:
select * from @create_properties;