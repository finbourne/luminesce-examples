-- #################### SUMMARY ####################

-- 1. This query shows you can query application logs in Insights.
-- 2. In the example, we count the number of successful requests since yesterday.

-- #################################################

-- set a pragma of 3 mins
pragma TimeoutSec = 180;

-- Define a variable for yesterday
@@yesterday =

select date ('now', '-1 hour');

-- Count the number of requests per method since midnight yesterday
-- NOTE: uncomment to run in production

select Method, count(*) as [CountOfRequests]
from Lusid.Logs.AppRequest
where Application = 'Lusid'
   and StatusCode = '200'
   and timestamp > @@yesterday
group by Method
order by count(*) desc
limit 1000;