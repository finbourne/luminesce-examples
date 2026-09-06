-- ============================================================
-- Description:
-- This is the high level query which an end-user might run
-- to collect all outlier prices between two dates within
-- a given Quote Scope with a Z Score limit of 2
-- ============================================================

select *
from DataQc.OutlierCheck.SD
where ZScoreLimit = 2
and QuoteScope = 'luminesce-examples'
and InstrumentScope = 'StandardDeviationDQC'
and AssetClass= 'Equity'
and StartDate = #2022-01-01#
and EndDate = #2022-08-26#