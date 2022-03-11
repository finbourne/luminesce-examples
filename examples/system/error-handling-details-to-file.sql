
@@file_name = select 'daily_instruments';
@@error_path = select 'test/instrument-upload/load-error';
@@processed_path = select 'test/instrument-upload/processed';

@instruments_for_upload =

select
'Amazon Inc' as DisplayName,
'USD' as DomCcy,
'Equities' as AssetClass,
'Equities' as SimpleInstrumentType;

-- Upload the transformed data into LUSID
@writer_results = select *
from Lusid.Instrument.SimpleInstrument.Writer
where ToWrite = @instruments_for_upload;

@writer_status = select count (*) as ResultCount from @writer_results  where WriteErrorDetail is not null;

@target_file_result =

select iif(ResultCount = 0,
(@@processed_path),
(@@error_path))
as 'FileResult'
from @writer_status;

@@target_dir = select FileResult from @target_file_result;

@save_to_drive = use Drive.SaveAs with @writer_results, @@file_name, @@target_dir
--path=/{@@target_dir}
--fileNames={@@file_name}
enduse;

select * from @save_to_drive;
