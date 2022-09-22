-- ===============================================================
-- Description:
-- In this query, we read an Fx Forward holding from LUSID.
-- ===============================================================

-- Read Fx Forward from LUSID based on specified FIGI.

select * from lusid.Instrument.FxForward
where Figi = 'BBG000BVPXP1';