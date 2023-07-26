-- ============================================================
-- Description:
-- In this query we setup some instruments with a P/E property 
-- and a Sector proprerty
-- NOTE: You'll need to have the properties setup as an instrument
-- properties in LUSID and Luminesce as follows:
-- Instrument/ibor/Sector
-- Instrument/Fundamentals/pe_ratio
-- ============================================================

@@Scope = select 'PriceEarningRatioScope';

@instruments_data =

use Drive.Excel
--file=/luminesce-examples/PEdata.xlsx
--worksheet=instrument
enduse;

-- 1. Upload values for custom instrument properties
@ids =
select inst_id as Id
from @instruments_data;

@inst_properties =
select li.LusidInstrumentId as EntityId, 'LusidInstrumentId' as EntityIdType, 'Instrument' as Domain, a.PropertyScope as PropertyScope, a.PropertyCode, a.
  Value, @@Scope as EntityScope
from Lusid.Instrument li
inner join (
  select 'pe_ratio' as PropertyCode, 'Fundamentals' as PropertyScope, pe_ratio as Value, inst_id as EntityId
  from @instruments_data
  ) a
  on li.ClientInternal = a.EntityId
where li.ClientInternal in @ids
union
select li.LusidInstrumentId as EntityId, 'LusidInstrumentId' as EntityIdType, 'Instrument' as Domain, a.PropertyScope as PropertyScope, a.PropertyCode, a.
  Value, @@Scope as EntityScope
from Lusid.Instrument li
inner join (
  select 'Sector' as PropertyCode, 'ibor' as PropertyScope, Sector as Value, inst_id as EntityId
  from @instruments_data
  ) a
  on li.ClientInternal = a.EntityId
where li.ClientInternal in @ids;


-- select * from @inst_properties

select *
from Lusid.Property.Writer
where ToWrite = @inst_properties;

-- 2. Upload instrument data to inbuilt properties
-- Transform equity data
@equity_instruments =
select inst_id as ClientInternal, name as DisplayName, ccy as DomCcy, @@Scope as Scope 
from @instruments_data;

-- Write data to Lusid.Instrument.Equity. Print results of writing data to console.
select *
from Lusid.Instrument.Equity.Writer
where ToWrite = @equity_instruments;
   
   
