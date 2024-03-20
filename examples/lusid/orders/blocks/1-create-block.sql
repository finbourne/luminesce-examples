/*

------------------------------------
Order Block Creation
------------------------------------

Description:

    -- This query seeds some orders from details contained in an excel file

More Details:

    -- https://support.lusid.com/knowledgebase/article/KA-01682/en-us

*/


-- Loading in block data from Excel spreadsheet
@block_data_from_spreadsheet = 
USE Drive.Excel
--file=/luminesce-examples/block_seed.xlsx
--worksheet=blocks
--addFileName
enduse;

-- Write blocks to LUSID
@data_to_write = SELECT 
    bdfs.Block_Scope AS BlockScope, 
    bdfs.Block_Code AS BlockCode, 
    bdfs.Side AS Side, 
    bdfs.Quantity AS Quantity, 
    bdfs.LUID AS LusidInstrumentId,
    bdfs.Order_Ids AS OrderIds, 
    bdfs.Type AS Type, 
    bdfs.TimeInForce AS TimeInForce, 
    bdfs.CreatedDate AS CreatedDate
    FROM @block_data_from_spreadsheet bdfs;

SELECT * 
    FROM Lusid.Block.Writer 
    WHERE ToWrite = @data_to_write;
