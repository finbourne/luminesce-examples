/*

------------------------------------
Order Block Custom Property Teardown
------------------------------------

Description:

-- This query deletes the various elements created in subsequent steps
-- Wait some minutes after running to run subsequent steps

*/



-----------UNCOMMENT BELOW TO USE-------


/*

--------------------- REMOVE BLOCKS ----------------------------------------

-- Loading in block data from Excel spreadsheet
@block_data_from_spreadsheet = 
USE Drive.Excel
--file=/luminesce-examples/block_seed.xlsx
--worksheet=blocks
--addFileName
enduse;

@data_to_write = 
SELECT
    bdfs.Block_Scope AS BlockScope, 
    bdfs.Block_Code AS BlockCode, 
    'Delete' AS WriteAction
FROM 
    @block_data_from_spreadsheet bdfs;

SELECT * 
FROM Lusid.Block.Writer 
WHERE ToWrite = @data_to_write;


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

@config = 
SELECT 
    column1 AS [Key], 
    column2 AS Name, 
    column3 AS IsMain, 
    column4 AS Description 
FROM 
    @keysToCatalog;

SELECT 
    * 
FROM 
    Sys.Admin.Lusid.Provider.Configure
WHERE 
    Provider = 'Lusid.Block'
    AND Configuration = @config
    AND WriteAction = 'Remove';


----------------------- REMOVE PROPERTY DEFINITION ---------------------------------


@table_of_data = 
SELECT 
    'Block' AS Domain, 
    @@scope AS PropertyScope, 
    @@propertyCode AS PropertyCode, 
    'delete' AS WriteAction;

SELECT * 
    FROM Lusid.Property.Definition.Writer 
    WHERE ToWrite = @table_of_data;


*/