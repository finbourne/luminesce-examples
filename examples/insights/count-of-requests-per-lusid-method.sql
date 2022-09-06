-- ===============================================================
-- Description:
-- 1. This query shows you can query application logs in Insights.
-- 2. In the example, we count the number of successful
-- requests since yesterday.
-- ===============================================================

-- Set this query to timeout after 3 minutes, via a PRAGMA.

pragma TimeoutSec = 180;

-- Define a variable for yesterday

@@yesterday =

select date ('now', '-1 day');

-- Count the number of requests per method since midnight yesterday

@aggregate = select Method, count(*) as [CountOfRequests]
from Lusid.Logs.AppRequest.Athena
where
 Application = 'lusid'
 and StatusCode = 200
 and StartAt = @@yesterday
group by 1;

-- avoids attempting to pass the order by
select * from @aggregate order by CountOfRequests desc;