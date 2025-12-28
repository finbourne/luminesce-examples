-- ============================================================
-- Description:
-- Here we build a view which will return the Quotes that fail 
-- our Mid/Bid/Ask sensibility checks for all the Instrument 
-- within a Quote scope with a tolerance of 1% 
-- ============================================================
-- 1. Create view and set parameters
@price_check_view =

use Sys.Admin.SetupView
--provider=DataQc.MidBidAskSensibilityCheck
--parameters
StartDate,Date,2018-01-01,true
EndDate,Date,2020-12-31,true
IdType,Text,Figi,true
Tolerance,Decimal,0.01,true
QuoteScope,Text,luminesce-examples,true
----


@@StartDate = select #PARAMETERVALUE(StartDate);
@@EndDate = select #PARAMETERVALUE(EndDate);
@@IdentifierType = select #PARAMETERVALUE(IdType);
@@Tolerance = select #PARAMETERVALUE(Tolerance);
@@QuoteScope = select #PARAMETERVALUE(QuoteScope);


-- 2. Collect quotes for instrument

@quote_data = 
select distinct
    i.InstrumentId
from Lusid.Instrument.Quote i 
where 
    QuoteScope=@@QuoteScope and
    InstrumentIdType = @@IdentifierType;
    
    

-- 3. Collect instrument static and print view of the failed for the sensibility checks to console

select
    i.InstrumentId,
    r.QuoteEffectiveAt,
    r.Mid,
    r.Ask,
    r.Bid,
    r.[Calculated Mid],
    r.[Calculated Ask],
    r.[Calculated Bid],
    r.[Sensibility check]
from
    @quote_data i
    cross apply
    (
        select * from
       Custom.MidBidAskSensibility mbas
        where mbas.StartDate = @@StartDate
        and mbas.EndDate = @@EndDate
        and mbas.InstId = i.InstrumentId
        and mbas.IdType = @@IdentifierType
        and mbas.QuoteScope = @@QuoteScope
        and mbas.Tolerance = @@Tolerance
    ) r
    
enduse;

select *
from @price_check_view;