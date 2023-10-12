/*

-----------------------
Create Asset Backed Loan
-----------------------

In this snippet we create an asset backed loan.

*/

@@scope = select 'luminesce-examples';

@termDeposit = select 
'Glencore AB Valeria QLD 15/07/29 3.8%' as DisplayName, 
'GLEN-VALERIA-COAL-AUS-1' as ClientInternal, 
@@scope as Scope,
#2023-07-15# as StartDate, 
#2029-07-15# as MaturityDate, 
1 as ContractSize,
0.038 as Rate,
'AUD' as FlowConventionCurrency, 
'6M' as FlowConventionPaymentFrequency, 
'Actual360' as FlowConventionDayCountConvention,
'P' as FlowConventionRollConvention, 
'GBP,AUD' as FlowConventionPaymentCalendars, 
'' as FlowConventionResetCalendars
;

/*

=============================
        3. Load
=============================

*/

select * 
from Lusid.Instrument.TermDeposit.Writer 
where toWrite = @termDeposit;
