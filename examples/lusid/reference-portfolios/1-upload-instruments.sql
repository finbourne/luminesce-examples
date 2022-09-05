-- ============================================================
-- Description:
-- 1. In this query, we run an ETL process on some instruments.
-- 2. First, we load an Excel file of instruments from Drive.
-- 3. Next, we transform the shape of the instrument data.
-- 4. Finally we upload the instrument data into LUSID.
-- ============================================================

-- Extract equity instrument data from LUSID Drive

@instruments_data = use Drive.Excel
--file=/luminesce-examples/reference_port.xlsx
--worksheet=instruments
enduse;

-- Transform data using SQL

@equity_instruments =
select
Name as DisplayName,
ISIN as Isin,
ClientInternal as ClientInternal,
SEDOL as Sedol,
'GBP' as DomCcy
from @instruments_data;

-- Upload the transformed data into LUSID

select *
from Lusid.Instrument.Equity.Writer
where ToWrite = @equity_instruments;