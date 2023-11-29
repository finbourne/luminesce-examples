/*

--------------------
Create Trial Balance
--------------------

In this snippet we create Trial Balance mappings.

For more details on LUSID providers, see this page:

https://support.lusid.com/knowledgebase/category/?id=CAT-01099

*/


select 
GeneralLedgerProfileAccountCode,
Level1,
Level2,
AccountType,
Opening,
Closing,
Debit,
Credit
from Lusid.Abor.TrialBalance
where StartDate = '2023-01-02'
and EndDate = '2023-03-03'
and AborScope = 'luminesce-examples'
and GeneralLedgerProfileCode = 'standardGeneralLedgerProfile'
order by GeneralLedgerProfileAccountCode