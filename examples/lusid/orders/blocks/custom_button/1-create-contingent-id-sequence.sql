@sequence_config = SELECT "blockUpdateExample" as Scope,
"order_block_contingent_id" as Code,
1 as Increment,
0 as MinValue,
10 as MaxValue,
0 as Start,
false as Cycle,
"cont-{{seqValue}}" as Pattern;

select * from Lusid.Sequence.Writer where toWrite = @sequence_config;