/*

------------------------------
Create some equity instruments
------------------------------

In this snippet we create an Equity instrument.

*/

-- Step 1: Define the equity instruments

@@scope = select 'luminesce-examples';

@instrumentsForUpload = select
'Glencore Plc' as DisplayName,
'JE00B4T3BW64' as Isin,
'B4T3BW6' as Sedol,
'GLEN-LDN-001' as ClientInternal,
'GBP' as DomCcy,
@@scope as Scope
;

-- Step 2: Upload the transformed data into LUSID

select *
from Lusid.Instrument.Equity.Writer
where ToWrite = @instrumentsForUpload;