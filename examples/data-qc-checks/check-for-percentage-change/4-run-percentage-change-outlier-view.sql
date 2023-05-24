-- ============================================================
-- Description:
-- This is the high level query which an end-user might run
-- to collect all outlier quotes between two dates for
-- a Quote Scope with a percentage change over 50%
-- ============================================================

select *
from DataQc.OutlierCheck.PercentageChange
where Percentage = 0.50
and QuoteScope = 'luminesce-examples'
and StartDate = #2022-01-01#
and EndDate = #2022-08-26#