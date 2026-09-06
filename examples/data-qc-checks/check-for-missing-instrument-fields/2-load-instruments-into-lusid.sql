-- ===============================================================
-- Description:
-- In this file, we load instruments into LUSID with the new
-- properties defined in the first file.
-- ===============================================================

@x = use Sys.Admin.SetupView
--provider=Views.DQ_LoadInstruments
----

-- Define file name, this is the instruments file on Drive

@@file_name = select 'equity_instruments_20220819.csv';

-- Load data from Drive

@instruments_data =
use Drive.Csv with @@file_name
--file=/luminesce-examples/{@@file_name}
--addFileName
enduse;

-- 2. Upload the instruments and their default properties into Lusid.Instrument.Equity provider

@equity_instruments =
select Name as DisplayName, ClientInternal as ClientInternal, ISIN as Isin, SEDOL as Sedol, Currency as DomCcy, 'MissingFields' as Scope
from @instruments_data;

@write_instruments =
select *
from Lusid.Instrument.Equity.Writer
where ToWrite = @equity_instruments
   and DeletePropertiesWhereNull = True;

-- 3. Create view of custom property values

@custom_props =
select ClientInternal as EntityId, Sector, InternalRating, SharesOutstanding, RegFlag, 'equity_instruments_20220819' as
   SourceFile, 'MissingFields: QC not started' as 'MissingFields', 'NotStarted' as QualityControlStatus
from @instruments_data;

@unpivoted =
use Tools.Unpivot with @custom_props
--key=EntityId
--keyIsNotUnique
enduse;

@instr_props =
select li.LusidInstrumentId as EntityId, 'LusidInstrumentId' as EntityIdType, 'Instrument' as Domain, 'ibor' as
   PropertyScope, a.ValueColumnName as PropertyCode, a.ValueText as Value, 'MissingFields' as EntityScope
from @unpivoted a
inner join Lusid.Instrument li
   on li.ClientInternal = a.EntityId
   where Scope = 'MissingFields';

-- 4. Upload custom properties data to Lusid.Property

@write_properties =
select *
from Lusid.Property.Writer
where ToWrite = @instr_props;

enduse;
