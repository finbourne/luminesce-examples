-- Description:
-- In this example we show how you can manage file 
-- orchestration using Luminesce. If a response/table
-- has errors, we move the file to an "error" directory.
-- If the response/table has no errors, we move the file to
-- a "processed" directory


@@fileName = select 'instruments_error.csv';
@@fileNameNoExtension = select substr(@@fileName, 1, length(@@fileName)-4);
@@newDirectory = select 'luminesce-examples/orchestration/new';

/*

==============================================
        1. Create success file for testing
==============================================

NOTE: 
    Run either 1A or 1B
    1A uses a file with no errors
    1B uses a file with errors

*/

@instrumentsResponse = select 
'BondA' as 'InstrumentId',
0 as WriteErrorCode -- success
union all 
values
('BondB', 102),
('BondC', 102),
('BondD', 103);


/*

==============================================
        2. Save new file to Drive
==============================================

*/


@saveFilesToDrive = use Drive.SaveAs with @instrumentsResponse, @@newDirectory, @@fileNameNoExtension 
--path=/{@@newDirectory}
--ignoreOnZeroRows=true
--fileNames={@@fileNameNoExtension}
enduse;

select * from @saveFilesToDrive;