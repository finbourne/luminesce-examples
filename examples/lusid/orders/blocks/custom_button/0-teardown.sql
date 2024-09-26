/*

---------------------------
Custom Button Teardown
---------------------------

Description:

-- This query deletes the custom action view created in 2-create-custom-button.sql
-- Wait 5 seconds after delete before running 
-- This give the view time to reset on the Luminesce grid

More details:

https://github.com/finbourne/luminesce-examples/blob/master/examples/view-management/7-delete-a-view.sql

 */
-----------UNCOMMENT BELOW TO USE-------
/*

@@providerName = SELECT 'Set_contingent_order_id';

@delete_model_portfolios_view = USE Sys.Admin.SetupView WITH @@providerName
--provider={@@providerName}
--deleteProvider
----

SELECT 1 AS deleting_view;

enduse;

SELECT * FROM @delete_model_portfolios_view;

 */