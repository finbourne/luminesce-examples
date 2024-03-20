/*

-----------
call Block
-----------

Description:

    - This query returns the Blocks that I just updated
    - It should display that the contingent id is now set on them

*/

@data = VALUES
  ('blockUpdateExample', "ORD-BLKTEST-BLK1"),
  ('blockUpdateExample', "ORD-BLKTEST-BLK2"),
  ('blockUpdateExample', "ORD-BLKTEST-BLK3");
  
@block_ids = SELECT
  column1 AS scope,
  column2 AS code
FROM @data;

SELECT b.*, bids.*
  FROM @block_ids bids
  INNER JOIN Lusid.Block b
  ON b.BlockCode=bids.code
  AND b.BlockScope=bids.scope;