-- ============================================================
-- Description:
-- Here we build a view which will return all the Instruments 
-- that have duplicate Isin,Cusip,Sedol,Ticker,ClientInternal 
-- in a Scope
-- ============================================================
-- 1. Create view and set parameters
@duplicate_check_view =

use Sys.Admin.SetupView
--provider=DataQc.DuplicateCheck
--parameters
Scope,Text,TestingScope,true
----

@@Scope = select #PARAMETERVALUE(Scope);

@instrument_data = select *
from Lusid.Instrument
where 
    Scope=@@Scope;

       
@duplication_check =
SELECT
    [Duplicate ID],
    [Duplicate ID Type]
FROM (
    SELECT
        Isin AS [Duplicate ID],
        'Isin' AS [Duplicate ID Type],
        ROW_NUMBER() OVER (PARTITION BY Isin ORDER BY Isin) AS row_num
    FROM @instrument_data
    WHERE Isin IS NOT NULL
    UNION ALL
    SELECT
        Cusip AS [Duplicate ID],
        'Cusip' AS [Duplicate ID Type],
        ROW_NUMBER() OVER (PARTITION BY Cusip ORDER BY Cusip) AS row_num
    FROM @instrument_data
    WHERE Cusip IS NOT NULL
    UNION ALL
    SELECT
        Sedol AS [Duplicate ID],
        'Sedol' AS [Duplicate ID Type],
        ROW_NUMBER() OVER (PARTITION BY Sedol ORDER BY Sedol) AS row_num
    FROM @instrument_data
    WHERE Sedol IS NOT NULL
    UNION ALL
    SELECT
        Ticker AS [Duplicate ID],
        'Ticker' AS [Duplicate ID Type],
        ROW_NUMBER() OVER (PARTITION BY Ticker ORDER BY Ticker) AS row_num
    FROM @instrument_data
    WHERE Ticker IS NOT NULL
    UNION ALL
    SELECT
        ClientInternal AS [Duplicate ID],
        'ClientInternal' AS [Duplicate ID Type],
        ROW_NUMBER() OVER (PARTITION BY ClientInternal ORDER BY ClientInternal) AS row_num
    FROM @instrument_data
    WHERE ClientInternal IS NOT NULL
) t
WHERE row_num > 1;

select * from @duplication_check;

enduse;

select *
from @duplicate_check_view;