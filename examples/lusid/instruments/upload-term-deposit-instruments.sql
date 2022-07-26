-- ============================================================

-- Description:
-- 1. In this query, we run an ETL process on some instruments.
-- 2. First, we load a CSV file of instruments from Drive.
-- 3. Next, we transform the shape of the instrument data.
-- 4. Finally we upload the instrument data into LUSID.

-- ============================================================

@term_deposit_file = use Drive.Excel
--file=/luminesce-examples/instruments.xlsx
--worksheet=term_deposits
enduse;

@term_deposit_instruments = select
ClientInternal,
Name,
StartDate,
MaturityDate,
Rate,
FlowConventionPaymentFrequency,
FlowConventionDayCountConvention,
FlowConventionRollConvention,
FlowConventionPaymentCalendars,
FlowConventionResetCalendars,
FlowConventionCurrency
from @term_deposit_file;

-- Upload the transformed data into LUSID
select *
from Lusid.Instrument.TermDeposit.Writer
where ToWrite = @term_deposit_instruments;
