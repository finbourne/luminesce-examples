-- ============================================================
-- Description:
-- In this file, we run a valuation using the data which was
-- previously loaded, including valuations from SRS 
-- You also need a recipe which is setup by the _data/setup.py file.
-- ============================================================

-- Select some metrics to be returned by the valuation engine

@measure =
select 'Instrument/default/Name' as MeasureName, 'Value' as Operation union
select 'Valuation/PV/Ccy' as MeasureName, 'Value' as Operation union
select 'Valuation/PV/Amount' as MeasureName, 'Sum' as Operation union
select 'UnitResult/External-MarketValue' as MeasureName, 'Sum' as Operation; -- retrieved from SRS

-- Run the valuation for a given recipe, portfolio and date

@vals = 
select *
from lusid.portfolio.valuation
where PortfolioCode = 'uk-equity'
   and PortfolioScope = 'ibor'
   and Recipe = 'ibor/market-value'
   and MeasuresToReturn = @measure
   and EffectiveAt = '2020-08-24T09:00:00.000Z';

-- Pivot the values into a traditional report format

@vals_formatted =
use Tools.Pivot with @vals
--key=MeasureName
--aggregateColumns=MeasureDecimalValue,MeasureStringValue
enduse;

select
PortfolioCode as 'Portfolio',
ValuationDate as 'Val Date',
[Instrument/default/Name_MeasureStringValue] as 'InstrumentName',
[Valuation/PV/Ccy_MeasureStringValue] as 'Currency',
[Sum(Valuation/PV/Amount)_MeasureDecimalValue] as 'MarketValue',
[Sum(UnitResult/External-MarketValue)_MeasureDecimalValue] as 'External-MarketValue'
from @vals_formatted;
