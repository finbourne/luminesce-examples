-- #################### SUMMARY ####################

-- 1. This query shows you the contents of a view
-- 2. The results alone cannot be used to recreate the view
-- 3. You will need to make some small modifications

-- #################################################

select Content from sys.file where name = 'TestHoldings' and extension = '.sql';