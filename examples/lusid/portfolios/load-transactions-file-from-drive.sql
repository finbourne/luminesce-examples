-- Description: Load CSV file into Luminesce session

@data = use Drive.csv
--file=/luminesce-temp-testing-folder/equity_transactions.csv
enduse;

select * from @data;
