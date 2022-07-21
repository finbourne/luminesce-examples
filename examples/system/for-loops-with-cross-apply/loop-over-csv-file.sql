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