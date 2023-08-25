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
        and Properties[Instrument/luminesce-examples/Country] eq ''United Kingdom''',
    'A0001-Investments-UK'
),
(
    'Rule-002', 
    'EconomicBucket startswith ''NA'' 
        and HoldType eq ''P'' 
        and Properties[Instrument/luminesce-examples/Country] eq ''United States''',
    'A0002-Investments-USA'
),
(
    'Rule-003', 
    'EconomicBucket startswith ''NA'' 
        and HoldType eq ''P'' 
        and Properties[Instrument/luminesce-examples/Country] exists',
    'A0003-Investments-General'
),
(
    'Rule-004',
    'EconomicBucket startswith ''NA'' and HoldType eq ''B''',
    'A0004-Cash'
),
(
    'Rule-005',
    'EconomicBucket startswith ''NA'' and HoldType eq ''C''',
    'A0005-Commitments'),
(
    'Rule-006',
    'EconomicBucket eq ''CA_Capital''', 
    'A0006-Capital'
),
(
    'Rule-007', 
    'EconomicBucket startswith ''PL_Real''', 
    'A0007-RealisedGains'
),
(
    'Rule-008', 
    'EconomicBucket startswith ''PL_Unreal''',
    'A0008-UnrealisedGains'
),
(
    'Rule-009', 
    'EconomicBucket startswith ''PL_Accrued''',
    'A0009-Accruals'
),
(
    'Rule-010', 
    'EconomicBucket startswith ''NA''',
    'A0010-Unknown-NA'
),
(
    'Rule-011', 
    'EconomicBucket startswith ''CA''',
    'A0011-Unknown-CA'
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
