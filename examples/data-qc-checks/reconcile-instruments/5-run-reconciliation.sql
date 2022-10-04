-- ===============================================================
-- Description:
-- In this file, we run a reconciliation on three of the properties
-- ===============================================================

select
ClientInternal,
DisplayName,
case when HoldingType = holding_type
    then 'Reconciled: ' ||  HoldingType
    else 'Break: ' || HoldingType || ' versus '  || holding_type
    end as HoldingType,

case when CountryIssue = country_issue
    then 'Reconciled: ' ||  CountryIssue
    else 'Break: ' || CountryIssue || ' versus '  || country_issue
    end as CountryIssue,

case when GICSLevel1 = gics_level_1
    then 'Reconciled: ' ||  GICSLevel1
    else 'Break: ' || GICSLevel1 || ' versus '  || gics_level_1
    end as GICSLevel1
from Lusid.Instrument.SimpleInstrument
where (HoldingType is not null
and InstrumentType is not null);