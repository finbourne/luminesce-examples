-- ============================================================
-- Description:
-- Here we build a view which will return the outlier for all
-- Equities that have a ClientInternal between two date ranges
-- within a given Quote Scope with a Z Score limit of 2
-- ============================================================
-- 1. Create view and set parameters
@price_check_view =

use Sys.Admin.SetupView
--provider=DataQc.OutlierCheck.SD
--parameters
StartDate,Date,2022-01-01,true
EndDate,Date,2022-12-31,true
AssetClass,Text,Equity,true
ZScoreLimit,Int,2,true
QuoteScope,Text,luminesce-examples,true

----

@@StartDate = select #PARAMETERVALUE(StartDate);
@@EndDate = select #PARAMETERVALUE(EndDate);
@@AssetClass = select #PARAMETERVALUE(AssetClass);
@@ZScoreLimit = select #PARAMETERVALUE(ZScoreLimit);
@@QuoteScope = select #PARAMETERVALUE(QuoteScope);

-- 2. Collect quotes for instrument


@instrument_data = select
*
from Lusid.Instrument.Equity i
where i.[Type]=@@AssetClass
and ClientInternal is not null;

-- 3. Collect instrument static and print view of the outliers for the given sector & date range to console

select
    i.ClientInternal,
    r.DisplayName,
    r.PriceDate,
    r.Price,
    r.Result,
    r.ZScore
from
    @instrument_data i
    cross apply
    (
        select * from
        Custom.PriceCheck.Standarddeviation sd
        where sd.InstId = i.ClientInternal
        and sd.StartDate = @@StartDate
        and sd.EndDate = @@EndDate
        and sd.ZScoreLimit = @@ZScoreLimit
        and sd.QuoteScope = @@QuoteScope
    ) r



enduse;

select *
from @price_check_view;

