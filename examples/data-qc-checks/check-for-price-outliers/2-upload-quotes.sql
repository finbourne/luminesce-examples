-- ============================================================
-- Description:
-- In this query we load a time series of equity prices
-- ============================================================

-- Load data from CSV

@quotes_data = use Drive.Excel
--file=/luminesce-examples/price_time_series.xlsx
--worksheet=price_time_series
enduse;

-- Transform quotes data

@quotes_for_upload = select
'ClientInternal' as InstrumentIdType,
instrument_id as Instrumentid,
'luminesce-examples' as QuoteScope,
'Price' as QuoteType,
'Lusid' as Provider,
'Mid' as Field,
price_date as QuoteEffectiveAt,
price as Value,
ccy as Unit
from @quotes_data;


-- Upload quotes into LUSID

select * from Lusid.Instrument.Quote.Writer
where ToWrite = @quotes_for_upload;
