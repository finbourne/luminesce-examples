/*

----------------------------
Create instrument properties
----------------------------

In this snippet we create some instrument properties.

These are used to categorise the different classes of instrument issued

*/

@@scope = select 'luminesce-examples';

-- Step 1: Define the property definitions

@newProperties =
values
('Instrument', @@scope, 'CapitalType', 'string'),
('Instrument', @@scope, 'PaybackPriority', 'number');

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