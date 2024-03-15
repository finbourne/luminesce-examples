-- Get next value from a sequence - https://www.lusid.com/docs/api#operation/Next

@sequence = SELECT 1 as NextBatch, 
'example_code' as Code, 
'Next' as WriteAction,
'sequence_example_scope' as Scope;

select * from Lusid.Sequence.Writer where toWrite = @sequence;