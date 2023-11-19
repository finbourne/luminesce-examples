/*

---------------------------
Basic Data Integrity Checks
---------------------------

Description:

    - In this query, we run some basic data integrity checks using a Luminesce view
    - This can be run via a view in the workflow engine

More details:

    https://support.lusid.com/knowledgebase/article/KA-02218/en-us

*/


@data_qc = use Sys.Admin.SetupView
--provider=DataQc.IntegrityChecks
--parameters
file_name,Text,/luminesce-examples/price_ts.csv,true
----

@@file_name = select #PARAMETERVALUE(file_name);

@prices = use Drive.Csv with @@file_name
--file={@@file_name}
enduse;

@@today = select date();

select 
*,
case 
    when cast(instrument_id as varchar) is null then 'Missing Instrument ID' 
    else 'OK' 
    end as 'Instrument Id Check',
case 
    when cast(ccy as varchar) is null then 'Missing Currency' 
    else 'OK' 
    end as 'Currency Check',
case 
    when cast(price as double) is null then 'Null Price' 
    else 'OK' 
    end as 'Price Null Check',
case 
    when price is null then 'Null Price'
    when cast(price as double) > 1000 then 'Suspiciously large price'
    else 'OK'
    end as 'Price Outlier Check',
case when to_date(price_date, "dd/MM/yyyy")  > @@today then 'Bad Date' 
    else 'OK' 
    end as 'Date Check'
from @prices;

enduse;

select * from @data_qc 
