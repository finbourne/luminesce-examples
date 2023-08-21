/*

-----------------------
Create Bond instruments
-----------------------

In this snippet we create Bond instruments.

For more details on LUSID providers, see this page:

https://support.lusid.com/knowledgebase/category/?id=CAT-01099

*/

@@scope = select 'luminesce-examples';

-- Step 1: Define the bond instruments

@bondsData= 
values
('US BOND 4% 01/01/2033', 'FBNBND001',  #2023-01-01#,  0.04, 'USD', '1Y', 'ActAct', #2033-01-01#),
('US BOND 7% 01/01/2028', 'FBNBND002',  #2023-01-01#,  0.07, 'USD', '1Y', 'ActAct', #2028-01-01#),
('UK BOND 3% 01/01/2033', 'FBNBND003',  #2023-01-01#,  0.03, 'GBP', '1Y', 'ActAct', #2033-01-01#),
('UK BOND 8% 01/01/2028', 'FBNBND004',  #2023-01-01#,  0.08, 'GBP', '1Y', 'ActAct', #2028-01-01#);


@bondsDataForUpload = 
select
Column1 as DisplayName,
column2 as ClientInternal,
column3 as StartDate,
column4 as CouponRate,
column5 as DomCcy,
column5 as FlowConventionsCurrency,
column6 as FlowConventionsPaymentFrequency,
column7 as FlowConventionsDayCountConvention,
'MF' as FlowConventionsRollConvention,
column5 as FlowConventionsPaymentCalendars,
column5 as FlowConventionsResetCalendars,
0 as FlowConventionsSettleDays,
0 as FlowConventionsResetDays,
1 as Principal,
column8 as MaturityDate,
@@scope as Scope
from @bondsData;

-- Step 2: Upload the transformed data into LUSID

select *
from Lusid.Instrument.Bond.Writer
where ToWrite = @bondsDataForUpload;