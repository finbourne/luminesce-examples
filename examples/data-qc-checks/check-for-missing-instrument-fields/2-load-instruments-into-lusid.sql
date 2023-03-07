-- ===============================================================
-- Description:
-- In this file, we load instruments into LUSID with the new
-- properties defined in the first file.
-- ===============================================================

-- Define file name, this is the instruments file on Drive

@@file_name = select 'equity_instruments_20220819.csv';

-- Load data from Drive

@instruments_data =
use Drive.Csv with @@file_name
--file=/luminesce-examples/{@@file_name}
--addFileName
enduse;

-- 2. Upload the instruments and their default properties into LUSID
@equity_instruments =
select Name as DisplayName, ClientInternal as ClientInternal, ISIN as Isin, SEDOL as Sedol, Currency as DomCcy
from @instruments_data;

select *
from Lusid.Instrument.Equity.Writer
where ToWrite = @equity_instruments
   and DeletePropertiesWhereNull = True;

-- 3. Create view of custom property values
@custom_props =
select 'Sector' as PropertyCode, Sector as Value, ClientInternal as EntityId
from @instruments_data
union
select 'InternalRating' as PropertyCode, InternalRating as Value, ClientInternal as EntityId
from @instruments_data
union
select 'SharesOutstanding' as PropertyCode, SharesOutstanding as Value, ClientInternal as EntityId
from @instruments_data
union
select 'RegFlag' as PropertyCode, RegFlag as Value, ClientInternal as EntityId
from @instruments_data
union
select 'SourceFile' as PropertyCode, 'equity_instruments_20220819' as Value, ClientInternal as EntityId
from @instruments_data
union
select 'MissingFields' as PropertyCode, 'MissingFields: QC not started' as Value, ClientInternal as EntityId
from @instruments_data
union
select 'QualityControlStatus' as PropertyCode, 'NotStarted' as Value, ClientInternal as EntityId
from @instruments_data;

@instr_props =
select li.LusidInstrumentId as EntityId, 'LusidInstrumentId' as EntityIdType, 'Instrument' as Domain, 'ibor' as PropertyScope, PropertyCode, Value
from @custom_props a
inner join Lusid.Instrument li
   on li.ClientInternal = a.EntityId
where a.Value is not null;

-- 4. Upload custom properties data to Lusid.Property. Print results of writing data to console.
select *
from Lusid.Property.Writer
where ToWrite = @instr_props;