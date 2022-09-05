-- =====================================================
-- Description:
-- In this query, we  load instruments from an Excel
-- file into LUSID
-- =====================================================

@@file_date =

select strftime('20220301');

@instruments_from_excel =

use Drive.Excel with @@file_date
--file=/luminesce-examples/equity_holdings_{@@file_date}.xlsx
--worksheet=instruments
--addFileName
enduse;

-- Run instruments transformation
@instruments_for_upload =

select Ticker, Name as DisplayName, ISIN as Isin, 'EQ' || Isin as ClientInternal, SEDOL as Sedol,
   Currency as DomCcy, 'Equities' as AssetClass, 'Equities' as SimpleInstrumentType
from @instruments_from_excel;

-- Upload the transformed data into LUSID
select *
from Lusid.Instrument.SimpleInstrument.Writer
where ToWrite = @instruments_for_upload;