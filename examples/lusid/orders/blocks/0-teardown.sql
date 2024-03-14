
--------------------- REMOVE BLOCK ----------------------------------------

-- Loading in block data from Excel spreadsheet
@block_data_from_spreadsheet = 
use Drive.Excel
--file=/luminesce-examples/order-blocks/block_seed.xlsx
--worksheet=blocks
--addFileName
enduse;

@data_to_write = select bdfs.Block_Scope as BlockScope, 
bdfs.Block_Code as BlockCode, 
'Delete' as WriteAction
FROM @block_data_from_spreadsheet bdfs;

SELECT * FROM Lusid.Block.Writer WHERE ToWrite = @data_to_write;


-------------------- REMOVE Property from Block Domain ------------------------

-- define property variables

@@scope = SELECT 'blockUpdateExample';

@@propertyCode = SELECT 'Contingent_Id';

@@propertyDisplayName = SELECT 'Contingent Id';

@@propertyDescription = SELECT 'A property representing the contingent ID of the Block';


-- Logic

@@builtKeyString = SELECT 'Block' || '/' ||  @@scope ||  '/' ||  @@propertyCode;

@keysToCatalog = values
(@@builtKeyString, @@propertyCode, False, @@propertyDescription );

@config = select column1 as [Key], column2 as Name, column3 as IsMain, column4 as Description from @keysToCatalog;

select * from Sys.Admin.Lusid.Provider.Configure
where Provider = 'Lusid.Block'
and Configuration = @config
and WriteAction = 'Remove';


----------------------- REMOVE PROPERTY DEFINITION ---------------------------------


@table_of_data = SELECT 'Block' as Domain, 
@@scope as PropertyScope, 
@@propertyCode as PropertyCode, 
'delete' as WriteAction;

select * from Lusid.Property.Definition.Writer where ToWrite = @table_of_data;