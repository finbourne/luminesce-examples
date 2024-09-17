-- To get sequences and related information, use the following query.
-- All fields below are usable as filters to narrow down the list.
select
    *
from
    lusid.sequence
where
    Scope = 'MySequenceScope'
    and Code in ('SequenceCode1','SequenceCode2')
    and MinValue < 10
    and MaxValue > 5
    and Start = 0
    and Increment > 0
    and Cycle in (true, false)
    and Pattern like 'MY-%'
;