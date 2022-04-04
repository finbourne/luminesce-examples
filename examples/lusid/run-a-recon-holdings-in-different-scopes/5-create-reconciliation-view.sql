-- #################### SUMMARY ##############################

-- 1. In this query, we create a view to run the reconciliation

-- ###########################################################


@recon_view =

use Sys.Admin.SetupView
--provider=Recon.IborVersusAbor

--parameters
aborScope,Text,abor-recon-test,true
iborScope,Text,ibor-recon-test,true
reconDate,Date,2022-03-01,true
----

@@aborScope = select #PARAMETERVALUE(aborScope);
@@iborScope = select #PARAMETERVALUE(iborScope);
@@reconDate = select #PARAMETERVALUE(reconDate);

-- Get ABOR holdings

@abor_data = select
h.PortfolioCode,
i.DisplayName as [InstrumentName],
i.LusidInstrumentId,
i.ClientInternal,
i.Isin,
h.HoldingType,
h.Units
from Lusid.Portfolio.Holding h
join Lusid.Instrument i on (i.LusidInstrumentId = h.LusidInstrumentId)
where h.PortfolioScope = @@aborScope
and h.EffectiveAt = @@reconDate
order by h.HoldingType desc;

-- Get IBOR holdings

@ibor_data = select
h.PortfolioCode,
i.DisplayName as [InstrumentName],
i.LusidInstrumentId,
i.ClientInternal,
i.Isin,
h.HoldingType,
h.Units
from Lusid.Portfolio.Holding h
join Lusid.Instrument i on (i.LusidInstrumentId = h.LusidInstrumentId)
where h.PortfolioScope = @@iborScope
and h.EffectiveAt = @@reconDate
order by h.HoldingType desc;

select
a.PortfolioCode as [Abor_PortfolioCode],
a.InstrumentName as [Abor_InstrumentName],
a.Isin as [Abor_Isin],
a.HoldingType as [Abor_HoldingType],
a.Units as [Abor_Units],
i.Units as [Ibor_Units],
(a.Units - i.Units) as [Units_Diff],
round(((a.Units *1.0) / i.Units) -1 ,5) as [Units_Diff_Pct],
case when (abs(a.Units - i.Units) > 0 or i.Units is null or a.Units is null) then 'Break' else 'NoBreak' end as [ReconStatus]
from @abor_data a
left join @ibor_data i on (a.ClientInternal = i.ClientInternal and i.PortfolioCode = a.PortfolioCode)
union
select
a.PortfolioCode as [Abor_PortfolioCode],
a.InstrumentName as [Abor_InstrumentName],
a.Isin as [Abor_Isin],
a.HoldingType as [Abor_HoldingType],
a.Units as [Abor_Units],
i.Units as [Ibor_Units],
(a.Units - i.Units) as [Units_Diff],
round(((a.Units *1.0) / i.Units) -1 ,5) as [Units_Diff_Pct],
case when (abs(a.Units - i.Units) > 0 or i.Units is null or a.Units is null) then 'Break' else 'NoBreak' end as [ReconStatus]
from @ibor_data i
left join @abor_data a on (a.ClientInternal = i.ClientInternal and i.PortfolioCode = a.PortfolioCode)
;

enduse;

select * from @recon_view wait 10;