/*

--------------------------
Create GL profile mappings
--------------------------

In this snippet we create a GL Profile mappings.

For more details on LUSID providers, see this page:

https://support.lusid.com/knowledgebase/category/?id=CAT-01099

*/


@@scope = select 'luminesce-examples';
@@chartOfAccountsCode = select 'standardChartOfAccounts';
@@generalLedgerProfileCode = select 'standardGeneralLedgerProfile';

@glProfile = select
@@scope as ChartOfAccountsScope,
@@chartOfAccountsCode as ChartOfAccountsCode,
@@chartOfAccountsCode as DisplayName,
@@generalLedgerProfileCode as GeneralLedgerProfileCode,
'Insert' as WriteAction
;

select * from Lusid.GeneralLedgerProfile.Writer
where ToWrite = @glProfile;