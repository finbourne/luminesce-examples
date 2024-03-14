-- define contingent id

@@contingent_id = SELECT '670';

-- Loading in block data from Excel spreadsheet
@block_data_from_spreadsheet = 
use Drive.Excel
--file=/luminesce-examples/order-blocks/block_seed.xlsx
--worksheet=blocks
--addFileName
enduse;

@blocks = SELECT
bdfs.Block_Code as BlockCode, 
bdfs.Block_Scope as BlockScope,
@@contingent_id as Contingent_Id,
b.*
FROM @block_data_from_spreadsheet bdfs
INNER JOIN Lusid.Block b
ON bdfs.Block_Code = b.BlockCode
AND bdfs.Block_Scope = b.BlockScope;
        
-- Write table to the block
select * from Lusid.Block.Writer where toWrite = @blocks;