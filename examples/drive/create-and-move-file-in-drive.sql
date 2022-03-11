-- #################### SUMMARY ####################

-- 1. This query shows you how to create and move files.
-- 2. Files are created using the Drive.SaveAs function.
-- 3. Files are moved using the Drive.File.Operation provider

-- #################################################

-- Define a file and folder names

@@file_name = select 'daily_instruments_20220215';
@@create_file_location = select '/test-instruments/new/';
@@new_file_location = select '/test-instruments/archive/';

-- Collect sample instruments from the Lusid.Instrument provider

@instruments = select * from Lusid.Instrument limit 10;

-- Save the instruments to Drive as a CSV

@save_to_drive = use Drive.SaveAs with @instruments, @@file_name, @@create_file_location
--path=/{@@create_file_location}
--fileNames={@@file_name}
enduse;

-- Move the instruments CSV file to a new location
-- We need to add the wait statement, so Luminesce knows to finish the file writer,
-- before attempting to move the file

@move_file_request =
select (@@create_file_location || @@file_name || '.csv' ) as [FullPath],
(@@new_file_location || @@file_name || '.csv') as [NewFullPath],
'MoveRenameMayOverwrite' as [Operation] wait 2;

select * from Drive.File.Operation WAIT 5
where UpdatesToPerform = @move_file_request;

