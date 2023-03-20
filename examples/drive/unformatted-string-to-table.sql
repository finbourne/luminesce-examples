-- Description:
-- In this example we load raw data from a 
-- txt file into a Luminesce table. The 
-- data is in a comma separated format

/*
====================================================
    1. Load comma separated string from txt file
====================================================
*/

@@txtDataOriginal = use Drive.RawText
--file=/luminesce-examples/prices-in-txt-file.txt
enduse;

@@txtData_RemoveRedundantTxt = select regexp_replace(@@txtDataOriginal, '"|ADD| ', '');

@@txtData_CommaSeparatedString = select regexp_match(@@txtData_RemoveRedundantTxt, '(?<=ENDRECORD)[.|\n|\W|\w]*');

/*
======================================
    2. Parse out the columns names 
======================================
*/

@@columnsWithNoSepCommas = select regexp_match(@@txtDataOriginal , '(?<=RECORD)([.|\n|\W|\w]*)(?=ENDRECORD)');

@@columnsWithTrailingComma = select regexp_replace(@@columnsWithNoSepCommas, '\r\n', ',');

@columnsWithSepCommas = select substr(@@columnsWithTrailingComma, 2, length(@@columnsWithTrailingComma) -2) as ColumnNames;

/*
==========================================
    3. Split string into separate rows
==========================================
*/

-- Note: This is how you split by endlines in Luminesce

@txtSplitByRow = select Value from Tools.Split where DelimiterString = '
'
and Original = @@txtData_CommaSeparatedString;

@tableRowsAsOneCol = select distinct Value as OriginalColumnValue from @txtSplitByRow
where Value != '';

/*
====================================================================    
    4. Use the Tools.Split provider to split the data into cells    
====================================================================
*/

-- Split the table body first

@tableRowsAsOneColWithIndex = select r.OriginalColumnValue, t.*
from @tableRowsAsOneCol r
inner join Tools.Split t 
on t.Original = r.OriginalColumnValue;

-- Then split column names

@columnsNamesToTable = select r.ColumnNames, t.*
from @columnsWithSepCommas r
inner join Tools.Split t 
on t.Original = r.ColumnNames;

-- Join the table body and column names together

@formattedTable = select 
tr.Value as [RowValue], tr.[OriginalIndex], ct.Value as [ColumnName]
from @columnsNamesToTable ct
join @tableRowsAsOneColWithIndex tr on (ct.[Index] = tr.[Index])
;

/*
=======================================
    5. Pivot and format the results
=======================================
*/

@pivoted = 
use Tools.Pivot with @formattedTable
--key=ColumnName
--aggregateColumns=RowValue
enduse;

select
*
from @pivoted;
