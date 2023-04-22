-- Description:
-- Create a view to save logs

@logs = select 
'Equity' as [Instrument],
0 as [WriteErrorCode];

@create_logger_view = use Sys.Admin.SetupView with @logs
--provider=ETL_Manager.Save_Logs_To_Drive
--description="This is a tool for saving logs"
--parameters
LogsLocation,Text,"luminesce-examples/orchestration/logs",true
LogFileName,Text,"instrument_log_load",true
Logs,table,@logs,true
----

--@logs = select #PARAMETERVALUE(Logs);
@@logsLocation = select #PARAMETERVALUE(LogsLocation);
@@logFileName = select #PARAMETERVALUE(LogFileName) || strftime('%Y%m%d_%H%M%S', datetime());

@errorsFromLoad = select * from 
#PARAMETERVALUE(Logs) where WriteErrorCode<>0;

@@errorCount = select count(*) from @errorsFromLoad;

@saveFilesToDrive = use Drive.SaveAs with @errorsFromLoad, @@logsLocation, @@logFileName
--path=/{@@logsLocation}
--ignoreOnZeroRows=true
--fileNames={@@logFileName}
enduse;

@@throwErrorOnError = select iif(@@errorCount > 0,
throw('The load has partially failed with errors'), "File loaded successfully");

select * from #PARAMETERVALUE(Logs);

enduse;

select * from @create_logger_view;