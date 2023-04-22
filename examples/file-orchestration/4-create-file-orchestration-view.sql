-- Description:
-- In this example we show how you can manage file 
-- orchestration using Luminesce. If a response/table
-- has errors, we move the file to an "error" directory.
-- If the response/table has no errors, we move the file to
-- a "processed" directory


@load_results = select 
'Equity' as [Instrument],
0 as [WriteErrorCode];

@create_file_orchestration_view = use Sys.Admin.SetupView with @load_results
--provider=ETL_Manager.File_Orchestration
--description="This is a tool for moving files based off load results"
--parameters
FileName,Text,"instruments.csv",true
NewDirectory,Text,"luminesce-examples/orchestration/new",true
ErrorDirectory,Text,"luminesce-examples/orchestration/processed",true
ProcessedDirectory,Text,"luminesce-examples/orchestration/error",true
LoadResults,table,@load_results,true
----

@@newDirectory = select #PARAMETERVALUE(NewDirectory);
@@processedDirectory = select #PARAMETERVALUE(ProcessedDirectory);
@@errorDirectory = select #PARAMETERVALUE(ErrorDirectory);
@@fileName = select #PARAMETERVALUE(FileName);

@errorsFromLoad = select * from 
#PARAMETERVALUE(LoadResults) where WriteErrorCode<>0;

@writeErrors =select count(*) as [ResultCount]
from @errorsFromLoad;

@targetFileResult = select iif(ResultCount = 0,
(@@processedDirectory),
(@@errorDirectory))
as 'FileResult'
from @writeErrors;

-- Print source file path
@@newFileLocation = select @@newDirectory || '/' || @@fileName;
@@printnewFileLocation =  select print('The source file path is:' || @@newFileLocation);

-- Print target directory
@@targetDir = select FileResult from @targetFileResult;
@@targetFullPath = select @@targetDir || '/' || @@fileName;
@@printtargetFullPath = select print('The target directory is:' || @@targetFullPath);

@updates =
select @@newFileLocation as FullPath,
@@targetFullPath  as [NewFullPath], 'MoveRenameMayOverwrite' as Operation;

@upload_files_to_drive = select *
from Drive.file.Operation
where UpdatesToPerform = @updates;

select * from @upload_files_to_drive;

enduse;

select * from @create_file_orchestration_view;