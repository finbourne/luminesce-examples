/*

------------------------
Upload instrument prices
------------------------

In this snippet we upload instrument prices into LUSID.

For more details on LUSID providers, see this page:

https://support.lusid.com/knowledgebase/category/?id=CAT-01099

Prerequisite setup steps:

    1. Setup instruments with the ClientInternal instrument IDs referenced below


*/

@@scope = select 'luminesce-examples';
@@quoteDate = select #2023-03-03#;

-- Step 1: Define some instrument prices

@instrumentPriceData= 
values
('FBNABOR001', @@quoteDate, 31, 'GBP', 1),
('FBNABOR002', @@quoteDate, 32, 'GBP', 1),
('FBNABOR003', @@quoteDate, 33, 'GBP', 1),
('FBNABOR004', @@quoteDate, 34, 'USD', 1),
('FBNABOR005', @@quoteDate, 34, 'GBP', 1),
('FBNBND001', @@quoteDate, 105, 'USD', 100),
('FBNBND002', @@quoteDate, 105, 'USD', 100),
('FBNBND003', @@quoteDate, 107, 'GBP', 100),
('FBNBND004', @@quoteDate, 98, 'GBP', 100);

-- Step 2: Load prices into LUSID

@pricesForUpload = select
'ClientInternal' as InstrumentIdType,
column1 as Instrumentid,
@@scope as QuoteScope,
'Price' as QuoteType,
'Lusid' as Provider,
'mid' as Field,
column2 as QuoteEffectiveAt,
column3 as Value,
column4 as Unit,
column5 as ScaleFactor
from @instrumentPriceData;

select * from Lusid.Instrument.Quote.Writer
where ToWrite = @pricesForUpload;