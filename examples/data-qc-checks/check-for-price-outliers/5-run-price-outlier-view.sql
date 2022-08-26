-- ============================================================
-- Description:
-- This query shows you how to check for outliers in a CSV
-- file on Drive. We define outliers as observations that
-- fall below Q1 - 1.5 IQR or above Q3 + 1.5 IQR
-- ============================================================

select *
from Custom.OutlierCheck.Prices
where Sector = 'Technology'
and StartDate = #2022-01-01#
and EndDate =  #2022-08-26#
