-- Sequence Definitions : Define new sequences with the `Create` WriteAction.
-- Required Fields : Scope, Code, Start, Increment, MinValue, MaxValue, Cycle, Pattern
@sequencesWithAllFields = values
('MySequenceScope','SequenceCode1',0, 1, 0, 10, true, 'MY-TXN-{{seqValue}}'),
('MySequenceScope','SequenceCode2',0, 2, 0, 1000, false, 'MY-ORD-{{seqValue}}');

@sequences =
SELECT
    Column1 AS Scope,
    Column2 AS Code,
    Column3 AS Start,
    Column4 as Increment,
    Column5 as MinValue, -- should be the same as Start
    Column6 as MaxValue,
    Column7 as Cycle,
    Column8 as Pattern, -- must contain the magic string {{seqValue}} where the value is to be inserted into the pattern
    'Create' as WriteAction
FROM
    @sequencesWithAllFields;

select * from Lusid.Sequence.Writer where ToWrite = @sequences;