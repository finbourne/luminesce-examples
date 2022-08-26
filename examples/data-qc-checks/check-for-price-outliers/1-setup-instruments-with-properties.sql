-- ============================================================
-- Description:
-- In this query we setup some equity instruments
-- NOTE: You'll need to have "Sector" setup as an instrument
-- property in LUSID and Luminesce as follows:
-- Instrument/ibor/Sector
-- ============================================================

-- Load data from CSV

@instruments_data = use Drive.Excel
--file=/luminesce-examples/price_time_series.xlsx
--worksheet=instrument
enduse;

-- Transform equity data

@equity_instruments = select
inst_id as ClientInternal,
name as DisplayName,
ccy	as DomCcy,
sector as Sector
from @instruments_data;

-- Upload the transformed data into LUSID

select *
from Lusid.Instrument.Equity.Writer
where ToWrite = @equity_instruments
and DeletePropertiesWhereNull=True;
