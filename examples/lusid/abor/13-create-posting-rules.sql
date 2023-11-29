/*

--------------------
Create posting rules
--------------------

In this snippet we create some posting rules.

For more details on LUSID providers, see this page:

https://support.lusid.com/knowledgebase/category/?id=CAT-01099

Prerequisite setup steps:

    1. Setup a Posting Module wuth the scope/code referenced below


*/

-- Step 1: Define posting rules

@@scope = select 'luminesce-examples';
@@coaCode = select 'standardChartOfAccounts';
@@postingModuleCode = select 'standardPostingModule';

@rules_filters = values
(
    'Rule-001', 
    'EconomicBucket startswith ''NA'' 
        and HoldType eq ''P''',
    'A0001-Investments',
    1
),
(
    'Rule-002',
    'EconomicBucket startswith ''NA'' and HoldType eq ''B''',
    'A0002-Settled-Cash',
    2
),
(
    'Rule-003', 
    'EconomicBucket startswith ''NA_'' 
        and MovementName eq ''CashProceeds'' 
        and HoldType neq ''B''',
    'A0003-Sales-To-Settle',
    3
),
(
    'Rule-004', 
    'EconomicBucket startswith ''NA_'' 
        and MovementName eq ''CashInvested'' 
        and HoldType neq ''B''',
    'A0004-Purchases-To-Settle',
    4
),
(
    'Rule-005', 
    'EconomicBucket startswith ''NA_'' 
        and MovementName eq ''FxSpotBuyLeg'' 
        and HoldType neq ''B''',
    'A0005-Long-FX-To-Settle',
    5
),
(
    'Rule-006', 
    'EconomicBucket startswith ''NA_'' 
        and MovementName eq ''FxSpotSellLeg'' 
        and HoldType neq ''B''',
    'A0006-Short-FX-To-Settle',
    6
),
(
    'Rule-007',
    'EconomicBucket eq ''CA_Capital''', 
    'A0007-Capital',
    7
),
(
    'Rule-008', 
    'EconomicBucket eq ''PL_RealPriceGL'' and HoldType eq ''P''', 
    'A0008-Realised-Market-Gains',
    8
),
(
    'Rule-009', 
    'EconomicBucket eq ''PL_RealFXGL'' and HoldType in ''P'', ''B''', 
    'A0009-Realised-Fx-Gains',
    9
),
(
    'Rule-010', 
    'EconomicBucket startswith ''PL_Unreal''',
    'A0010-UnrealisedGains',
    10
),
(
    'Rule-011', 
    'EconomicBucket startswith ''PL_Accrued''',
    'A0011-Accruals',
    11
),
(
    'Rule-012', 
    'MovementName eq ''Subscription'' and HoldType neq ''B''',
    'A0012-Subscriptions',
    12
),
(
    'Rule-013', 
    'MovementName eq ''Redemption'' and HoldType neq ''B''',
    'A0013-Redemptions',
    13
),
(
    'Rule-101', 
    'EconomicBucket startswith ''NA''',
    'A0101-Unknown-NA',
    14
),
(
    'Rule-102', 
    'EconomicBucket startswith ''PL''',
    'A0102-Unknown-PL',
    15
),
(
    'Rule-103', 
    'EconomicBucket startswith ''CA''',
    'A0103-Unknown-CA',
    16
)
;


-- Step 2: Add posting rules to posting module

@postingRules = select 
@@scope as ChartOfAccountsScope,
@@coaCode as ChartOfAccountsCode,
@@postingModuleCode as PostingModuleCode,
column1 as RuleId,
column2 as RuleFilter,
column3 as AccountCode,
column4 as RulePriority
from @rules_filters;

select * from Lusid.PostingModule.Rule.Writer where ToWrite = @postingRules;
