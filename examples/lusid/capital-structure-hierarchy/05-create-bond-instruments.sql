
/*
-----------------------
Create Bond instruments
-----------------------

In this snippet we create Bond instruments.

*/

@@scope = select 'luminesce-examples';

-- Step 1: Define the bond instruments


@bondsDataForUpload = 
select
'GLN BOND 5.3% 01/10/2042' as DisplayName,
'GLNBND001' as ClientInternal,
#2022-10-01# as StartDate,
#2042-10-01# as MaturityDate,
0.053 as CouponRate,
'GBP' as DomCcy,
'GBP' as FlowConventionsCurrency,
'1Y' as FlowConventionsPaymentFrequency,
'ActAct' as FlowConventionsDayCountConvention,
'MF' as FlowConventionsRollConvention,
'GBP' as FlowConventionsPaymentCalendars,
'GBP' as FlowConventionsResetCalendars,
0 as FlowConventionsSettleDays,
0 as FlowConventionsResetDays,
1 as Principal,
@@scope as Scope
UNION ALL
Values
(
'GLN BOND 6.8% 01/10/2042','GLNBND002',#2022-10-01#,#2042-10-01#,
    0.068,'GBP','GBP','1Y','ActAct','MF','GBP','GBP',0,0,1,@@scope
)
;

-- Step 2: Upload the transformed data into LUSID

select *
from Lusid.Instrument.Bond.Writer
where ToWrite = @bondsDataForUpload;