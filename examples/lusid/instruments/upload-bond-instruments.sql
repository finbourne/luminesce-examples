-- ============================================================

-- Description:
-- 1. In this query, we run an ETL process on some instruments.
-- 2. First, we load a XML file of bond instruments from Drive.
-- 3. Next, we transform the shape of the instrument data.
-- 4. Finally we upload the instrument data into LUSID.

-- ============================================================

-- Extract Bond instrument data from LUSID Drive
@instruments_data =
use Drive.Xml
--file=/luminesce-examples/instruments.xml
--nodePath=instruments/bond
--columns
BondID=bondId
Name=name
ISIN=isin
IssueDate=issueDate
Maturity=maturity
Currency=crncy
CouponRate=couponRate
Principal=principal
CouponFreq=cpnFreq
DayCountConvention=dayCountConvention
RollConvention=rollConvention
PaymentCalendars=paymentCalendars
ResetCalendars=resetCalendars
SettleDays=settleDays
ResetDays=resetDays
enduse;

-- Transform data using SQL
@instruments = 
select
Name as DisplayName,
ISIN as Isin,
Name || ' ' || ISIN as ClientInternal,
IssueDate as StartDate,
CouponRate as CouponRate,
Currency as DomCcy,
Currency as FlowConventionsCurrency,
CouponFreq as FlowConventionsPaymentFrequency,
DayCountConvention as FlowConventionsDayCountConvention,
RollConvention as FlowConventionsRollConvention,
'' as FlowConventionsPaymentCalendars,
'' as FlowConventionsResetCalendars,
SettleDays as FlowConventionsSettleDays,
ResetDays as FlowConventionsResetDays,
Principal as Principal,
Maturity as MaturityDate
from @instruments_data;

-- Upload the transformed data into LUSID
select *
from Lusid.Instrument.Bond.Writer
where ToWrite = @instruments;
