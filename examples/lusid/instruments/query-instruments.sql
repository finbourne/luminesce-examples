-- ============================================================

-- Description:
-- 1. In this query, we filter various types of instruments.
-- 2. These can be uploaded using examples in this folder.
-- 3. We will query three different types of instrument,
--    and join the results using union.

-- ============================================================

-- Select common columns and filter by ClientInternal IDs
select DisplayName, ClientInternal, DomCcy, LusidInstrumentId
from Lusid.Instrument.Equity
where ClientInternal = 'EQ18BCC14487A54'

union

select DisplayName, ClientInternal, DomCcy, LusidInstrumentId
from Lusid.Instrument.SimpleInstrument
where ClientInternal = 'SHOPCENCI3'

union

select DisplayName, ClientInternal, DomCcy, LusidInstrumentId
from Lusid.Instrument.TermDeposit
where ClientInternal = 'TDDFFFA295'

union

select DisplayName, ClientInternal, DomCcy, LusidInstrumentId
from Lusid.Instrument.Bond
where ClientInternal = 'UKT 2 09/07/25 GB00BTHH2R79';
