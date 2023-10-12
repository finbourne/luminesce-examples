/*

-----------------------
Create Term Deposit
-----------------------

In this snippet we create a Term Deposit.


*/

@@scope = select 'luminesce-examples';

@termDeposit = select 
'Glencore TD 08/05/33 4.6%'as DisplayName, 
'GLN-TD-001' as ClientInternal, 
@@scope as Scope,
#2023-11-08# as StartDate, 
#2033-05-08# as MaturityDate, 
2000 as ContractSize,
0.046 as Rate,
'USD' as FlowConventionCurrency, 
'6M' as FlowConventionPaymentFrequency, 
'Actual360' as FlowConventionDayCountConvention,
'P' as FlowConventionRollConvention, 
'GBP,USD' as FlowConventionPaymentCalendars, 
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



