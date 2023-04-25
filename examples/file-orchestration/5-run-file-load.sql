@@logsDirectory = select 'luminesce-examples/orchestration/logs';
@@newDirectory = select 'luminesce-examples/orchestration/new';
@@errorDirectory = select 'luminesce-examples/orchestration/error';
@@processedDirectory = select 'luminesce-examples/orchestration/processed';

@instrumentsResponse = select 
'BondA' as 'InstrumentId',
0 as WriteErrorCode, 'instruments_success_001.csv' as FileName
union
values
('BondB', 0, 'instruments_success_002.csv'),
('BondC', 0, 'instruments_success_003.csv'),
('BondD', 105, 'instruments_error_001.csv');


/*

==============================================
        1. Run file orchestration
==============================================

*/

@runFileOrchestration = select * from 
ETL_Manager.File_Orchestration
where  NewDirectory = @@newDirectory
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

select * from @runFileOrchestration;
