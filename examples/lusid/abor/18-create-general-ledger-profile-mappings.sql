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
    'GeneralLedgerAccountCode not in ''A0101-Unknown-NA'', ''A0102-Unknown-PL'', ''A0103-Unknown-CA''',
    'DefaultCurrency',
    Null,
    '',
    2
);

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
