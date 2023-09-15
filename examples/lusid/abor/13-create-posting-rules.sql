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
@@code = select 'standardPostingModule';

@rules_filters = values
(
    'Rule-001', 
    'EconomicBucket startswith ''NA'' 
        and HoldType eq ''P'' 
        and Properties[Instrument/luminesce-examples/AssetClass] eq ''Government Bond''',
    'A0001-Investments-GovernmentBonds'
),
(
    'Rule-002', 
    'EconomicBucket startswith ''NA'' 
        and HoldType eq ''P'' 
        and Properties[Instrument/luminesce-examples/AssetClass] eq ''Common Stock''',
    'A0002-Investments-Equity'
),
(
    'Rule-003', 
    'EconomicBucket startswith ''NA'' 
        and HoldType eq ''P'' 
        and Properties[Instrument/luminesce-examples/AssetClass] exists
        and DefaultCurrency eq ''ABC''',
    'A0003-Investments-General'
),
(
    'Rule-004',
    'EconomicBucket startswith ''NA'' and HoldType eq ''B'' and DefaultCurrency eq ''GBP''',
    'A0004_GBP-Settled-Cash'
),
(
    'Rule-005',
    'EconomicBucket startswith ''NA'' and HoldType eq ''B'' and DefaultCurrency eq ''USD''',
    'A0005_USD-Settled-Cash'
),
(
    'Rule-006', 
    'EconomicBucket startswith ''NA_'' 
        and MovementName eq ''CashProceeds'' 
        and HoldType neq ''B''
        and DefaultCurrency eq ''GBP''',
    'A0006_GBP-Sales-To-Settle'
),
(
    'Rule-007', 
    'EconomicBucket startswith ''NA_'' 
        and MovementName eq ''CashProceeds'' 
        and HoldType neq ''B''
        and DefaultCurrency eq ''USD''',
    'A0007_USD-Sales-To-Settle'
),
(
    'Rule-008', 
    'EconomicBucket startswith ''NA_'' 
        and MovementName eq ''CashInvested'' 
        and HoldType neq ''B''
        and DefaultCurrency eq ''GBP''',
    'A0008_GBP-purchases-for-settlement'
),
(
    'Rule-009', 
    'EconomicBucket startswith ''NA_'' 
        and MovementName eq ''CashInvested'' 
        and HoldType neq ''B''
        and DefaultCurrency eq ''USD''',
    'A0009_USD-purchases-for-settlement'
),
(
    'Rule-010', 
    'EconomicBucket startswith ''NA_'' 
        and MovementName eq ''FxSpotBuyLeg'' 
        and HoldType neq ''B''
        and DefaultCurrency eq ''GBP''',
    'A0010_GBP-Long-FX-To-Settle'
),
(
    'Rule-011', 
    'EconomicBucket startswith ''NA_'' 
        and MovementName eq ''FxSpotBuyLeg'' 
        and HoldType neq ''B''
        and DefaultCurrency eq ''USD''',
    'A0011_USD-Long-FX-To-Settle'
),
(
    'Rule-012', 
    'EconomicBucket startswith ''NA_'' 
        and MovementName eq ''FxSpotSellLeg'' 
        and HoldType neq ''B''
        and DefaultCurrency eq ''GBP''',
    'A0012_GBP-Short-FX-To-Settle'
),
(
    'Rule-013', 
    'EconomicBucket startswith ''NA_'' 
        and MovementName eq ''FxSpotSellLeg'' 
        and HoldType neq ''B''
        and DefaultCurrency eq ''USD''',
    'A0013_USD-Short-FX-To-Settle'
),
(
    'Rule-014',
    'EconomicBucket eq ''CA_Capital'' and DefaultCurrency eq ''GBP''', 
    'A0014_GBP-Capital'
),
(
    'Rule-015',
    'EconomicBucket eq ''CA_Capital'' and DefaultCurrency eq ''USD''', 
    'A0015_USD-Capital'
),
(
    'Rule-016', 
    'EconomicBucket eq ''PL_RealPriceGL'' and HoldType eq ''P''', 
    'A0016-Realised-Market-Gains'
),
(
    'Rule-017', 
    'EconomicBucket eq ''PL_RealFXGL'' and HoldType in ''P'', ''B''', 
    'A0017-Realised-Fx-Gains'
),
(
    'Rule-018', 
    'EconomicBucket startswith ''PL_Unreal''',
    'A0018-UnrealisedGains'
),
(
    'Rule-019', 
    'EconomicBucket startswith ''PL_Accrued''',
    'A0019-Accruals'
),
(
    'Rule-020', 
    'MovementName eq ''Subscription'' and HoldType neq ''B''',
    'A0020-Subscriptions'
),
(
    'Rule-021', 
    'MovementName eq ''Redemption'' and HoldType neq ''B''',
    'A0021-Redemptions'
),
(
    'Rule-101', 
    'EconomicBucket startswith ''NA''',
    'A0101-Unknown-NA'
),
(
    'Rule-102', 
    'EconomicBucket startswith ''PL''',
    'A0102-Unknown-PL'
),
(
    'Rule-103', 
    'EconomicBucket startswith ''CA''',
    'A0103-Unknown-CA'
)
;


-- Step 2: Add posting rules to posting module

@postingRules = select 
@@scope as PostingModuleScope,
@@code as PostingModuleCode,
column1 as RuleId,
column2 as RuleFilter,
column3 as AccountCode
from @rules_filters;

select * from Lusid.PostingModule.Rule.Writer where ToWrite = @postingRules;