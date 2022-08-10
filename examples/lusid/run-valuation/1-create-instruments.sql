-- Load worksheet from Excel file which conatins instrument data

@instruments_data = use Drive.Excel
--file=/luminesce-examples/simplified_valuation_data.xlsx
--worksheet=instruments
enduse;

-- Run instruments transformation
@instruments_for_upload = select
name as DisplayName,
figi as Figi,
'GBP' as DomCcy
from @instruments_data;

-- Upload the transformed data into LUSID
select *
from Lusid.Instrument.Equity.Writer
where ToWrite = @instruments_for_upload;