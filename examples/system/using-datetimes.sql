--============================================================

-- Description:
-- In this file we show some examples of working with dates in
-- Luminesce. We show creating datetime objects. And also 
-- converting datetime objects to strings.
-- For more information, see official sqlite page on working 
-- with dates:
-- https://www.sqlite.org/lang_datefunc.html

--============================================================

@dt_examples =

select

-- Generate date and datetime objects

date("2025-01-16") as DateObject,
date('Now') as DateObjectNow,
datetime() as DateTimeObject, -- defaults to "Now"

-- Generate strings from datetime objects

strftime('%Y-%m-%d', date()) as DateString,
strftime('%Y-%m-%dT%H:%M%SZ', datetime()) as DateTimeIsoString,
strftime('%Y-%m-%d %H:%M%S', datetime('now', '+7 days')) as DateTimeNextWeek,

-- Generate datetimes from strings
-- to_date can accept strings in any of these formats:
-- https://learn.microsoft.com/en-us/dotnet/standard/base-types/custom-date-and-time-format-strings

to_date("13/02/2023", "dd/MM/yyyy") as DateFromUkFormattedString,
to_date("02-13-2023", "MM-dd-yyyy") as DateFromUsFormattedString,
to_date("13/02/2023 14:23:45", "dd/MM/yyyy HH:ss:mm") as DateTimeFromUkFormattedString,
to_date('2022-01-01 3AM', 'yyyy-MM-dd htt') as StringWithAmToDatetime,
to_date('2022-01-01 3PM', 'yyyy-MM-dd htt') as StringWithPmToDatetime;


select * from @dt_examples;
