-- Description:
-- In this example we show how you can manage file 
-- orchestration using Luminesce. If a response/table
-- has errors, we move the file to an "error" directory.
-- If the response/table has no errors, we move the file to
-- a "processed" directory


@load_results = 
select 
'Equity' as [Instrument],
0 as [WriteErrorCode],
"instruments_success.csv" as [FileName]
union 
values
('Equity', 103, "instruments_error.csv");


@create_file_orchestration_view = use Sys.Admin.SetupView with @load_results
--provider=ETL_Manager.File_Orchestration
--description="This is a tool for moving files based off load results"
--parameters
NewDirectory,Text,"luminesce-examples/orchestration/new",true
ErrorDirectory,Text,"luminesce-examples/orchestration/error",true
ProcessedDirectory,Text,"luminesce-examples/orchestration/processed",true
LoadResults,table,@load_results,true
----

@@newDirectory = select #PARAMETERVALUE(NewDirectory);
@@processedDirectory = select #PARAMETERVALUE(ProcessedDirectory);
@@errorDirectory = select #PARAMETERVALUE(ErrorDirectory);
@loadResults = select * from #PARAMETERVALUE(LoadResults);

@filesWithErrors = 
select distinct FileName, 
@@errorDirectory as TargetDirectory
from @loadResults where WriteErrorCode<>0;

@fileWithNoErrors = select 
distinct FileName,
@@processedDirectory as TargetDirectory
from @loadResults where FileName not in (select FileName from @filesWithErrors);

@filesWithTarget = 
select * from @filesWithErrors 
union all
select * from @fileWithNoErrors;

@filePathsToMove = 
select 
@@newDirectory || '/' || FileName as FullPath,
TargetDirectory || '/' || FileName as NewFullPath,
'MoveRenameMayOverwrite' as Operation
from @filesWithTarget;

@upload_files_to_drive = select *
from Drive.file.Operation
where UpdatesToPerform = @filePathsToMove;

enduse;

select * from @create_file_orchestration_view;