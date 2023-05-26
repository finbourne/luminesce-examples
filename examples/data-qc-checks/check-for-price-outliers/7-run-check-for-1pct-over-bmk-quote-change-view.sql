-- ============================================================
-- Description:
-- This is an example of a high level query which an end-user might 
-- run to get the current day-over-day price change of equities to 
-- the day-over-day price change of an index security and flags 
-- cases where the absolute percentage change exceeds the
-- benchmark's change.
-- ============================================================

select *
from DataQc.OutlierCheck.PercentageChange
where PercentOffsetFromBenchmark = 1.0
and QuotesScope = 'luminesce-examples'
and IdType = 'ClientInternal'
and Today = #2023-03-31#
and BenchmarkSec = 'US78378X1072'
