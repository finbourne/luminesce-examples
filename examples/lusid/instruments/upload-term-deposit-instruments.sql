-- ============================================================

-- Description:
-- 1. In this query, we run an ETL process on some instruments.
-- 2. First, we load a CSV file of instruments from Drive.
-- 3. Next, we transform the shape of the instrument data.
-- 4. Finally we upload the instrument data into LUSID.

-- ============================================================

-- Extract Term Deposit data from LUSID Drive

@term_deposit_file = use Drive.Excel
--file=/luminesce-examples/instruments.xlsx
--worksheet=term_deposits
enduse;

-- Transform data using SQL

@term_deposit_instruments = select
id as ClientInternal,
name as Name,
start_date as StartDate,
mat_date as MaturityDate,
rate as Rate,
payment_freq as FlowConventionPaymentFrequency,
day_count_convention as FlowConventionDayCountConvention,
flow_convention as FlowConventionRollConvention,
payment_cals as FlowConventionPaymentCalendars,
reset_cals as FlowConventionResetCalendars,
currency as FlowConventionCurrency
from @term_deposit_file;

-- Upload the transformed data into LUSID

select *
from Lusid.Instrument.TermDeposit.Writer
where ToWrite = @term_deposit_instruments;
