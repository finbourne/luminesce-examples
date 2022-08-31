-- ============================================================
-- Description:
-- 1. In this query, we create a view to run the reconciliation
-- ============================================================


@recon_view =

use Sys.Admin.SetupView
--provider=Test.Example.HoldingsRecon

--parameters
file_name,Text,equity_holdings_20220301.xlsx,true
portfolio,Text,UkEquityTracker,true
scope,Text,LuminesceReconExample,true
recon_date,Date,2022-03-01,true
----

@@file_name = select =PARAMETERVALUE(file_name);
@@portfolio = select =PARAMETERVALUE(portfolio);
@@scope = select =PARAMETERVALUE(scope);
@@recon_date = select =PARAMETERVALUE(recon_date);


@ext_holdings_from_excel =

use Drive.Excel with @@file_name
--file=/luminesce-examples/{@@file_name}
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
where h.PortfolioScope = @@scope
and h.PortfolioCode = @@portfolio
and h.EffectiveAt = @@recon_date
order by h.HoldingType desc;

-- Run a reconciliation

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
join @ext_holdings_from_excel r on (l.ClientInternal = 'EQ' || r.InstrumentId
and r.portfolio = @@portfolio);

enduse;


-- wait for view/provider to be created on the grid

select * from @recon_view wait 20;
