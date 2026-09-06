-- To get a number of new sequence entries,
-- use the `Next` WriteAction, and specify the number of desired entries in NextBatch.
-- Required Fields :
-- Scope, Code, NextBatch, WriteAction
@defs =
select 'MySequenceScope' as Scope,
       'SequenceCode1' as Code,
       10 as NextBatch,
       'Next' as WriteAction;

select distinct
    Scope,
    Code,
    NextValueInSequence
from Lusid.Sequence.Writer
where
    ToWrite = @defs
    and WriteErrorCode = 0;