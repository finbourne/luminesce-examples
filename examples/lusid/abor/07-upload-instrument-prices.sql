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
@@quoteDateStart = select #2023-01-02#;
@@quoteDateEnd = select #2023-03-03#;

-- Step 1: Define some instrument prices

@instrumentPriceData= 
values

-- 2nd Jan 2023
('FBNABOR001', @@quoteDateStart, 31, 'GBP', 1),
('FBNABOR002', @@quoteDateStart, 32, 'GBP', 1),
('FBNABOR003', @@quoteDateStart, 33, 'USD', 1),
('FBNABOR004', @@quoteDateStart, 34, 'USD', 1),
('FBNABOR005', @@quoteDateStart, 34, 'GBP', 1),
('FBNBND001', @@quoteDateStart, 105, 'USD', 100),
('FBNBND002', @@quoteDateStart, 105, 'USD', 100),
('FBNBND003', @@quoteDateStart, 107, 'GBP', 100),
('FBNBND004', @@quoteDateStart, 98, 'GBP', 100),

-- 3rd March 2023
('FBNABOR001', @@quoteDateEnd, 35, 'GBP', 1),
('FBNABOR002', @@quoteDateEnd, 34, 'GBP', 1),
('FBNABOR003', @@quoteDateEnd, 30, 'USD', 1),
('FBNABOR004', @@quoteDateEnd, 39, 'USD', 1),
('FBNABOR005', @@quoteDateEnd, 45, 'GBP', 1),
('FBNBND001', @@quoteDateEnd, 102, 'USD', 100),
('FBNBND002', @@quoteDateEnd, 101, 'USD', 100),
('FBNBND003', @@quoteDateEnd, 112, 'GBP', 100),
('FBNBND004', @@quoteDateEnd, 104, 'GBP', 100);

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
