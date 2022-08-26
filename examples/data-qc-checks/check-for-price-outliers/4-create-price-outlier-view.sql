-- ============================================================
-- Description:
-- Here we build a view which will return outlier for all
-- Equities in a given sector between two date ranges
-- ============================================================

@price_check_view = use Sys.Admin.SetupView
--provider=DataQc.OutlierCheck.Prices
--parameters
StartDate,Date,2022-01-01,true
EndDate,Date,2022-12-31,true
Sector,Text,Technology,true
AssetClass,Text,Equity,true
----

@@Sector = select #PARAMETERVALUE(Sector);
@@StartDate = select #PARAMETERVALUE(StartDate);
@@EndDate = select #PARAMETERVALUE(EndDate);
@@AssetClass = select #PARAMETERVALUE(AssetClass);

-- Collect quotes for instrument

@instrument_data = select
ClientInternal
from Lusid.Instrument.Equity
where Sector = @@Sector
and [Type]=@@AssetClass;

-- Collect instrument static

select
    i.ClientInternal,
    r.DisplayName,
    r.PriceDate,
    r.Price,
    r.LowerLimit,
    r.UpperLimit,
    r.Result
from
    @instrument_data i
    cross apply
    (
        select * from
        Custom.PriceCheck.OnePointFiveIQR iqr
        where iqr.StartDate = @@StartDate
        and iqr.EndDate = @@EndDate
        and iqr.InstrumentId = i.ClientInternal
    ) r

enduse;

select * from @price_check_view;