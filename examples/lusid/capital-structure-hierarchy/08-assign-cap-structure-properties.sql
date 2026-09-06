/*
--------------------------------
Assign properties to instruments
--------------------------------

In this snippet we assign properties to instruments.

For more details on LUSID providers, see this page:

https://support.lusid.com/knowledgebase/category/?id=CAT-01099

Prerequisite setup steps:

    1. Setup the property definitions referenced below 
    2. Setup the instruments referenced below

*/

@@scope = select 'luminesce-examples';

@newProperties =
values
-- Bonds
('GLNBND001', @@scope, 'CapitalType', 'Senior Unsecured Debt'),
('GLNBND002', @@scope, 'CapitalType', 'Subordinated ''Mezzanine'' Debt'),
('GLNBND001', @@scope, 'PaybackPriority', 3),
('GLNBND002', @@scope, 'PaybackPriority', 4),

-- Equity
('GLEN-LDN-001', @@scope, 'CapitalType', 'Common Equity'),
('GLEN-LDN-001', @@scope, 'PaybackPriority', 6),

-- Asset backed loan
('GLEN-VALERIA-COAL-AUS-1', @@scope, 'CapitalType', 'Asset-Based Loans'),
('GLEN-VALERIA-COAL-AUS-1', @@scope, 'PaybackPriority', 1),

-- Term deposit
('GLN-TD-001', @@scope, 'CapitalType', 'Senior Secured Debt'),
('GLN-TD-001', @@scope, 'PaybackPriority', 2);

@instProperties =
select 
column1 as EntityId, 
'ClientInternal' as EntityIdType, 
'Instrument' as Domain,
Column2 as PropertyScope, 
Column3 as PropertyCode,
Column4 as Value,
@@scope as EntityScope
from @newProperties;

-- Upload the transformed data into LUSID
select *
from Lusid.Property.Writer
where ToWrite = @instProperties;
