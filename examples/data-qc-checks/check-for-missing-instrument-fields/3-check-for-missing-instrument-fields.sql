-- ===============================================================
-- Description:
-- In this file, we run a QC check to check for missing fields
-- ===============================================================

-- 1. Get values for custom properties and transform data.

@custom_props =
select InstrumentId, PropertyCode, Value
from Lusid.Instrument.Property p
where propertyscope = 'ibor'
   and propertycode in ('RegFlag', 'Sector', 'SharesOutstanding', 'InternalRating', 'SourceFile');

@pivoted =
use Tools.Pivot with @custom_props
--key=PropertyCode
--aggregateColumns=Value
enduse;

-- 2. Create view for instruments from source file with custom and default properties.

@pivoted2 = select * from @pivoted
where SourceFile = 'equity_instruments_20220819';

@data_qc =
select *
from @pivoted2 p
inner join (
   select DisplayName, Isin, ClientInternal, LusidInstrumentId, Sedol, DomCcy
   from Lusid.Instrument.Equity
   where LusidInstrumentId in (select InstrumentId from @pivoted2)
   ) q
   on q.LusidInstrumentId = p.InstrumentId;

-- 3. Run quality control check on data and populate `QualityControlStatus`

@qc_check =
select *, case
      when Sector is null
         then 'Failed'
      when RegFlag is null
         then 'Failed'
      when InternalRating is null
         then 'Failed'
      when SharesOutstanding is null
         then 'Failed'
      else 'Passed'
      end as 'QualityControlStatus'
from @data_qc;

-- 4. Filter for PASSED instruments and populate `MissingFields`

@qc_passed =
select *, 'Missing fields: None' as 'MissingFields'
from @qc_check
where QualityControlStatus = 'Passed';

-- 5. Filter for FAILED instruments and populate `MissingFields`

@qc_failed =
select *, 'Missing fields: ' || case
      when InternalRating is null
         then 'InternalRating, '
      else ''
      end || case
      when RegFlag is null
         then 'RegFlag, '
      else ''
      end || case
      when SharesOutstanding is null
         then 'SharesOutstanding, '
      else ''
      end || case
      when Sector is null
         then 'Sector, '
      else ''
      end as 'MissingFields'
from @qc_check
where QualityControlStatus = 'Failed';

-- 6. Create a view of all PASSED and FAILED instruments from source file, with `MissingFields` and `QualityControlStatus` properties.

@pass_and_fail =
select InstrumentId, MissingFields, QualityControlStatus
from @qc_failed
union all
select InstrumentId, MissingFields, QualityControlStatus
from @qc_passed;

@qc_props =
use Tools.Unpivot with @pass_and_fail
--key=InstrumentId
--keyIsNotUnique
enduse;

@props_towrite =
select InstrumentId as EntityId, 'LusidInstrumentId' as EntityIdType, 'Instrument' as Domain, 'ibor' as PropertyScope, ValueColumnName as PropertyCode, ValueText as Value
from @qc_props;

-- 7. Upload `QualityControlStatus` and `MissingFields` property for each instrument to Lusid.Property provider.
-- Print results of writing data to console;

select *
from Lusid.Property.Writer
where ToWrite = @props_towrite;
