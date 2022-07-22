-- ============================================================

-- Description:
-- This query shows you how to delete a custom view
-- Wait 5 seconds after delete before attempting to re-create
-- This give the view time to reset on the Luminesce grid

-- ============================================================


@delete_model_portfolios_view =

use Sys.Admin.SetupView
--provider=Test.Example.TestHoldings
--deleteProvider
----

select 1 as deleting_view


enduse;

select * from @delete_model_portfolios_view;
