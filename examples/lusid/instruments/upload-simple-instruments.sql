-- ============================================================

-- Description:
-- 1. In this query, we run an ETL process on some instruments.
-- 2. First, we load a Excel file of instruments from Drive.
-- 3. Next, we transform the shape of the instrument data.
-- 4. Finally we upload the instrument data into LUSID.

-- ============================================================

-- Extract Simple Instrument data from LUSID Drive
@instruments_data =
use Drive.Excel
--file=/luminesce-examples/instruments.xlsx
--worksheet=simple_instruments
enduse;

-- Transform data using SQL
@simple_instruments =
select
Name as DisplayName,
ClientInternal as ClientInternal,
Currency as DomCcy,
Class as AssetClass,
Type as SimpleInstrumentType
from @instruments_data;

-- Upload the transformed data into LUSID
select *
from Lusid.Instrument.SimpleInstrument.Writer
where ToWrite = @simple_instruments;
