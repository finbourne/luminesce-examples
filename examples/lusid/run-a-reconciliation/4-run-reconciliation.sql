-- #################### SUMMARY ##############################

-- 1. In this query, we reconcile ext holdings from an Excel
--      against holding in LUSID

-- ###########################################################

@@file_date =

select strftime('20220301');

@@portfolioScope =

select 'LuminesceReconExample';

-- Get external holdings

@ext_holdings_from_excel =

use Drive.Excel with @@file_date
--file=/luminesce-recon-testing-folder/equity_holdings_{@@file_date}.xlsx
--worksheet=ext_holdings
--addFileName
enduse;

-- Get LUSID holdings

@holdings_from_lusid = select
h.PortfolioCode,
i.DisplayName as [InstrumentName],
i.LusidInstrumentId,
i.ClientInternal,
i.Isin,
h.HoldingType,
h.Units
from Lusid.Portfolio.Holding h
join Lusid.Instrument i on (i.LusidInstrumentId = h.LusidInstrumentId)
where h.PortfolioScope = @@portfolioScope
and h.PortfolioCode = 'UkEquityTracker'
and h.EffectiveAt = #2022-03-01#
order by h.HoldingType desc;

-- -- Run a reconciliation

select
l.PortfolioCode as [Left_PortfolioCode],
l.InstrumentName as [Left_InstrumentName],
l.Isin as [Left_Isin],
l.HoldingType as [Left_HoldingType],
l.Units as [Left_Units],
r.Units as [Right_Units],
(r.Units - l.Units) as [Units_Diff],
round(((r.Units *1.0) / l.Units) -1 ,5) as [Units_Diff_Pct]
from @holdings_from_lusid l
join @ext_holdings_from_excel r on (l.ClientInternal = 'EQ' || r.InstrumentId);