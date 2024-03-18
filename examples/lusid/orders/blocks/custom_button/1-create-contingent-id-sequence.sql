/*

---------------------------
Custom Button Teardown
---------------------------

Description:

    -- This query creates a sequence 
    -- The sequence is to be used to create contingent ids

More details:
    -- the luminesce part of the sequence writer is not documented yet
    https://support.lusid.com/knowledgebase/article/KA-01796/en-us

*/


@sequence_config = SELECT "blockUpdateExample" as Scope,
"order_block_contingent_id_cycling" as Code,
1 as Increment,
0 as MinValue,
100 as MaxValue,
0 as Start,
true as Cycle,
"cont-{{seqValue}}" as Pattern;

select * from Lusid.Sequence.Writer where toWrite = @sequence_config;