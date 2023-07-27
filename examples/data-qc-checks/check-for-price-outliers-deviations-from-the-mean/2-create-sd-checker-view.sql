-- ============================================================
-- Description:
-- Here we build a view which will return outliers for a given
-- instrument and date range. We define outliers as observations
-- that fall under the Z-score limit provided
-- ============================================================
@outlier_view = use Sys.Admin.SetupView
--provider=Custom.PriceCheck.StandardDeviation
--parameters
StartDate,Date,2019-01-01,true
EndDate,Date,2023-12-31,true
InstId,Text,EQ56JD720MDJ,true
IdType, Text,ClientInternal,true
ZScore,Int,2,true
QuoteScope,Text,luminesce-examples,true
----

@@StartDate = select #PARAMETERVALUE(StartDate);
@@EndDate = select #PARAMETERVALUE(EndDate);
@@InstId = select #PARAMETERVALUE(InstId);
@@IdentifierType = select #PARAMETERVALUE(IdType);
@@ZScore = select  #PARAMETERVALUE(ZScore);
@@QuoteScope = select #PARAMETERVALUE(QuoteScope);


-- 2. Collect quotes for instrument

@quotes_data = 
select
    *
from Lusid.Instrument.Quote
where 
    QuoteScope=@@QuoteScope and 
    InstrumentIdType = @@IdentifierType and 
    QuoteType = 'Price' and 
    InstrumentId = @@InstId and 
    QuoteEffectiveAt between @@StartDate and @@EndDate;
    
    
    
-- 3. Collect Instrument data
@instrument_data = select
    i.ClientInternal,
    i.DisplayName,
    i.InferredAssetClass as [AssetClass]
    from Lusid.Instrument.Equity i
    where i.ClientInternal = @@InstId
    and Scope = 'StandardDeviationDQC';
    
    
-- 4. Generate Time series


@price_ts = select
    ClientInternal,
    DisplayName,
    AssetClass,
    QuoteEffectiveAt as [PriceDate],
    Unit as [Currency],
    Value as [Price]
    from @instrument_data i
    join @quotes_data q on (i.ClientInternal = q.InstrumentId);
    

-- 3. Run SD checks
    
@@mean = select avg(Price) from @price_ts;
@sd = select power(avg(power(Price - @@mean, 2)), 0.5) as x from @price_ts;
@@sd = select x from @sd;

@@sd_log = select print('SD: {X} ', '', 'Logs', @@sd);
@@mean_log = select print('Mean: {X} ', '', 'Logs', @@mean);


select
    *,
    (Price - @@mean) / @@sd AS Z_Score,
    'Outlier' as Result
from @price_ts
where abs((Price - @@mean) / @@sd) >= @@ZScore;


enduse;

select * from @outlier_view ;