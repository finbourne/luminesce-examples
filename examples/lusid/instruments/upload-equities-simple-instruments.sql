-- #################### SUMMARY ############################

-- 1. In this query, we run an ETL process on some instruments.
-- 2. First, we load a CSV file of instruments from Drive.
-- 3. Next, we transform the shape of the instrument data.
-- 4. Finally we upload the instrument data into LUSID.

-- #########################################################

-- Load file of instruments data
@instruments_data =

use Drive.Csv
--file=/luminesce-temp-instruments-testing-folder/uk_instruments.csv
enduse;

-- Run instruments transformation
@instruments_for_upload =

select Ticker,
Name as DisplayName,
ISIN as Isin,
ClientInternal as ClientInternal,
SEDOL as Sedol,
'GBP' as DomCcy,
'Equities' as AssetClass,
'Equities' as SimpleInstrumentType
from @instruments_data;

-- Upload the transformed data into LUSID
select *
from Lusid.Instrument.SimpleInstrument.Writer
where ToWrite = @instruments_for_upload;