-- #################### SUMMARY ##############################

-- 1. In this query, we load holdings into LUSID for the
-- two portfolios.

-- ###########################################################

@@file_date =

select strftime('20220301');

@@portfolioScope =

select 'LuminesceReconExample';

@holdings_from_excel =

use Drive.Excel with @@file_date
--file=/luminesce-examples/equity_holdings_{@@file_date}.xlsx
--worksheet=lusid_holdings
--addFileName
enduse;

-- Run holdings transformation
@holdings_for_upload =

select portfolio as [PortfolioCode], @@portfolioScope as [PortfolioScope], holding_date as
   [EffectiveAt], 'EQ' || InstrumentId as [ClientInternal], units as [Units], Currency as
   CostCurrency
from @holdings_from_excel;

-- Upload the transformed data into LUSID
select *
from Lusid.Portfolio.Holding.Writer
where ToWrite = @holdings_for_upload;
