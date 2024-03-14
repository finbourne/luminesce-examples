-- set property variables

@@scope = SELECT 'blockUpdateExample';
@@propertyCode = SELECT 'Contingent_Id';
@@propertyDisplayName = SELECT 'Contingent Id';
@@propertyDescription = SELECT 'A property representing the contingent ID of the Block';

-- Create Property definition

@table_of_data = SELECT 'Block' as Domain, 
@@scope as PropertyScope, 
'system' as DataTypeScope, 
'string' as DataTypeCode, 
'property' as ConstraintStyle, 
@@propertyCode as PropertyCode, 
@@propertyDisplayName as DisplayName, 
'insert' as WriteAction;

select * from Lusid.Property.Definition.Writer where ToWrite = @table_of_data;

-- Apply Newly created property

@@builtKeyString = SELECT 'Block' || '/' ||  @@scope ||  '/' ||  @@propertyCode;

@keysToCatalog = values
(@@builtKeyString, @@propertyCode, False, @@propertyDescription );

@config = select column1 as [Key], column2 as Name, column3 as IsMain, column4 as Description from @keysToCatalog;

select * from Sys.Admin.Lusid.Provider.Configure
where Provider = 'Lusid.Block'
and Configuration = @config
and WriteAction = 'Modify';