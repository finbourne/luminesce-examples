
-- Define params

@@recon_date = select date(#2022-03-02#);
@@recon_date_str = select strftime('%Y%m%d', @@recon_date);
@@abor_scope = select 'abor-recon-test';
@@ibor_scope = select 'ibor-recon-test';

-- Run reconciliations

@recon_data = select * from Recon.IborVersusAbor
where reconDate = @@recon_date
and aborScope = @@abor_scope
and iborScope = @@ibor_scope;

@recon_passed = select * from @recon_data where ReconStatus = "NoBreak";
@recon_breaks = select * from @recon_data where ReconStatus = "Break";

-- Save results

@save_recon_passed_to_drive = use Drive.SaveAs with @recon_passed, @@recon_date_str
--path=/ReconciliationResults/ReconPassed
--fileNames=recon_passed_{@@recon_date_str}
enduse;

@save_recon_breaks_to_drive = use Drive.SaveAs with @recon_breaks, @@recon_date_str
--path=/ReconciliationResults/ReconBreaks
--fileNames=recon_failed_{@@recon_date_str}
enduse;


select
FileName,
RowCount,
Skipped
from
@save_recon_passed_to_drive
union
select
FileName,
RowCount,
Skipped
from
@save_recon_breaks_to_drive;