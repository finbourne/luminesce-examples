-- ===============================================================
-- Description:
-- In this file, we load instruments into LUSID with the new
-- properties defined in the first file.
-- ===============================================================

@instruments_source_a = use Drive.Excel
--file=/luminesce-examples/fi_instrument_master.xlsx
--worksheet=SourceA
enduse;

-- Transform data using Luminesce
@fi_instruments = select
Name as DisplayName,
Currency as DomCcy,
'Bonds' as SimpleInstrumentType,
'Credit' as AssetClass,
ClientInternal,
HoldingType,
InstrumentType,
GICSLevel1,
GICSLevel2,
SnPRating,
MoodyRating,
MIFIDFlag,
CountryIssue,
IssuePrice
from @instruments_source_a;


-- Upload the transformed data into LUSID

select *
from Lusid.Instrument.SimpleInstrument.Writer
where ToWrite = @fi_instruments
and DeletePropertiesWhereNull=True;