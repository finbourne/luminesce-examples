-- ============================================================
-- Description:
-- This query shows you how to check for outliers in a CSV
-- file on Drive. We define outliers as observations that
-- fall below Q1 - 1.5 IQR or above Q3 + 1.5 IQR
-- ============================================================

@price_check_view = use Sys.Admin.SetupView
--provider=Custom.OutlierCheck.Prices
--parameters
StartDate,Date,2022-01-01,true
EndDate,Date,2022-12-31,true
Sector,Text,Technology,true
----

@@Sector = select #PARAMETERVALUE(Sector);
@@StartDate = select #PARAMETERVALUE(StartDate);
@@EndDate = select #PARAMETERVALUE(EndDate);

-- Collect quotes for instrument

@instrument_data = select
ClientInternal
from Lusid.Instrument.Equity
where Sector = @@Sector;

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