-- =====================================================
-- Description:
-- In this query, we pull FX Spot data from the ECB Provider and upsert into Lusid
-- This can be run in query editor or used in a schedule
-- This can be used to upload all data from 1999-01-01 by changing start_date
-- Alternatively it can be used in a schdule to update FX values daily
-- Note FX rates are uploaded to ECB between 4-5pm GMT
-- =====================================================
@@start_date = select date('now'); --Gets todays date, alternatively provide your start date
@@scope = select 'ECB_FX_test'; --Sets scope
@@price_source = select 'ECB';
@@field = select 'mid';
@@provider = select 'Lusid';

--Format Quote Request
@table_of_data = 
select 'ECB_FX_test' as QuoteScope, 
'Lusid' as Provider, 
'ECB' as PriceSource, 
CurrencyDenominator || '/' || Currency as InstrumentId, 
'CurrencyPair' as InstrumentIdType, 
'Rate' as QuoteType, 
'mid' as Field, 
ObservationValue as Value, 
Currency as Unit, 
TimePeriod as QuoteEffectiveAt 
from [Ecb.Exchangerates] --Pulls Data from ECB Provider and places into Quote Format
where StartPeriod = date('now', '-1 days') --Upload data from this date
and ExchangeRateType = 'SP00' --Pulls only FX Spot Rates
and Frequency = 'D'; --Filters out weekly and monthly data

--Sends Quote Request
select * from Lusid.Instrument.Quote.Writer 
where ToWrite = @table_of_data;