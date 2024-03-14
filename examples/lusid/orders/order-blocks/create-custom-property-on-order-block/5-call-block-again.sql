/*

-----------
call Block
-----------

Description:

    - In this query, we will call the Blocks that i just set

*/

@@blockScope = SELECT 'blockUpdateExample';

@@blockCode = SELECT 'ORD-BLKTEST-BLK';

select * from Lusid.Block
where BlockCode= @@blockCode
and BlockScope= @@blockScope;

