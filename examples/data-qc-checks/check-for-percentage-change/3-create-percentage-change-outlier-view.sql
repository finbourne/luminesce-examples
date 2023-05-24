-- ============================================================
-- Description:
-- Here we build a view which will return all the quotes for 
-- all the Quotes in a Quote Scope with a percentage change over 50% from the 
-- previous price within a date range
-- ============================================================
-- 1. Create view and set parameters
@price_check_view =

use Sys.Admin.SetupView
--provider=DataQc.OutlierCheck.PercentageChange
--parameters
StartDate,Date,2019-01-01,true
EndDate,Date,2023-12-31,true
IdType, Text,ClientInternal,true
Percentage, DECIMAL,0.50,true
QuoteScope, Text,luminesce-examples,true
----


@@StartDate = select #PARAMETERVALUE(StartDate);
@@EndDate = select #PARAMETERVALUE(EndDate);
@@IdentifierType = select #PARAMETERVALUE(IdType);
@@PercentageChange = select #PARAMETERVALUE(Percentage);
@@QuoteScope = select #PARAMETERVALUE(QuoteScope);


-- 2. Collect quotes for instrument

@instrument_data =
    select
        i.ClientInternal
    from Lusid.Instrument.Equity i
    where ClientInternal is not null;
    
    

-- 3. Collect instrument static and print view of the outliers for the  & date range to console

select
    i.ClientInternal,
    r.QuoteType,
    r.Field,
    r.QuoteEffectiveAt,
    r.Value,
    r.PreviousValue,
    r.[Percentage Change]
from
    @instrument_data i
    cross apply
    (
        select * from
        Custom.PriceCheck.PercentageChange pc
        where pc.StartDate = @@StartDate
        and pc.EndDate = @@EndDate
        and pc.InstId = i.ClientInternal
        and pc.Scope = @@QuoteScope
        and pc.Percentage = @@PercentageChange
    ) r
    


enduse;

select *
from @price_check_view;