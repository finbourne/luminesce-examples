-- ==============================================================
-- Description:
-- 1. This query mocks the return parameters of reading from a CSV using the DryRunMock PRAGMA command
-- 2. It then mocks the return parameters of writing those parameters to LUSID using the EquityWriter
-- ==============================================================

-- First we mock the creation of the view

@x = use Sys.Admin.SetupView
--provider=Views.UpsertInstrument
--useDryRun
--description=Loads instruments from a given csv file into a view.
--parameters 
filename, Text, '/jackbrady/instruments.csv', false

----
PRAGMA [DryRunMock_Drive.csv] = 'select ''TECHNOLOGY ONE LTD'' as Name, ''TNE AT'' as ClientInternal, ''Equities'' as AssetClass, ''AUD'' as DomesticCurrency';
PRAGMA [DryRunMock_Lusid.Instrument.Equity.Writer] = 'select '''' as LusidInstrumentId, '''' as Figi, '''' as DisplayName, '''' as WriteErrorCode, '''' as WriteErrorDetail'; 
@@filename = select #PARAMETERVALUE(filename);

- Next we read the file path by passing it in as a parameter

@instruments = use Drive.csv with @@filename
--file={@@filename}
enduse;

@table_to_write =
select Name as DisplayName, ClientInternal, DomesticCurrency as DomCcy from @instruments;

select LusidInstrumentId, Figi, DisplayName, WriteErrorCode, WriteErrorDetail
from Lusid.Instrument.Equity.Writer
where toWrite = @table_to_write;

enduse;

-- Finally we read all fields from the view

select * from @x;
