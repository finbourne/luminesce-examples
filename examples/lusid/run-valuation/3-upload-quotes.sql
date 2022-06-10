-- Load quotes from an Excel worksheet

@quotes_data = use Drive.Excel
--file=/lumi-temp-val/simplified_valuation_data.xlsx
--worksheet=prices
enduse;

-- Transform quote data

@quotes_for_upload = select
'Figi' as InstrumentIdType,
figi as Instrumentid,
'ibor' as QuoteScope,
'Price' as QuoteType,
'Lusid' as Provider,
'Mid' as Field,
price_date as QuoteEffectiveAt,
close_price as Value,
'GBP' as Unit
from @quotes_data;

-- Upload quotes into LUSID

select * from Lusid.Instrument.Quote.Writer
where ToWrite = @quotes_for_upload;