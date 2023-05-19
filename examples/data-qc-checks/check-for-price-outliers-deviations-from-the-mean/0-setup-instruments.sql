-- ============================================================
-- Description:
-- In this query we setup some equity instruments
-- ============================================================
-- Load data from CSV
@instruments_data =

use Drive.Excel
--file=/luminesce-examples/price_time_series.xlsx
--worksheet=instrument
enduse;

-- 2. Upload instrument equity data 
@equity_instruments =
select inst_id as ClientInternal, name as DisplayName, ccy as DomCcy
from @instruments_data;

-- Write data to Lusid.Instrument.Equity. Print results of writing data to console.
select *
from Lusid.Instrument.Equity.Writer
where ToWrite = @equity_instruments
and DeletePropertiesWhereNull = True;