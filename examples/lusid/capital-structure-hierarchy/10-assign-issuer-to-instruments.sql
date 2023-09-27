-- ================================================================
-- Description:
-- In this query, we assign Portfolios to a Legal Entity Identifier
-- ================================================================
@@scope = select 'luminesce-examples';

--get instrumentIds to link
@loaded_instruments =
select 
LusidInstrumentId,
ClientInternal,
DisplayName,
[Type],
InferredDomCcy
from Lusid.Instrument
where Scope = @@scope
and ClientInternal in (
'GLEN-LDN-001',
'GLNBND001',
'GLNBND002',
'GLN-TD-001',
'GLEN-VALERIA-COAL-AUS-1'
);

-- 2. Define a relationship between Issuer and instruments
@assign_relationships =
select 
'Instrument' as EntityType, 
@@scope as EntityScope, 
'LusidInstrumentId' as EntityCode, 
LusidInstrumentId as EntityValue,
'LegalEntity' RelatedEntityType,
@@scope as RelatedEntityScope, 
'IssuerId' as RelatedEntityCode,
'2138002658CPO9NBH955' as RelatedEntityValue,
'Issuer' as RelationshipCode,
@@scope as RelationshipScope
from @loaded_instruments;

-- 3. Write the relationship to Lusid.Relationship.Writer and print results to console
select *
from Lusid.Relationship.Writer
where ToWrite = @assign_relationships;
