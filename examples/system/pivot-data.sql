-- #################### SUMMARY ####################

-- 1. This query show you how to pivot data using the "use Tools.Pivot" tool

-- #################################################

-- Load a file of model allocations from Drive
-- The data is structured as one row per portfolio-sector-location allocation

@model_portfolios_orginal = use Drive.csv
--file=/luminesce-temp-system-testing-folder/model_portfolios.csv
enduse;

-- Transform the data

@model_portfolios_formatted =
select model_port_name as [ModelPortfolioCode],
weighting as [AllocationPercentage],
(sect || "_" || loc) as [AllocationTarget]
from @model_portfolios_orginal;

-- Pivot the data so the model portfolio codes are returned as columns

@model_portfolios_pivoted  =
use Tools.Pivot with @model_portfolios_formatted
--key=ModelPortfolioCode
--aggregateColumns=AllocationPercentage
enduse;

select * from @model_portfolios_pivoted;
