-- ============================================================
-- Description:
-- In this query we load sample Ask Mid and Bid Quotes
-- for some Instruments
-- ============================================================
-- 1. Load data from CSV
@data =
use Drive.Excel
--file=/luminesce-examples/SampleMBAdata.xlsx
--worksheet=sheet1
enduse;

-- 2. Transform quotes data
@quotes_for_upload =
select 
'Figi' as InstrumentIdType,
pricedata.Figi as Instrumentid,
'luminesce-examples' as QuoteScope,
'Price' as QuoteType,
'Lusid' as Provider,
pricedata.price_Date as QuoteEffectiveAt, 
case upload.field
    when 'Ask'
    then pricedata.Ask
    when 'Bid'
    then pricedata.Bid
    when 'Mid'
    then pricedata.Mid
end as Value, upload.field as Field, pricedata.Currency as Unit
from @data pricedata
cross join (
   select 'Ask' as field
   union all
   select 'Bid'
   union all
   select 'Mid'
   ) upload;
   

-- Upload quotes into LUSID
select * from Lusid.Instrument.Quote.Writer
where ToWrite = @quotes_for_upload;
