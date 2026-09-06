-- ============================================================
-- Description:
-- Here we build a view which will return the Quotes that fail 
-- our Mid/Bid/Ask sensibility checks for an single Instrument 
-- within a Quote scope with a tolerance of 1% 
-- ============================================================
-- 1. Create view and set parameters
@sensibility_view = use Sys.Admin.SetupView
--provider=Custom.MidBidAskSensibility
--parameters
StartDate,Date,2018-01-01,true
EndDate,Date,2020-12-31,true
InstId,Text,BBG000T51A3,true
IdType,Text,Figi,true
Tolerance,Decimal,0.01,true
QuoteScope,Text,luminesce-examples,true
----
@@StartDate = select #PARAMETERVALUE(StartDate);
@@EndDate = select #PARAMETERVALUE(EndDate);
@@InstId = select #PARAMETERVALUE(InstId);
@@IdentifierType = select #PARAMETERVALUE(IdType);
@@Tolerance = select #PARAMETERVALUE(Tolerance);
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

-- 3. Calculate prices based on Mid/Bid/Ask Values
@data_qc = 
select mid.QuoteEffectiveAt, 
mid.Value as Mid, ask.Value as Ask,bid.Value as Bid,
(bid.Value + ask.Value) / 2 as [Calculated Mid],  
2*mid.Value - bid.Value as [Calculated Ask], 
2*mid.Value - ask.Value as [Calculated Bid]
from @quotes_data as mid
join @quotes_data as ask on mid.QuoteEffectiveAt = ask.QuoteEffectiveAt
join @quotes_data as bid on bid.QuoteEffectiveAt = ask.QuoteEffectiveAt
where mid.Field = 'Mid' and ask.Field = 'Ask' and bid.Field = 'Bid';


-- 4. Check whether calculated Vales are within @@Tolerance % of our data's values
@qc_check =
select *, case
     when abs(Cast([Calculated Bid] as double) - Cast(Bid as double))/Cast(Bid as double) < Cast(@@Tolerance as double) and
     abs(Cast([Calculated Ask] as double) - Cast(Ask as double))/Cast(Ask as double) < Cast(@@Tolerance as double) and
     abs(Cast([Calculated Mid] as double) - Cast(Mid as double))/Cast(Mid as double) < Cast(@@Tolerance as double)
            then 'Passed'
        else 'Failed'
      end as 'Sensibility check'
from @data_qc;

-- 5. Return the quotes that failed 
@qc_failed =
select *
from @qc_check
where [Sensibility check] = 'Failed';


select * FROM @qc_failed

enduse;

select * from @sensibility_view ;