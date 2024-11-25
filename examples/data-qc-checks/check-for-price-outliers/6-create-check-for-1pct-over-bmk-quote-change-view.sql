-- ============================================================
-- Description:
-- Data Quality Check: Operational Control on prices (Quotes).  This program compares the current 
-- day-over-day price change of equities to the day-over-day price change of an index security and flags 
-- cases where the absolute percentage change exceeds the benchmark's change.
        
-- Developer notes:
-- 1. By sorting the quotes by date for each security and looking back from today, weekends and holidays are handled.
--   However, if there is a day missing we will just take the difference between current price and whatever we have as 
--   the prior quote, if it's within the 5 day load window.  Gaps must be addressed in separate tests.
-- 2. This program should be expanded to handle multiple asset classes and a benchmark for each.  Benchmarks should also be 
--   identified through a property rather than hardcoded so that they can be excluded from the test.
-- 3. Lineage (currently disabled)
--     a. A field other than Lineage should be used to hold the status (currently disabled). 
--     b. If used, status should be initialized at the beginning.
        
-- Prerequisite: Load quotes for at least 2 consecutive business days into the scope defined below.
-- Production: Run this after loading the day's closing prices and run for present date.
    
-- - Dan Dasaro, April 2023
-- ============================================================
@price_check_view =

use Sys.Admin.SetupView
--provider=DataQc.OutlierCheck.PercentageChange
--parameters
Today,Date,2023-03-31,true
IdType, Text,ClientInternal,true
QuotesScope, Text,luminesce-examples,true
BenchmarkSec,Text,US78378X1072,true
PercentOffsetFromBenchmark,Decimal,1.0,true
----

@@IdentifierType = select #PARAMETERVALUE(IdType);

@@today = select #PARAMETERVALUE(Today); -- "Today" is hardcoded to align with the available data set.

@@bmksec = select #PARAMETERVALUE(BenchmarkSec); -- Our benchmark, SPX (to be automated)

@@MyScope = select #PARAMETERVALUE(QuotesScope);  -- Quote Scope used for this example

-- Add to benchmark daily percent change.  We want to see cases where the price change is more than the index' price change + a cushion.
@@MyOffset = select  #PARAMETERVALUE(PercentOffsetFromBenchmark); 

@@Formatted_date = select strftime('%d-%m-%Y', @@today);


-- We load from LUSID the last 5 days, which is sufficient to get us to the prior 
-- business day when there are Fri and Monday holidays.  No need to load all history.
@@startdate = select date(@@today, '-5 days');

-- 1. Load recent quotes from LUSID
@quotes = SELECT ROW_NUMBER() OVER(order by InstrumentId,QuoteEffectiveAt) as row_num, *
FROM Lusid.Instrument.Quote
WHERE QuoteScope = @@MyScope AND Provider= 'Lusid'
    AND InstrumentIdType=@@IdentifierType AND QuoteType='Price' AND Field='mid'
    AND QuoteEffectiveAt >= @@startdate
    ORDER BY InstrumentId, QuoteEffectiveAt ASC;
    
-- This next line can be used to reset Lineage (or other status field) to  
-- ControlPending.  User would rerun the process after making any repairs.
-- @reset = SELECT InstrumentId, QuoteScope, Provider, PriceSource, InstrumentIdType, QuoteType, Field, QuoteEffectiveAt, Value, Unit, 'ControlPending' as Lineage FROM @quotes;


-- 2. Derive the benchmark's daily change in percent plus our cushion value.
-- Then set a scalar to that value (the initial return is in table form).
@bmkchange = SELECT (@@MyOffset + (bmk2.Value - bmk1.Value)/bmk1.Value * 100.0) 
    FROM @quotes bmk2 
    LEFT JOIN @quotes bmk1 ON bmk2.row_num = bmk1.row_num+1 
    WHERE bmk2.InstrumentId = @@bmksec AND bmk1.InstrumentId = @@bmksec 
    AND date(bmk2.QuoteEffectiveAt) = date(@@today);

@@delta = select * from @bmkchange;


-- 3. Heart of the program.
-- Find outliers in the quotes by checking the daily change 
-- against the benchmark change.
-- Note the use of the date() function.  To avoid quotes being imported
-- with the prior date to UTC conversion I specified a time with the date.

@outliers=SELECT
    (later.Value - earlier.Value)/earlier.Value * 100.0 as dailyChangePct, later.InstrumentId,
    later.QuoteEffectiveAt, later.Value,
    earlier.QuoteEffectiveAt as PriorQuoteDate, earlier.Value as PriorQuote,
    later.Field, later.Lineage, later.QuoteScope, later.Provider, later.PriceSource, later.QuoteType, 
    later.UploadedBy, later.QuoteAsAt, later.InstrumentIdType, later.Unit, later.row_num
 FROM @quotes later
 LEFT JOIN @quotes earlier
 ON later.row_num = earlier.row_num+1 and later.InstrumentId = earlier.InstrumentId
 WHERE abs(dailyChangePct) > @@delta AND date(later.QuoteEffectiveAt) = date(@@today)
 or (later.InstrumentId = @@bmksec and date(later.QuoteEffectiveAt) = date(@@today) );
 
-- This line can be used to show the outliers that have been found.  Helpful in debugging.
-- select * from @outliers;
 
-- Write the results to file PriceCheckLogs/PriceOutliers.
@writefile=use Drive.SaveAs with @outliers, @@Formatted_date
--path=/PriceCheckLogs
--fileNames={@@Formatted_date}PriceOutliers
enduse;

-- Update the Quotes Store to show "OutlierDetected" on the issue entries.
-- @outliersToUpsert = SELECT
--  InstrumentId, QuoteScope, Provider, PriceSource, InstrumentIdType, QuoteType, Field, QuoteEffectiveAt, Value, Unit, 'OutlierDetected' as Lineage
-- FROM @outliers;


select * from @outliers

enduse;

select *
from @price_check_view;
