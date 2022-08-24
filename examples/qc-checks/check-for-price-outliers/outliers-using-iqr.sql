-- ============================================================
-- Description:
-- This query shows you how to check for outliers in a CSV
-- file on Drive. We define outliers as observations that
-- fall below Q1 - 1.5 IQR or above Q3 + 1.5 IQR
-- ============================================================

-- Load data from CSV

@price_ts = use Drive.Csv
--file=/luminesce-examples/price_time_series.csv
--types=date,text,decimal
enduse;

-- Calculate the IQRs

@iqr_data = select
interquartile_range(price) * (1.5) as [iqr_x1_5],
quantile(price, 0.25) as [q1],
quantile(price, 0.75) as [q3]
from @price_ts;

-- Define and upper and lower limit for our price check

@@upper_limit = select (q3 + iqr_x1_5 ) from  @iqr_data;
@@lower_limit = select (q1 - iqr_x1_5 ) from  @iqr_data;

-- Print upper and lower limits to console

@@upper_limit_log = select print('Upper limit for outlier check: {X:00000} ', '', 'Logs', @@upper_limit);
@@lower_limit_log = select print('Lower limit for outlier check: {X:00000} ', '', 'Logs', @@lower_limit);

-- Run the check to search for outliers

select
price_date,
price,
'Outlier' as result
from
@price_ts
where price not between @@lower_limit and @@upper_limit;
