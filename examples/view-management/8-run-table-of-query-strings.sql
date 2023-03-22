/*

-- Description:
-- Run a table of query strings

===========================================
    1. Create a view to run query strings 
===========================================
*/


@sqlRunner = use Sys.Admin.SetupView 
--provider=AdHocQuery.Runner
--parameters   
sqlString,Text,select * from sys.field limit 2;,true
----

@@sep = select '--' || '--';
@@sql = select #PARAMETERVALUE(sqlString);

@x = use Sys.Admin.SetupView with @@sql, @@sep
{@@sep}
{@@sql}

enduse;

select 'Done' as Result;

enduse;

@createQueryView = select * from @sqlRunner; 

/*
=================================
    2. Define a set of queries 
=================================

    In the example below, we have defined the query strings directly in this script.
    In practice, you might want to load these from another location such as the LUSID
    config store.

*/

@sqlStrings = select 
'select * from lusid.instrument limit 5' as 'sql_strings'
union all
values
('select * from sys.field limit 10'),
('select LusidInstrumentId, CouponRate from Lusid.Instrument.Bond limit 10');

/*
===================================
    3. Run the queries
===================================
*/

select s.sql_strings, results.*
from @sqlStrings s
outer apply (
        select a.^
        from Adhocquery.Runner a
        where a.sqlString = s.sql_strings
) results;
