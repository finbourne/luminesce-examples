-- ===============================================================
-- Description:
-- In this file, we load instruments into LUSID with the new
-- properties defined in the first file.
-- ===============================================================

@instruments_source_b = use Drive.Excel
--file=/luminesce-examples/fi_instrument_master.xlsx
--worksheet=SourceB
enduse;

-- Transform data using Luminesce
@fi_instruments = select
Name as DisplayName,
Currency as DomCcy,
'Bonds' as SimpleInstrumentType,
'Credit' as AssetClass,
client_internal as ClientInternal,
holding_type,
instrument_type,
gics_level_1,
gics_level_2,
snp_rating,
moody_rating,
mifid_flag,
country_issue,
issue_price
from @instruments_source_b;


-- Upload the transformed data into LUSID

select *
from Lusid.Instrument.SimpleInstrument.Writer
where ToWrite = @fi_instruments
and DeletePropertiesWhereNull=True;