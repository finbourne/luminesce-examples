-- =======================================================
-- Description:
-- 1. In this query, we use the portfolio created in step 1 
-- and return values from step 2 to aggreate our returns 
-- with various metrics
-- =======================================================

-- Defining scope and code variables
@@portfolioScope =

select 'IBOR';

@@portfolioCode1 =

select 'uk-equity';

-- Define values to be matched with throughout the portfolios
@lookup_table = 

select @@portfolioScope as PortfolioScope,
       @@portfolioCode1 as PortfolioCode,
       'Production' as ReturnScope,
       'Performance' as ReturnCode;

-- Define performance metrics
@perfMetrics =  select '1D' as WindowMetric, false as AllowPartial, false as WithFee, false as Annualised, '1 Day' as Alias
                union all
                select 'INC' as WindowMetric, false as AllowPartial, false as WithFee, false as Annualised, 'Inception' as Alias
                union all
                select 'WTD' as WindowMetric, false as AllowPartial, false as WithFee, false as Annualised, 'Week-to-Date' as Alias
                union all
                select 'MTD' as WindowMetric, false as AllowPartial, false as WithFee, false as Annualised, 'Month-to-Date' as Alias
                union all
                select 'QTD' as WindowMetric, false as AllowPartial, false as WithFee, false as Annualised, 'Quarter-to-Date' as Alias
                union all
                select 'YTD' as WindowMetric, false as AllowPartial, false as WithFee, false as Annualised, 'Year-to-Date' as Alias
                union all
                select '1M-ROLLING' as WindowMetric, false as AllowPartial, false as WithFee, false as Annualised, '1 Month Rolling' as Alias
                union all
                select '3M-ROLLING' as WindowMetric, false as AllowPartial, false as WithFee, false as Annualised, '3 Month Rolling' as Alias
                union all
                select '1Y-ROLLING' as WindowMetric, false as AllowPartial, false as WithFee, false as Annualised, '1 Year Rolling' as Alias
                union all
                select 'SINCE(2014-03-19)' as WindowMetric, false as AllowPartial, false as WithFee, false as Annualised, 'Since 19-04-2014' as Alias
                union all
                select 'INC' as WindowMetric, false as AllowPartial, false as WithFee, true as Annualised, 'Annualised since Inception' as Alias
                union all
                select '5Y-ROLLING' as WindowMetric, false as AllowPartial, false as WithFee, true as Annualised, 'Annualised 5 Year Rolling' as Alias;

-- Aggregate returns from portfolio
select * from Lusid.Portfolio.AggregatedReturn 
                  where ToLookUp = @lookup_table
                  and PerformanceReturnMetrics = @perfMetrics;