-- ===============================================================
-- Description:
-- In this file, we load instruments into LUSID with the new
-- properties defined in the first file.
-- ===============================================================

@instruments_source_a = use Drive.Excel
--file=/luminesce-examples/fi_instrument_master.xlsx
--worksheet=SourceA
enduse;

-- 1. Upload instruments with default properties to Lusid
-- Transform data using Luminesce
@fi_instruments = select
Name as DisplayName,
Currency as DomCcy,
'Bonds' as SimpleInstrumentType,
'Credit' as AssetClass,
ClientInternal,
CountryIssue,
IssuePrice
from @instruments_source_a;

-- Upload the transformed data into LUSID
@write_instruments =
select *
from Lusid.Instrument.SimpleInstrument.Writer
where ToWrite = @fi_instruments
and DeletePropertiesWhereNull=True;

-- 2. Upload values for custom properties to Lusid
-- Transform data using Luminesce
@custom_props =
select ClientInternal, CountryIssue, HoldingType, InstrumentType, GICSLevel1,
GICSLevel2, SnPRating, MoodyRating, MIFIDFlag
from @instruments_source_a;

@unpivoted =
use Tools.Unpivot with @custom_props
--key=ClientInternal
--keyIsNotUnique
enduse;

@instr_props =
select li.LusidInstrumentId as EntityId, 'LusidInstrumentId' as EntityIdType, 'Instrument' as Domain,
    a.ValueColumnName as PropertyCode, 'SourceA' as PropertyScope, a.ValueText as Value
from @unpivoted a
inner join Lusid.Instrument li
   on li.ClientInternal = a.ClientInternal;

-- Upload the transformed data into LUSID
@write_props =
select *
from Lusid.Property.Writer
where ToWrite = @instr_props;
