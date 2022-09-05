-- ===============================================================
-- Description:
-- In this file, we run a QC check to check for missing fields
-- ===============================================================

-- Define the file name with source instruments data

@@file_name = select 'equity_instruments_20220819.csv';

-- Search for instruments which have not passed QC

@in_scope_for_qc = select *
from Lusid.Instrument.Equity where
 SourceFile = @@file_name
and QualityControlStatus in ('NotStarted', 'Failed');

-- Run the QC check

@qc_check =
select
DisplayName,
Isin,
ClientInternal,
Sedol,
DomCcy,
Sector,
SharesOutstanding,
InternalRating,
RegFlag,
SourceFile,
case 
when Sector is null then 'Failed'
when RegFlag is null then 'Failed'
when InternalRating is null then 'Failed'
when SharesOutstanding is null then 'Failed' else 'Passed' 
end as 'QualityControlStatus'
from @in_scope_for_qc;

-- Filter for PASSED instruments

@qc_passed = select 
*,
'Missing fields: None' as 'MissingFields'
from @qc_check
where QualityControlStatus = 'Passed';


-- Filter for FAILED instruments

@qc_failed = select 
*,
'Missing fields: ' ||
    case when RegFlag is null then 'RegFlag, ' else '' end ||
    case when InternalRating is null then 'InternalRating, ' else '' end ||
    case when SharesOutstanding is null then 'SharesOutstanding, ' else '' end ||
    case when Sector is null then 'Sector, ' else '' end
    as 'MissingFields'
from @qc_check
where QualityControlStatus = 'Failed';

-- Union all results

@joined_data =
select * from @qc_failed 
union all 
select * from @qc_passed; 

--Upload the results into LUSID

select *
from Lusid.Instrument.Equity.Writer
where ToWrite = @joined_data;

