-- ==========================================================================
-- Description:
-- Here we build a view which will return all the P/E ratio outliers within
-- a threshold of 2 standard deviations from the mean for a given
-- EffectiveAt/AsAt date and belonging to the group (Sector = Utility)
-- ==========================================================================
-- 1. Create view and set parameters

@cross_sectional_view =
use Sys.Admin.SetupView
--provider=DataQc.CrossSectionalOutlierCheck
--parameters
AsAt,Date,2023-07-06,true
EffectiveAt,Date,2023-07-06,true
StandardDeviations,Int,2,true
PropertyScopes,Text,ibor,true
PropertyKeys,Text,Sector,true
PropertyValues,Text,Utility,true
----
@@StandardDeviations = select  #PARAMETERVALUE(StandardDeviations);
@@Property_Scope = select #PARAMETERVALUE(PropertyScopes);
@@Property_Key = select  #PARAMETERVALUE(PropertyKeys);
@@Property_Value = select  #PARAMETERVALUE(PropertyValues);
@@AsAt = select #PARAMETERVALUE(AsAt);
@@EffectiveAt = select #PARAMETERVALUE(EffectiveAt);

-- 2. Collect instruments within property Scope/Code and get instrument pe_ratio propertys

@custom_props = 
select p.InstrumentId, b.propertycode as PCode, b.Value as PVal
from Lusid.Instrument.Property p
inner join (
select InstrumentId, propertycode, Value
   from Lusid.Instrument.Property p
   where propertyscope = 'Fundamentals' 
   and propertycode = 'pe_ratio') b
   on p.InstrumentId = b.InstrumentId
   where p.propertyscope = @@Property_Scope 
   and p.propertycode = @@Property_Key 
   and p.Value = @@Property_Value ;

@pivoted = 
use Tools.Pivot with @custom_props
--key=PCode
--aggregateColumns=PVal
enduse;

-- 3. Join properties onto Instrument data
@instruments = 
select q.*, p.*
from @pivoted p
inner join (
select *
from Lusid.Instrument
where Scope = 'PriceEarningRatioScope'
) q
on q.LusidInstrumentId = p.InstrumentId;


-- 3. Calculate group mean & SD
@@mean = select avg(pe_ratio) from @instruments;
@sd = select power(avg(power(pe_ratio - @@mean, 2)), 0.5) as x from @instruments;
@@sd = select x from @sd;

@@mean_log = select print('Mean: {X} ', '', 'Logs', @@mean);
@@sd_log = select print('SD: {X} ', '', 'Logs', @@sd);

-- 4. Filter Instruments that are outliers within x Standard Deviations from the mean
select
    InstrumentId,DisplayName,pe_ratio,
    'Outlier' as Result
from @instruments
where abs(pe_ratio - @@mean) >= @@StandardDeviations * @@sd

enduse;

select *
from @cross_sectional_view;
