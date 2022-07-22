--============================================================

-- Description:
-- In this query, we loop over rows in a CSV file by date,
-- and load the batches to an instruments writer view
-- This is an example of how to implement a for loop
-- in Luminesce. For more details, see this page:
-- https://support.lusid.com/knowledgebase/article/KA-01692/en-us

--============================================================

@@file = select '/luminesce-examples/instrument-test.csv';

@data = use Drive.Csv with @@file
--file={@@file}
enduse;

@ef = select distinct(EffectiveFrom) as Value from @data;

select
    ef.Value,
    r.LusidInstrumentId,
    r.WriteErrorCode
from
    @ef ef
    cross apply
    (
        select * from TestInstrumentWriter w where w.FileName = @@file and w.EffectiveFrom = ef.Value
    ) r