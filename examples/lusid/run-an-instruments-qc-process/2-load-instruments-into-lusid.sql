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

-- Transform data using Luminesce SQL

@equity_instruments =
select
Name as DisplayName,
ISIN as Isin,
ClientInternal as ClientInternal,
SEDOL as Sedol,
Currency as DomCcy,
Sector as Sector,
SharesOutstanding as SharesOutstanding,
InternalRating as InternalRating,
RegFlag as RegFlag,
'NotStarted' as [QualityControlStatus],
--'MissingFields: QC not started' as 'MissingFields',
FileName as SourceFile
from @instruments_data;

-- Upload the transformed data into LUSID

select *
from Lusid.Instrument.Equity.Writer
where ToWrite = @equity_instruments
and DeletePropertiesWhereNull=True;