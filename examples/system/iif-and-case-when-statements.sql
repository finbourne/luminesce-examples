-- =============================================================
-- Description:
-- This example shows you how to use iif and case when statements
-- Set a limit, which will decide if the file is a large or small
-- file
-- ==============================================================

@@row_limit = select 10;

-- Load data from LUSID Drive

@data = use Drive.csv
--file=/luminesce-examples/model_portfolios.csv
enduse;

-- Store scalar which is the count of rows in a file

@row_count = select count(*) as [RowCount] from @data;

-- Run an if statement to decide where to save files

@@file_name = select iif(RowCount > @@row_limit, 'large-file', 'small-file') as [TargetFileLocation]
from @row_count;

-- This can also be achieved with a `case when` statement

@@file_name_with_case = select case when RowCount > @@row_limit then 'large-file' else 'small-file' end as [TargetFileLocation]
from @row_count;

-- Save files to drive

@save_to_drive = use Drive.SaveAs with @data, @@file_name
--path=/luminesce-examples
--fileNames={@@file_name}
enduse;

select * from @save_to_drive;