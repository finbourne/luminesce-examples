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
ISIN as ClientInternal,
SEDOL as Sedol,
'GBP' as DomCcy,
'Equities' as AssetClass,
'Equities' as SimpleInstrumentType
from @instruments_data;

-- Upload
select *
from Lusid.Instrument.SimpleInstrument.Writer
where ToWrite = @instruments_for_upload;