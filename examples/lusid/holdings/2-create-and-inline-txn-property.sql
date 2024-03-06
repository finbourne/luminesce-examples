/*

---------------
Create Transaction property
---------------

Description:

    - In this query, we create a new transaction property called strategy and inline this property to Luminesce

More details:

    - https://support.lusid.com/knowledgebase/category/?id=CAT-01099

*/
@@scope = select 'luminesce-examples';

-- Step 1: Define the property definitions
@newProperties =
values
('Transaction', @@scope, 'strategy', 'string');

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

-- Step 3: Configure an entity provider pair to inline properties 
-- in order to interact with them the same way as standard entity data fields

%%luminesce
@keysToCatalog = values
('Transaction/luminesce-examples/strategy', 'strategy', True, 'A property representing SHK');

@config = select column1 as [Key], column2 as Name, column3 as IsMain, column4 as Description from @keysToCatalog;

select * from Sys.Admin.Lusid.Provider.Configure
where Provider = 'Lusid.Portfolio.Holding.Writer'
and Configuration = @config
and WriteAction = 'Modify';;