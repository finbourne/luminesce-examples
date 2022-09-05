-- =========================================================
--  Description:
--  1. This query shows you the contents of a view
--  2. The results alone cannot be used to recreate the view
--  3. You will need to query sys.logs.hcquery to get the SQL
--  used to create  a view
-- =========================================================

select Content from sys.file where name = 'TestHoldings' and extension = '.sql';