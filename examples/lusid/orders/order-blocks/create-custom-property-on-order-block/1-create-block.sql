
-- Loading in block data from Excel spreadsheet
@block_data_from_spreadsheet = 
use Drive.Excel
--file=/luminesce-examples/order-blocks/block_seed.xlsx
--worksheet=blocks
--addFileName
enduse;

@data_to_write = SELECT bdfs.Block_Scope AS BlockScope, 
bdfs.Block_Code AS BlockCode, 
bdfs.Side AS Side, 
bdfs.Quantity AS Quantity, 
bdfs.LUID AS LusidInstrumentId,
bdfs.Order_Ids AS OrderIds, 
bdfs.Type AS Type, 
bdfs.TimeInForce AS TimeInForce, 
bdfs.CreatedDate AS CreatedDate
FROM @block_data_from_spreadsheet bdfs;

SELECT * FROM Lusid.Block.Writer WHERE ToWrite = @data_to_write;
