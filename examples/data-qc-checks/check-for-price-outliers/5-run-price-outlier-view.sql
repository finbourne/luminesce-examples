-- ============================================================
-- Description:
-- This is the high level query which an end-user might run
-- to collect all outlier prices between two dates for
-- a Sector
-- ============================================================

select *
from DataQc.OutlierCheck.Prices
where Sector = 'Technology'
and AssetClass= 'Equity'
and StartDate = #2022-01-01#
and EndDate = #2022-08-26#
