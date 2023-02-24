-- ============================================================
-- Description:
-- Here we build a view which will return outliers for a given
-- instrument and date range. We define outliers as observations
-- that fall below Q1 - 1.5 IQR or above Q3 + 1.5 IQR
-- ============================================================
-- 1. Create view and set parameters
@outlier_view = use Sys.Admin.SetupView
--provider=Custom.PriceCheck.OnePointFiveIQR
--parameters
StartDate,Date,2022-01-01,true
EndDate,Date,2022-12-31,true
InstId,Text,EQ56JD720345,true
----

@@StartDate = select #PARAMETERVALUE(StartDate);
@@EndDate = select #PARAMETERVALUE(EndDate);
@@InstId = select #PARAMETERVALUE(InstId);

-- 2. Collect quotes for instrument

@quotes_data = select *
    from Lusid.Instrument.Quote
    where QuoteScope='luminesce-examples'
        and InstrumentIdType = 'ClientInternal'
        and QuoteType = 'Price'
        and InstrumentId = @@InstId
        and QuoteEffectiveAt between @@StartDate and @@EndDate;

-- 3. Collect instrument static and join on data for sector instrument property

@instrument_data = select
    i.ClientInternal,
    i.DisplayName,
    p.Value as Sector,
    i.InferredAssetClass as [AssetClass]
    from Lusid.Instrument.Equity i
    join Lusid.Instrument.Property p
        on p.InstrumentId=i.LusidInstrumentId
    where i.ClientInternal = @@InstId
        and propertyscope = 'ibor'
        and propertycode = 'Sector';

-- 4. Generate time series

@price_ts = select
    ClientInternal,
    DisplayName,
    Sector,
    AssetClass,
    QuoteEffectiveAt as [PriceDate],
    Unit as [Currency],
    Value as [Price]
    from @instrument_data i
    join @quotes_data q on (i.ClientInternal = q.InstrumentId);

-- 5. Run IQR checks

@iqr_data = select
    interquartile_range(price) * (1.5) as [iqr_x1_5],
    quantile(price, 0.25) as [q1],
    quantile(price, 0.75) as [q3]
    from @price_ts;

-- 6. Define and upper and lower limit for our price check

@@upper_limit = select (q3 + iqr_x1_5 ) from  @iqr_data;
@@lower_limit = select (q1 - iqr_x1_5 ) from  @iqr_data;

-- 7. Print upper and lower limits to console

@@upper_limit_log = select print('Upper limit for outlier check: {X:00000} ', '', 'Logs', @@upper_limit);
@@lower_limit_log = select print('Lower limit for outlier check: {X:00000} ', '', 'Logs', @@lower_limit);

select
    PriceDate,
    ClientInternal,
    DisplayName,
    @@upper_limit as [UpperLimit],
    @@lower_limit as [LowerLimit],
    Price,
    'Outlier' as Result
from @price_ts
where price not between @@lower_limit and @@upper_limit;

enduse;

select * from @outlier_view ;