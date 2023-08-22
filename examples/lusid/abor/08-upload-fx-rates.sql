/*

---------------
Upload FX rates
---------------

In this snippet we upload FX rates into LUSID.

For more details on LUSID providers, see this page:

https://support.lusid.com/knowledgebase/category/?id=CAT-01099

*/

@@scope = select 'luminesce-examples';
@@quoteDate = select #2023-03-03#;

-- Step 1: Define FX rates

@fxRatesData= 
values
('GBP/USD', @@quoteDate, 1.2344),
('GBP/EUR', @@quoteDate, 1.1444);

-- Step 2: Load FX rates into LUSID

@quotesForUpload = select
'CurrencyPair' as InstrumentIdType,
column1 as Instrumentid,
@@scope as QuoteScope,
'Rate' as QuoteType,
'Lusid' as Provider,
'mid' as Field,
column2 as QuoteEffectiveAt,
column3 as Value,
substr(column1, 5, 7) as Unit
from @fxRatesData;

select * from Lusid.Instrument.Quote.Writer
where ToWrite = @quotesForUpload;
