
-- Description:
-- In this example we show how you can manage file 
-- orchestration using Luminesce. If a response/table
-- has errors, we move the file to an "error" directory.
-- If the response/table has no errors, we move the file to
-- a "processed" directory


@@fileName = select 'instruments';
@@newDirectory = select 'luminesce-examples/orchestration/new';

/*

==============================================
        1A. Create success file for testing
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
('BondB', 0),
('BondC', 0),
('BondD', 0);

/*

==============================================
        1B. Create error file for testing
==============================================

NOTE: 
    Run either 1A or 1B
    1A uses a file with no errors
    1B uses a file with errors

*/


-- @instrumentsResponse = select 
-- 'BondA' as 'InstrumentId',
-- 100 as WriteErrorCode -- error
-- union all 
-- values
-- ('BondB', 0),
-- ('BondC', 0),
-- ('BondD', 0);


/*

==============================================
        2. Save new file to Drive
==============================================

*/


@saveFilesToDrive = use Drive.SaveAs with @instrumentsResponse, @@newDirectory, @@fileName
--path=/{@@newDirectory}
--ignoreOnZeroRows=true
--fileNames={@@fileName}
enduse;


