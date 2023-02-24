-- ===============================================================
-- Description:
-- In this query, make properties available to Luminesce.
--   we create instrument properties needed for the QC
-- This approach appends rather than overwrites the current inline property configuration
-- See the following page for further details:
-- https://support.lusid.com/knowledgebase/article/KA-01702/en-us
-- ===============================================================

-- 1. Add new properties

@newProperties =
values
   ('Instrument/ibor/Sector', 'Text', 'Sector', 'The sector that the instrument belongs to.');

@property_definition =
select Column3 as [DisplayName], 'Instrument' as [Domain], 'ibor' as [PropertyScope], Column3 as [PropertyCode], 'Property' as
   [ConstraintStyle], 'system' as [DataTypeScope], case
      when Column2 == 'Text'
         then 'string'
      else 'number'
      end as [DataTypeCode]
from @newProperties;

-- 2. Write new properties to Lusid

@create_properties =
select *
from Lusid.Property.definition.Writer
where ToWrite = @property_definition;

-- 3. The results of writing the new property definitions can be seen from the query below:

select *
from @create_properties;
