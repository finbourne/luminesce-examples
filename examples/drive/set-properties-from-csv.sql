-- Define file name, this is the instruments file on Drive

@@file_name = select 'example_instruments.csv';

-- Load data from Drive

@instruments_data =
use Drive.Csv with @@file_name
--file=/instrument_test/{@@file_name}
--addFileName
enduse;

@instProperties =
select 
ClientInternal as EntityId, 
'ClientInternal' as EntityIdType, 
'Instrument' as Domain,
"risk_analytics" as PropertyScope, 
RiskMeasure as PropertyCode,
RiskRating as Value,
"risk_analytics" as EntityScope
from @instruments_data;

-- Upload the transformed data into LUSID

select *
from Lusid.Property.Writer
where ToWrite = @instProperties
limit 5;