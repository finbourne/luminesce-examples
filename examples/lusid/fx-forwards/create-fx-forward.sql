-- ===============================================================
-- Description:
-- 1. In this query, we run an ETL process on an Fx Forward.
-- 2. First, we load a CSV file of the forward from LUSID drive.
-- 3. Next, we transform the shape of the forward data.
-- 4. Finally we upload the forward data into LUSID.
-- ===============================================================

-- Defining scope variable

@@instrumentScope = select 'luminesce-examples';

-- Load forward into table

@fx_data = 
use Drive.Csv
--file=/luminesce-examples/fx_forward.csv
enduse;

-- Define informtion to upsert from file

@fx_forward_instrument =
select  SecurityDescription as DisplayName,
        Figi as Figi,
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
where ToWrite=@fx_forward_instrument;