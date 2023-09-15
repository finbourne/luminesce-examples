/*

----------------------------
Create instrument properties
----------------------------

In this snippet we create some instrument properties.

For more details on LUSID providers, see this page:

https://support.lusid.com/knowledgebase/category/?id=CAT-01099

*/

@@scope = select 'luminesce-examples';

-- Step 1: Define the property definitions

@newProperties =
values
('Instrument', @@scope, 'Sector', 'string'),
('Instrument', @@scope, 'AssetClass', 'string'),
('Instrument', @@scope, 'InternalRating', 'number');

@propertyDefinitions =
select 
Column1 as [Domain], 
Column2 as [PropertyScope], 
Column3 as [PropertyCode], 
Column3 as [DisplayName], 
'Property' as [ConstraintStyle],
'system' as [DataTypeScope],
column4 as [DataTypeCode]
from @newProperties;

-- Step 2: Load property definitions

select *
from Lusid.Property.Definition.Writer
where ToWrite = @propertyDefinitions;