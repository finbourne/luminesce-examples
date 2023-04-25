@@fileName = select 'instruments_success.csv';
@@logsDirectory = select 'luminesce-examples/orchestration/logs';
@@newDirectory = select 'luminesce-examples/orchestration/new';
@@errorDirectory = select 'luminesce-examples/orchestration/error';
@@processedDirectory = select 'luminesce-examples/orchestration/processed';

@instrumentsResponse = select 
'BondA' as 'InstrumentId',
0 as WriteErrorCode -- success
union all 
values
('BondB', 0),
('BondC', 0),
('BondD', 0);


/*

==============================================
        1. Run file orchestration
==============================================

*/

@runFileOrchestration = select * from 
ETL_Manager.File_Orchestration
where FileName =  @@fileName
and NewDirectory = @@newDirectory
and ErrorDirectory = @@errorDirectory
and ProcessedDirectory = @@processedDirectory
and LoadResults = @instrumentsResponse;


/*

==============================================
        2. Save logs
==============================================

*/


@saveLogs = select * from ETL_Manager.Save_Logs_To_Drive
where Logs = @instrumentsResponse
and LogFileName = 'instruments_load_logs_'
and LogsLocation = @@logsDirectory;

select * from @saveLogs;
