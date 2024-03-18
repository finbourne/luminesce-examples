/*

-------------------------------------
Set custom property of an order block
-------------------------------------

Description:

    -- This query sets the custom property that we created and applied in the previous step
    -- It is an abnormal way to set a property and will likely change in the future when the appropriate method becomes available

*/


-- Apply the contingent order id to a set of blocks
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

-- Generate Blocks with updated values
@blocks = SELECT
cid.Contingent_Id,
b.* 
FROM @block_ids bi
INNER JOIN Lusid.Block b
ON bi.scope = b.BlockScope AND
bi.code = b.BlockCode
INNER JOIN (@contingent_id) cid;
        
-- Write updated values to the block
select * from Lusid.Block.Writer where toWrite = @blocks;