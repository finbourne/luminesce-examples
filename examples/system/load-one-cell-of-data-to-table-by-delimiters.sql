-- =============================================================
-- Description:
-- Load one cell of data to table by delimiters
-- ==============================================================

@a = use Drive.RawText
--file=/luminesce-examples/DataInOneCell.txt
enduse;

@@content = select Content from @a limit 1;

@raw =
select
    sRow.[Index] as RowIdx,
    sCol.[Index] as ColIdx,
    sCol.Value
from
    tools.split sRow
    inner join tools.split sCol
        on sRow.[Index] = sCol.OriginalIndex
        and sCol.Original = sRow.Value
where
    sRow.DelimiterString = '=@=@='
    and sRow.SplitThisAlone = @@content
    and sCol.DelimiterString = '''~'''
order by 1, 2
    ;

@pivoted =
use Tools.Pivot with @raw
--key=ColIdx
--aggregateColumns=Value
--columnNameFormat="f_{key}{aggregate}"
enduse;

select * from @pivoted