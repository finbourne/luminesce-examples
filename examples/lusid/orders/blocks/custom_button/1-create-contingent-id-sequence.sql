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


@sequence_config = 
SELECT 
    "blockUpdateExample" AS Scope,
    "order_block_contingent_id_cycling" AS Code,
    1 AS Increment,
    0 AS MinValue,
    100 AS MaxValue,
    0 AS Start,
    true AS Cycle,
    "cont-{{seqValue}}" AS Pattern;

SELECT * FROM Lusid.Sequence.Writer WHERE toWrite = @sequence_config;