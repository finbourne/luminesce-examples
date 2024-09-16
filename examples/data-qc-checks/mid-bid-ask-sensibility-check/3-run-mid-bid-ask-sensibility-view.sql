-- ============================================================
-- Description:
-- This is the high level query which an end-user might run
-- to collect all failed Mid/Bid/Ask sensibility checks in
-- a Quote Scope with a tolerance of 1% 
-- ============================================================

select *
from DataQc.MidBidAskSensibilityCheck
where Tolerance = 0.01
and QuoteScope = 'luminesce-examples'
and StartDate = #2018-01-01#
and EndDate = #2022-08-26#
and IdType = 'Figi'