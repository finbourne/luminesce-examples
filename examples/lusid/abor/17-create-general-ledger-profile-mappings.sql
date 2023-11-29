/*

-----------------
Create GL profile
-----------------

In this snippet we create a GL Profile.

For more details on LUSID providers, see this page:

https://support.lusid.com/knowledgebase/category/?id=CAT-01099

*/


@@scope = select 'luminesce-examples';
@@chartOfAccountsCode = select 'standardChartOfAccounts';
@@generalLedgerProfileCode = select 'standardGeneralLedgerProfile';


@mappings = values
(
    'GeneralLedgerAccountCode eq ''A0001-Investments''', 
    'DefaultCurrency',
    'Properties[Instrument/luminesce-examples/AssetClass]',
    '',
    1
),
(
    'GeneralLedgerAccountCode eq ''A0002-Settled-Cash''', 
    'DefaultCurrency',
    Null,
    '',
    2
),
(
    'GeneralLedgerAccountCode eq ''A0003-Sales-To-Settle''', 
    'DefaultCurrency',
    Null,
    '',
    3
),
(
    'GeneralLedgerAccountCode eq ''A0004-Purchases-To-Settle''', 
    'DefaultCurrency',
    Null,
    '',
    4
),
(
    'GeneralLedgerAccountCode eq ''A0010-UnrealisedGains''', 
    'DefaultCurrency',
    Null,
    '',
    5
)
;

@mappingsToWrite = select  
@@chartOfAccountsCode as ChartOfAccountsCode,
@@scope as ChartOfAccountsScope,
@@generalLedgerProfileCode as GeneralLedgerProfileCode,
column1 as MappingFilter,
column2 as Level1,
column3 as Level2,
column5 as MappingPriority
from @mappings;

select * from Lusid.GeneralLedgerProfile.Mapping.Writer
where ToWrite = @mappingsToWrite;