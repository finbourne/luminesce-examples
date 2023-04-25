-- Description:
-- In this example we show how you can manage file 
-- orchestration using Luminesce. If a response/table
-- has errors, we move the file to an "error" directory.
-- If the response/table has no errors, we move the file to
-- a "processed" directory



@@successFileName1 = select 'instruments_success_001';
@@successFileName2 = select 'instruments_success_002';
@@successFileName3 = select 'instruments_success_003';
@@errorFileName1 = select 'instruments_error_001';
@@newDirectory = select 'luminesce-examples/orchestration/new';

/*

==============================================
        1. Create files for testing
==============================================

*/

@successFile1 = select 'BondA' as 'InstrumentId',
0 as WriteErrorCode, @@successFileName1  as FileName;

@successFile2 = select 'BondB' as 'InstrumentId',
0 as WriteErrorCode, @@successFileName2 as FileName;

@successFile3 = select 'BondC' as 'InstrumentId',
0 as WriteErrorCode, @@successFileName3 as FileName;

@errorFile1 = select 'BondD' as 'InstrumentId',
105 as WriteErrorCode, @@errorFileName1 as FileName
union
values
('BondE', 0, 'instruments_error_001.csv');

/*

==============================================
        2. Save new file to Drive
==============================================

*/


@saveFilesToDrive = use Drive.SaveAs with @successFile1, @successFile2, @successFile3, @errorFile1, @@newDirectory
--path=/{@@newDirectory}
--ignoreOnZeroRows=true
--fileNames
instruments_success_001
instruments_success_002
instruments_success_003
instruments_error_001
enduse;

select * from @saveFilesToDrive;