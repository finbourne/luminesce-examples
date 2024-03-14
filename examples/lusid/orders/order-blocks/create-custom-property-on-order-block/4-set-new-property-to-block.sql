-- define contingent id

@@contingent_id = SELECT '670';
@@blockScope = SELECT 'blockUpdateExample';
@@blockCode = SELECT 'ORD-BLKTEST-BLK';


@blocks = SELECT
@@contingent_id as Contingent_Id,
*
FROM Lusid.Block
WHERE
@@blockScope = BlockScope AND 
@@blockCode = BlockCode;
        
-- Write table to the block
select * from Lusid.Block.Writer where toWrite = @blocks;