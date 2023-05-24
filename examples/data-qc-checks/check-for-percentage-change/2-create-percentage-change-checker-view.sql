-- ============================================================
-- Description:
-- Here we build a view which will return all the quotes for 
-- an instrument with a percentage change over 50% from the 
-- previous price for a given Quote Scope within a date range
-- ============================================================
@outlier_view = use Sys.Admin.SetupView
--provider=Custom.PriceCheck.PercentageChange
--parameters
StartDate,Date,2019-01-01,true
EndDate,Date,2023-12-31,true
InstId,Text,EQ56JD720LSU,true
IdType, Text,ClientInternal,true
Percentage, DECIMAL,0.50,true
Scope, Text,luminesce-examples,true
----


@@StartDate = select #PARAMETERVALUE(StartDate);
@@EndDate = select #PARAMETERVALUE(EndDate);
@@InstId = select #PARAMETERVALUE(InstId);
@@IdentifierType = select #PARAMETERVALUE(IdType);
@@PercentageChange = select #PARAMETERVALUE(Percentage);
@@QuoteScope = select #PARAMETERVALUE(Scope);


@quotes_data = 
select
    *,
    lag(Value, 1) over (order by QuoteEffectiveAt) PreviousValue
from Lusid.Instrument.Quote
where 
    QuoteScope= @@QuoteScope and 
    InstrumentIdType = @@IdentifierType and 
    QuoteType = 'Price' and
    InstrumentId = @@InstId and 
    QuoteEffectiveAt between @@StartDate and @@EndDate;
    
@@percentage_log = select print('Percentage: {XXXX} ', '', 'Logs', @@PercentageChange);

    
    
select
    *, (abs(Cast(Value as double) - Cast(PreviousValue as double))/Cast(PreviousValue as double)) as [Percentage Change]
from @quotes_data
where abs(Cast(Value as double) - Cast(PreviousValue as double))/Cast(PreviousValue as double) > @@PercentageChange;

enduse;

select * from @outlier_view ;