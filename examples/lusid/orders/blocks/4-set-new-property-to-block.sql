/*

-------------------------------------
Set custom property of an order block
-------------------------------------

Description:

    -- This query sets the custom property that we created and applied in the previous step
    -- It is an abnormal way to set a property and will likely change in the future when the appropriate method becomes available

*/
-- Apply the contingent order id to a set of blocks
@data = VALUES
  ('blockUpdateExample', "ORD-BLKTEST-BLK1"),
  ('blockUpdateExample', "ORD-BLKTEST-BLK2"),
  ('blockUpdateExample', "ORD-BLKTEST-BLK3");

@block_ids = SELECT
  column1 AS scope,
  column2 AS code
FROM @data;

-- Generate Blocks with contingent id
@blocks = 
SELECT
  '123' AS Contingent_Id,
  b.* 
FROM 
  @block_ids bi
INNER JOIN 
  Lusid.Block b
ON 
  bi.scope = b.BlockScope AND
  bi.code = b.BlockCode;

-- Write updated values to the block
SELECT * 
FROM Lusid.Block.Writer 
WHERE toWrite = @blocks;