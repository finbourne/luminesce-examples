-- ######################### SUMMARY #########################

-- 1. This query shows you how to make a view
-- 2. Luminesce views are effectively custom providers
-- 3. You can think of them as being somewhat like stored procs

-- #########################################################

-- First delete the view if it already exists
@delete_model_portfolios_view =

use Sys.Admin.SetupView
--provider=Test.Example.TestHoldings
--deleteProvider

----

select 1 as deleting

enduse;

-- Wait 5 seconds after delete before attempting to re-create
-- This give the view time to reset on the Luminesce grid
@delete_model_portfolios_view_response =

select *
from @delete_model_portfolios_view wait 5;

-- The Sys.Admin.SetupView provider
@model_portfolios_view =

use Sys.Admin.SetupView
--provider=Test.Example.TestHoldings

----

@model_portfolios = use Drive.csv
--file=/luminesce-examples/model_portfolios.csv
enduse;

select
    #distinct
  #select_agg
{
    {ModelPortfolioName^ : model_port_name},
    {Sector: sect},
    {Region: loc},
    {Weighting: weighting}
}

from @model_portfolios
where #restrict_agg

enduse;

select * from @model_portfolios_view;