-- ===============================================================
-- Description:
-- In this file, we run a reconciliation on three of the properties
-- ===============================================================

-- 1. Create a view of instruments with custom properties
-- Get data from LUSID
@instr_props =
select li.ClientInternal, li.DisplayName, PropertyCode, Value
from Lusid.Instrument.Property p
inner join Lusid.Instrument.SimpleInstrument li
   on li.LusidInstrumentId = p.InstrumentId
where li.SimpleInstrumentType = 'Bonds'
   and li.AssetClass = 'Credit'
    and ((p.propertyscope  = 'SourceA'
    and p.propertycode in ('HoldingType', 'CountryIssue', 'GICSLevel1', 'InstrumentType'))
    or 
    (p.propertyscope  = 'SourceB'
    and p.propertycode in ('holding_type', 'country_issue', 'gics_level_1', 'instrument_type'))) ;


-- Transform data using luminesce
@pivoted =
use Tools.Pivot with @instr_props
--key=PropertyCode
--aggregateColumns=Value
enduse;

-- 2. Run reconcilliation
select ClientInternal, DisplayName, case
      when HoldingType = holding_type
         then 'Reconciled: ' || HoldingType
      else 'Break: ' || HoldingType || ' versus ' || holding_type
      end as HoldingType, case
      when CountryIssue = country_issue
         then 'Reconciled: ' || CountryIssue
      else 'Break: ' || CountryIssue || ' versus ' || country_issue
      end as CountryIssue, case
      when GICSLevel1 = gics_level_1
         then 'Reconciled: ' || GICSLevel1
      else 'Break: ' || GICSLevel1 || ' versus ' || gics_level_1
      end as GICSLevel1
from @pivoted
where (
      HoldingType is not null
      and InstrumentType is not null
      );
