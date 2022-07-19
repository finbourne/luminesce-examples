-- #################### SUMMARY ####################

-- 1. This query shows you how to load a CSV file from LUSID Drive

-- #################################################

@data = use Drive.csv
--file=/luminesce-examples/equity_transactions.csv
enduse;

select * from @data;
