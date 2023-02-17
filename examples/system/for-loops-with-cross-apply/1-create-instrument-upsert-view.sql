-- ============================================================
-- Description:
-- In this file, we create view which uploads instruments
-- from a CSV file based on an EffectiveDate
-- ============================================================

-- First delete the view if it already exists
@delete_view =
use Sys.Admin.SetupView
--provider=TestInstrumentWriter
--deleteProvider
----
select 1 as deleting
enduse;

-- Wait 5 seconds after delete before attempting to re-create
-- This give the view time to reset on the Luminesce grid
@delete_view_response =
select *
from @delete_view wait 5;

@v =
use Sys.Admin.SetupView
--provider=TestInstrumentWriter
--parameters
FileName,Text,/luminesce-examples/instrument-test.csv,false
EffectiveFrom,DateTime,2020-01-01,false
----

--Can't pass table parameters to the View, so for now have to read the file each time from Drive
--Could have a separate query to chunk the files
@@file = select #PARAMETERVALUE(FileName);

@data = use Drive.Csv with @@file
--file={@@file}
enduse;

@@dt = select datetime(#PARAMETERVALUE(EffectiveFrom));

@toWrite = select * from @data where EffectiveFrom = @@dt;

select * from Lusid.Instrument.Writer where ToWrite = @toWrite and EffectiveFrom = @@dt;

enduse;

select * from @v