-- Description:
-- In this example we show how you can manage file 
-- orchestration using Luminesce. If a response/table
-- has errors, we move the file to an "error" directory.
-- If the response/table has no errors, we move the file to
-- a "processed" directory


@@fileName = select 'instruments';
@@newDirectory = select 'luminesce-examples/orchestration/new';
@@processedDirectory = select 'luminesce-examples/orchestration/processed';
@@errorDirectory = select 'luminesce-examples/orchestration/error';
@@logsLocation = select 'luminesce-examples/orchestration/logs';
@@logFileName = select 'instruments_load_error_logs_' || strftime('%Y%m%d_%H%M%S', datetime());

/*
==============================================
        1. Select file from Drive
==============================================
*/


@instrumentsResponse = use Drive.csv with @@newDirectory, @@fileName
--file=/{@@newDirectory}/{@@fileName}.csv
enduse;


/*
==============================================
        2. File orchestration
==============================================
*/

@errorsFromLoad = select * from 
@instrumentsResponse where WriteErrorCode<>0;

@writeErrors =select count(*) as [ResultCount]
from @errorsFromLoad;

@targetFileResult = select iif(ResultCount = 0,
(@@processedDirectory),
(@@errorDirectory))
as 'FileResult'
from @writeErrors;

-- Print source file path
@@newFileLocation = select @@newDirectory || '/' || @@fileName || '.csv';
@@printnewFileLocation =  select print('The source file path is:' || @@newFileLocation);

-- Print target directory
@@targetDir = select FileResult from @targetFileResult;
@@targetFullPath = select @@targetDir || '/' || @@fileName || '.csv';
@@printtargetFullPath = select print('The target directory is:' || @@targetFullPath);

@updates =
select @@newFileLocation as FullPath,
@@targetFullPath  as [NewFullPath], 'MoveRenameMayOverwrite' as Operation;

@upload_files_to_drive = select *
from Drive.file.Operation
where UpdatesToPerform = @updates;

/*

====================================
        3. Save logs to Drive 
====================================

*/

@errorsFromLoad = select * from 
@instrumentsResponse where WriteErrorCode<>0;

@@errorCount = select count(*) from @errorsFromLoad;

@saveFilesToDrive = use Drive.SaveAs with @errorsFromLoad, @@logsLocation, @@logFileName
--path=/{@@logsLocation}
--ignoreOnZeroRows=true
--fileNames={@@logFileName}
enduse;

@@throwErrorOnError = select iif(@@errorCount > 0,
throw('The load has partially failed with errors'), "File loaded successfully");