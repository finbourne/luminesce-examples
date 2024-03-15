-- Create a LUSID sequence - https://www.lusid.com/docs/api#operation/CreateSequence

@sequence_config = SELECT "sequence_example_scope" as Scope,
"example_code" as Code,
1 as Increment,
0 as MinValue,
10 as MaxValue,
0 as Start,
false as Cycle,
"cont-{{seqValue}}" as Pattern;

select * from Lusid.Sequence.Writer where toWrite = @sequence_config;