-- define target blocks
@data = values
  ('blockUpdateExample', "ORD-BLKTEST-BLK1"),
  ('blockUpdateExample', "ORD-BLKTEST-BLK2"),
  ('blockUpdateExample', "ORD-BLKTEST-BLK3");
@block_ids = select
  column1 as scope,
  column2 as code
FROM @data;


-- Define contingent id
@contingent_id = SELECT '888' as Contingent_Id;

-- Add contingent Ids to the target blocks
@block_ids_with_contingent_ids = SELECT 
    b.scope,
    b.code,
    cid.Contingent_Id
FROM 
    @block_ids b
INNER JOIN (@contingent_id) cid;

-- Generate Blocks with updated values
@blocks = SELECT
biwci.Contingent_Id as Contingent_Id,
b.* 
FROM @block_ids_with_contingent_ids biwci
INNER JOIN Lusid.Block b
ON biwci.scope = b.BlockScope AND
biwci.code = b.BlockCode;
        
-- Write updated values to the block
select * from Lusid.Block.Writer where toWrite = @blocks;