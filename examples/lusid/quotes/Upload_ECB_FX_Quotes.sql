-- =====================================================
-- Description:
-- This script is an example of how to use the ECB Provider 
-- in Lusid to upload FX Rates into Lusid
--
-- There are two use cases:
--   1. Bulk upload of all data from 1999
--       By changing @@start_date from current date to '1999-01-01' 
--       this uploads all FX Rates from ECB
--
--   2. End of Day scheduled upsert of todays data 
--       Running the query with @@start_date being select date('now') at 6pm CET
--       uploads that days FX Rates from the ECB to Lusid
--       see the ECB website for details on when todays rates are available
-- =====================================================

--Format Quote Request
@table_of_data = 
select 'scope' as QuoteScope, --Change variables below to your desired values
'provider' as Provider,
'price source' as PriceSource,
CurrencyDenominator || '/' || Currency as InstrumentId, -- All Below Variables are standard and cannot be changed
'CurrencyPair' as InstrumentIdType,
'Rate' as QuoteType,
'mid' as Field,
ObservationValue as Value,
Currency as Unit,
TimePeriod as QuoteEffectiveAt
from [Ecb.Exchangerates] --Pulls Data from ECB Provider and places into Quote Format
where StartPeriod = select date('now'), --Upload data from this date. select date('now') for todays only or '1999-01-01' to upload all data
and ExchangeRateType is 'SP00' --Pulls only FX Spot Rates
and Frequency is 'D'; --Filters out weekly and monthly data

--Sends Quote Request
select * from Lusid.Instrument.Quote.Writer 
where ToWrite = @table_of_data;
