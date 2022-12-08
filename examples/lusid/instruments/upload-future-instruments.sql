-- ============================================================
-- Description:
-- 1. In this query, we run an ETL process on some instruments.
-- 2. First, we load a CSV file of futures instruments from Drive.
-- 3. Next, we transform the shape of the instrument data.
-- 4. Finally we upload the instrument data into LUSID.
-- ============================================================

-- Extract Future instrument data from LUSID Drive

@instruments_data =
use Drive.Csv
--file=/luminesce-examples/futures.csv
enduse;

-- Transform data using SQL
@instruments = 
select
-- Contract details
contract_code as ContractDetailsContractCode,
contract_month as ContractDetailsContractMonth,
contract_size as ContractDetailsContractSize,
convention as ContractDetailsConvention,
country_id as ContractDetailsCountry,
fut_name as ContractDetailsDescription,
dom_ccy as ContractDetailsDomCcy,
exchange_code as ContractDetailsExchangeCode,
exchange_name as ContractDetailsExchangeName,
ticker_step as ContractDetailsTickerStep,
unit_value as ContractDetailsUnitValue,
-- Future details
start_date as StartDate,
maturity_date as MaturityDate,
1 as Contracts,
id as ClientInternal,
fut_name as DisplayName
from @instruments_data;

-- Create future instrument
select *
from Lusid.Instrument.Future.Writer
where ToWrite = @instruments;
