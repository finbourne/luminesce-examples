--================================================================

-- Description:
-- In this query we demonstrate uses cases of the to_utc function
-- which takes a string or datetime, with a timezone, and returns
-- a UTC adjusted timezone string.

--================================================================

@data = use Drive.csv
--file=/luminesce-examples/to-utc-datetimes.csv
enduse;

select 

-- Convert ISO strings to UTC

to_utc('2023-01-01', 'Europe/London') as stringDateAsUtc1,
to_utc('2023-07-01 11:00:31', 'Europe/London') as stringDateSummerAsUtc1,
to_utc('2023-01-01 10:00:00', 'US/Eastern') as stringDateAsUtc2,
to_utc('2023-07-01', 'US/Eastern') as stringDateSummerAsUtc2,

-- Convert datetimes to UTC

to_utc(#2023-07-01#, 'Europe/Paris') as datetimeToUtc,


-- Convert non ISO strings to UTC
-- Intermediate conversion completed with the to_date function, which uses the following format
-- https://learn.microsoft.com/en-us/dotnet/standard/base-types/custom-date-and-time-format-strings

to_utc(to_date(Date1 || ' ' || Time1, 'MM/dd/yyyy htt'), 'US/Pacific') as usFormatDateTime,
to_utc(to_date(Date2 || ' ' || Time2, 'yyyy-MM-dd HH:mm'), 'Europe/Dublin') as utcFormatDateTime,
to_utc(to_date(Date3 || ' ' || Time3, 'dd/MM/yyyy h:mmtt'), 'Europe/London') as ukFormatDateTime,

-- Convert datetimes to ISO strings

to_iso(#2022-03-23#) as isoDateTimeString1,
to_iso(#2022-03-23 14:23:45#) as isoDateTimeString2

from @data;