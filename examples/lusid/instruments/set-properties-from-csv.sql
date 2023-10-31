-- Define file name, this is the instruments file on Drive

@@file_name = select 'property examples.csv';

-- Load data from Drive

@instruments_data =
use Drive.Csv with @@file_name
--file=/instrument_test/{@@file_name}
--addFileName
enduse;

@instProperties =
select 
SEDOL as EntityId, 
'ClientInternal' as EntityIdType, 
'Instrument' as Domain,
"Scope" as PropertyScope, 
PropertyCode as PropertyCode,
PropertyValue as Value,
"default" as EntityScope
from @instruments_data;

-- Upload the transformed data into LUSID

select *
from Lusid.Property.Writer
where ToWrite = @instProperties
limit 5;