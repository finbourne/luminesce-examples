-- ===============================================================
-- Description:
-- In this query, we add an Fx Forward holding in to LUSID.
-- ===============================================================

-- Defining scope variable
@@instrumentScope = select 'luminesce-examples';

-- Load forward into table
@fx_data = 
use Drive.Csv
--file=/luminesce-examples/fx_forward.csv
enduse;

-- Define informtion to upsert from file
@forward_to_upload =
select  SecurityDescription as DisplayName,
        SecurityDescription as Figi,
        TradeDate as StartDate,
        SettlementDate as MaturityDate,
        Ccy as DomCcy,
        Ccy2 as FgnCcy,
        CcyAmount as DomAmount,
        -1 * Ccy2Amount as FgnAmount,
        @@instrumentScope as Scope
from @fx_data;

-- Upsert Fx Forward to LUSID
select * from lusid.Instrument.FxForward.Writer
where ToWrite=@forward_to_upload;