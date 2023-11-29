/*

-----------------------
Run Trial Balance Check
-----------------------

In this snippet we run a Trial Balance check.

For more details on LUSID providers, see this page:

https://support.lusid.com/knowledgebase/category/?id=CAT-01099

*/


@tb = select sum(Debit) as SumDebits, sum(Credit) as SumCredits from Lusid.Abor.TrialBalance
where GeneralLedgerProfileCode = 'standardGeneralLedgerProfile'
and StartDate = '2023-01-02'
and EndDate = '2023-03-03'
and AborScope = 'luminesce-examples';

select SumDebits, SumCredits, round((SumDebits + SumCredits), 2) as [Check] from @tb;