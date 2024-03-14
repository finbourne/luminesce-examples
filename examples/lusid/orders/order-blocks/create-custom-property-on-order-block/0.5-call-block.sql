/*

-----------
call Block
-----------

Description:

    - In this query, we will Make sure the teardown worked, and display all properties for blocks in the blockUpdateExample scope

*/

@@blockScope = SELECT 'blockUpdateExample';

@@blockCode = SELECT 'ORD-BLKTEST-BLK';

select * from Lusid.Block
where BlockCode= @@blockCode
and BlockScope= @@blockScope;

