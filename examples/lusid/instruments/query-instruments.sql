-- ============================================================

-- In this query, we will filter various types of instruments.
-- These can be uploaded via the other examples in this folder.
-- We will query three different types of instrument,
-- and join the results using union.

-- ============================================================

-- Select common columns and filter
select DisplayName, ClientInternal, DomCcy, LusidInstrumentId
from Lusid.Instrument.Equity
where DisplayName = 'Admiral Group'

union

select DisplayName, ClientInternal, DomCcy, LusidInstrumentId
from Lusid.Instrument.SimpleInstrument
where ClientInternal = 'CCYGBP'

union

select DisplayName, ClientInternal, DomCcy, LusidInstrumentId
from Lusid.Instrument.TermDeposit
where ClientInternal = 'TDDFFFA295';
