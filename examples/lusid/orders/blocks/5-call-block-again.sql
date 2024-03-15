/*

-----------
call Block
-----------

Description:

    - In this query, we will call the Blocks that i just updated, showing that the contingent id is now set on the block

*/

@data = values
  ('blockUpdateExample', "ORD-BLKTEST-BLK1"),
  ('blockUpdateExample', "ORD-BLKTEST-BLK2"),
  ('blockUpdateExample', "ORD-BLKTEST-BLK3");
@block_ids = select
  column1 as scope,
  column2 as code
FROM @data;

SELECT b.*, bids.*
FROM @block_ids bids
INNER JOIN Lusid.Block b
ON b.BlockCode=bids.code
AND b.BlockScope=bids.scope;