-- ===============================================================
-- Description:
-- In this file, we load instruments into LUSID with the new
-- properties defined in the first file.
-- ===============================================================

@instruments_source_b =
use Drive.Excel
--file=/lib-luminesce-examples/fi_instrument_master.xlsx
--worksheet=SourceB
enduse;

-- 1. Upload instruments with default properties to Lusid
-- Transform data using Luminesce
@fi_instruments =
select Name as DisplayName, Currency as DomCcy, 'Bonds' as SimpleInstrumentType, 'Credit' as AssetClass,
   client_internal as ClientInternal
from @instruments_source_b;

-- Upload the transformed data into LUSID
@write_instruments =
select *
from Lusid.Instrument.SimpleInstrument.Writer
where ToWrite = @fi_instruments
   and DeletePropertiesWhereNull = True;

-- 2. Upload values for custom properties to Lusid
-- Transform data using Luminesce
@custom_props =
select client_internal, holding_type, instrument_type, gics_level_1, gics_level_2, snp_rating, moody_rating,
   mifid_flag, country_issue, issue_price
from @instruments_source_b;

@unpivoted =
use Tools.Unpivot with @custom_props
--key=client_internal
--keyIsNotUnique
enduse;

@instr_props =
select li.LusidInstrumentId as EntityId, 'LusidInstrumentId' as EntityIdType, 'Instrument' as Domain, 'SourceB' as
   PropertyScope, a.ValueColumnName as PropertyCode, a.ValueText as Value
from @unpivoted a
inner join Lusid.Instrument li
   on li.ClientInternal = a.client_internal;

-- Upload the transformed data into LUSID
@write_props =
select *
from Lusid.Property.Writer
where ToWrite = @instr_props;
