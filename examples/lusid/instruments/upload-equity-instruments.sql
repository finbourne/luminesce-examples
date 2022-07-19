-- #################### SUMMARY ############################

-- 1. In this query, we run an ETL process on some instruments.
-- 2. First, we load a CSV file of instruments from Drive.
-- 3. Next, we transform the shape of the instrument data.
-- 4. Finally we upload the instrument data into LUSID.

-- #########################################################

-- Load file of instruments data
@instruments_data =

use Drive.Csv
--file=/luminesce-examples/uk_instruments.csv
enduse;

-- Run instruments transformation
@instruments_for_upload =

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
where ToWrite = @instruments_for_upload;