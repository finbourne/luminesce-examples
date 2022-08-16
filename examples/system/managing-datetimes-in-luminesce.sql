--============================================================

-- Description:
-- In this file we show some examples of working with dates in
-- Luminesce. We show creating datetime objects. And also 
-- converting datetime objects to strings.
-- For more information, see official sqlite page on working 
-- with dates:
-- https://www.sqlite.org/lang_datefunc.html

--============================================================

@dt_examples = select 

-- Generate date and datetime objects

date("2025-01-16") as DateObj,
date('Now') as DateObjNow,
datetime() as DateTimeObj, -- defaults to "Now"

-- Generate strings from datetime objects

strftime('%Y-%m-%d', date()) as DateString,
strftime('%Y-%m-%dT%H:%M%SZ', datetime()) as DateTimeIsoString,
strftime('%Y-%m-%d %H:%M%S', datetime('now', '+7 days')) as DateTimeNextWeek;

select * from @dt_examples;
