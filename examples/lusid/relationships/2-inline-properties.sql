-- =============================================================
-- Description:
-- In this query, we inline the Legal Entity properties
-- =============================================================

@@currentFileContent =
select Content from Sys.File where Name = 'legalentityproviderfactory';

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

@newProperties =
values
('LegalEntity/ibor/Custodian',  '_identifier', 'Custodian', 'Custodian'),
('LegalEntity/ibor/CustomLegalEntityId',  '_identifier', 'CustomLegalEntityId',  'CustomLegalEntityId'),
('LegalEntity/ibor/Country',  'Text', 'Country', 'Country');

-- 3. Join new and old properties

@updatedProperties =
select * from @currentProperties
union
select * from @newProperties;

-- 4. Write new and old properties into LUSID

@inlineProperties = use Sys.Admin.File.SaveAs with @newProperties
--path=/config/lusid/factories
--type:Csv
--fileNames
legalentityproviderfactory
enduse;

-- 5. View system properties which have been saved

select Content from Sys.File wait 5 where Name like '%legalentityproviderfactory%';
