-- ===============================================================
-- Description:
-- In this query, we read an Fx Forward holding from LUSID.
-- ===============================================================

-- Read Fx Forward from LUSID based on display name.
select * from lusid.Instrument.FxForward
where DisplayName = 'GBPUSD 01 Feb 21';