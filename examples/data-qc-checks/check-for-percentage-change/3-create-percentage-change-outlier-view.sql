-- ============================================================
-- Description:
-- Here we build a view which will return all the quotes for 
-- all the Insruments in a Quote Scop with a percentage change over 50% from the 
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

@quote_data = 
select distinct
    i.InstrumentId
from Lusid.Instrument.Quote i 
where 
    QuoteScope=@@QuoteScope and
    InstrumentIdType = @@IdentifierType;
    
    

-- 3. Collect instrument static and print view of the outliers for the  & date range to console

select
    i.InstrumentId,
    r.QuoteType,
    r.Field,
    r.QuoteEffectiveAt,
    r.Value,
    r.PreviousValue,
    r.[Percentage Change]
from
    @quote_data i
    cross apply
    (
        select * from
        Custom.PriceCheck.PercentageChange pc
        where pc.StartDate = @@StartDate
        and pc.EndDate = @@EndDate
        and pc.InstId = i.InstrumentId
        and pc.Scope = @@QuoteScope
        and pc.Percentage = @@PercentageChange
    ) r
    


enduse;

select *
from @price_check_view;