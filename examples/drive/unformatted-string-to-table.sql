--============================================

-- Description:
-- In this example we load raw data from a 
-- txt file into a Luminesce table. The 
-- data is in a comma separated format

--============================================



/*

    1. Load comma separated string from txt file. 
        The data will be loaded as one cell.

*/

@@txtDataOriginal = use Drive.RawText
--file=/luminesce-examples/prices-in-txt-file.txt
enduse;

@@txtData_RemoveRedundantTxt = select regexp_replace(@@txtDataOriginal, '|ADD |"', '');

@@txtData_CommaSeparatedString = select regexp_match(@@txtData_RemoveRedundantTxt, '(?<=ENDRECORD)[.|\n|\W|\w]*');

/*

    2. Split string into separate rows

*/


-- Note: This is how you split by endlines in Luminesce

@txtSplitByRow = select Value from Tools.Split where DelimiterString = '
'
and Original = @@txtData_CommaSeparatedString;

@tableRowsAsOneCol = select distinct Value as OriginalColumnValue from @txtSplitByRow
where Value != '';

/*

    3. Use the Tools.Split provider to split the data into cells

*/

@tableRowsAsOneColWithIndex = select r.OriginalColumnValue, t.*
from @tableRowsAsOneCol r
inner join Tools.Split t 
on t.Original = r.OriginalColumnValue;

/*

    4. Pivot and format results

*/

@pivoted = 
use Tools.Pivot with @tableRowsAsOneColWithIndex
--key=Index
--aggregateColumns=Value
enduse;

select
[1] as ClientInternal,
[2] as PriceDate,
[3] as PriceTime,
[4] as Currency,
[5] as Price,
[6] as PriceField 
from @pivoted;
