-- UPSERT
@data =

use Drive.RawText
--file=/Test/PortfolioHoldings.csv
enduse;

@@csv_string =

select Content
from @data;

@@scope =

select 'external_valuations' || strftime('%Y%m%d%H', 'now');

@@code =

select 'port-global-equity';

@upsert1 =

select --doc 1
   @@scope as Scope, @@code as Code, @@code as Name, 'Client' as Source, 'Risk' as ResultType, #2020-01-01#
   as EffectiveAt, @@csv_string as Document, 'csv' as Format, '0.0.1' as Version, null as DataMapCode, null
   as DataMapVersion, 'Upsert' as WriteAction;

@x =

select *
from Lusid.UnitResult.StructuredResult.Writer
where ToWrite = @upsert1
   and WriteErrorCode is 0;

-- GET
@resultDetails =

select @@scope as Scope, @@code as Code, 'Client' as Source, 'Risk' as ResultType, #2020-01-01# as
   EffectiveAt;

select *
from Lusid.UnitResult.StructuredResult
where ToLookUp = @resultDetails;
