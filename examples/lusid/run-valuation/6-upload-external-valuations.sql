-- ============================================================================
-- Description:
-- In this file, we upsert external valuations into the Structured Result Store
-- External valuations are loaded from a file located in LUSID Drive
-- ============================================================================

-- Load a CSV file of valuations from LUSID Drive

@valuations = use Drive.Csv
--file=/luminesce-examples/external_valuations.csv
enduse;

-- Create SRS Document

@header = values ('PortfolioScope','PortfolioCode','ValuationDate','InstrumentId','Currency','External-MarketValue');

@header_valuations = 
select 
column1 as PortfolioScope,
column2 as PortfolioCode,
column3 as ValuationDate,
column4 as InstrumentId,
column5 as Currency,
column6 as [External-MarketValue] from @header
union
select * from @valuations;


@y = 
select 
PortfolioScope   
|| ','
|| PortfolioCode
|| ','
|| ValuationDate 
|| ','
|| InstrumentId
|| ','
|| Currency
|| ','
|| [External-MarketValue]
 as a_row
from @header_valuations
order by PortfolioScope desc;

@@doc = select group_concat(a_row, '
') x from @y;

-- Upsert valuations Document

@data_to_upsert = 
select 
'ibor' as Scope,
'MarketValuation' as Code,
'UnitResult/Holding' as ResultType,
'Client' as Source,
'Market valuations' as Name,
'market-srs-valuation-map' as DataMapCode,
'0.1.1' as DataMapVersion,
'0.1.1' as Version,
'Csv' as [Format],
@@doc as Document,
'2020-08-24T09:00:00.000Z' as EffectiveAt,
'Upsert' as WriteAction;

select * from Lusid.UnitResult.StructuredResult.Writer where ToWrite = @data_to_upsert;