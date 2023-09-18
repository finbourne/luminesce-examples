@@volatility = select 0.5;

@days = 
select date(#2024-01-01#, '-' || Value || ' days', '+1 days') as [Date]
from Tools.[Range] where number = 1000
and Start = 0;

@data = 
select [Date], CASE WHEN RANDOM() % 2 = 0 THEN @@volatility ELSE (@@volatility * -1) END AS random_sign from @days;

SELECT [Date],
       1.2 + SUM(0.01 * random_sign) OVER (ORDER BY [Date]) AS rate
FROM @data;
