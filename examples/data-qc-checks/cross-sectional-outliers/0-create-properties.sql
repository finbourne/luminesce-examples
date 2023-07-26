-- ===============================================================
-- Description:
-- In this query, we make properties available to Luminesce
-- by writing them to the Lusid.Property.Definition provider.
-- See the following page for further details:
-- https://support.lusid.com/knowledgebase/article/KA-01702/en-us
-- ===============================================================

-- 1. Define new properties

@newProperties =
values
   ('Instrument/ibor/Sector', 'Text','ibor', 'Sector', 'The sector that the instrument belongs to.'),
   ('Instrument/Fundamentals/pe_ratio','number','Fundamentals','pe_ratio','The P/E ratio.');

@property_definition =
select Column4 as [DisplayName], 'Instrument' as [Domain], Column3 as [PropertyScope], Column4 as [PropertyCode], 'Property' as
   [ConstraintStyle], 'system' as [DataTypeScope], 
   case
      when Column2 == 'Text'
         then 'string'
      else 'number'
      end as [DataTypeCode],
    case
      when Column4 == 'pe_ratio'
         then 'TimeVariant'
      else 'Perpetual'
      end as [Lifetime]
from @newProperties;

-- 2. Write new properties to Lusid.Property.Definition provider

@create_properties =
select *
from Lusid.Property.Definition.Writer
where ToWrite = @property_definition;

-- 3. The results of writing the new property definitions can be seen from the query below:

select *
from @create_properties;