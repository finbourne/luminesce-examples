-- =====================================================

-- Description:
-- In this query, we run an ETL process on FX quotes

-- =====================================================

-- Extract FX data from LUSID Drive

@fx_price_data =
use Drive.Excel
--file=/luminesce-examples/daily_quotes.xlsx
--worksheet=fx
enduse;

-- Run transformation on the data

@quotes_for_upload = select
'CurrencyPair' as InstrumentIdType,
ccy_pair as Instrumentid,
'luminesce-examples' as QuoteScope,
'Rate' as QuoteType,
'Lusid' as Provider,
'Mid' as Field,
price_date as QuoteEffectiveAt,
close_price as Value,
currency as Unit
from @fx_price_data;

-- Upload quotes into LUSID

select * from Lusid.Instrument.Quote.Writer
where ToWrite = @quotes_for_upload;