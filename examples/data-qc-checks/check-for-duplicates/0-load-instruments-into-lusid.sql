-- ============================================================
-- Description:
-- In this query we setup some equity instruments
-- ============================================================
-- Load data from CSV

@instruments_data =
use Drive.Excel
--file=/luminesce-examples/Duplicate-Instruments.xlsx
--worksheet=instrument
enduse;

-- 2. Upload the instruments into Lusid.Instrument.Equity provider

@equity_instruments =
select Name as DisplayName, ClientInternal as ClientInternal, Isin as Isin, Sedol as Sedol, Cusip as Cusip, Ticker as Ticker, Currency as DomCcy, 'TestingScope' as Scope
from @instruments_data;


select *
from Lusid.Instrument.Equity.Writer
where ToWrite = @equity_instruments