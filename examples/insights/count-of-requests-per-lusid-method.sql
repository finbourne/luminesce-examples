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

select Method, count(*) as [CountOfRequests]
from Lusid.Logs.AppRequest
where Application = 'Lusid'
   and StatusCode = '200'
   and timestamp > @@yesterday
group by Method
order by count(*) desc
limit 1000;
