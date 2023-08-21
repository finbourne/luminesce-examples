/*

------------------------------
Create some equity instruments
------------------------------

In this snippet we create some Equity instruments into LUSID.

For more details on LUSID providers, see this page:

https://support.lusid.com/knowledgebase/category/?id=CAT-01099

*/

-- Step 1: Define the equity instruments

@@scope = select 'luminesce-examples';

@instrumentsData= 
values
('Tesco', 'FBNABOR001', 'GBP'),
('Sainsburys', 'FBNABOR002', 'GBP'),
('Walmart', 'FBNABOR003', 'USD'),
('Wholefoods', 'FBNABOR004', 'USD'),
('Waitrose', 'FBNABOR005', 'GBP');

@instrumentsForUpload = select
column1 as DisplayName,
column2 as ClientInternal,
column3 as DomCcy,
@@scope as Scope
from @instrumentsData;

-- Step 2: Upload the transformed data into LUSID

select *
from Lusid.Instrument.Equity.Writer
where ToWrite = @instrumentsForUpload;