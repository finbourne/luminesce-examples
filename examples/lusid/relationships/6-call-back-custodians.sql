-- =============================================================
-- Description:
-- 1. In this query, we create a set of LE identifier properties
-- =============================================================

@custodians = select 'LegalEntity' as EntityType,
'Custodian' as EntityCode,
'ibor' as EntityScope,
Custodian as EntityValue,
'True' as ShowAllRelatedEntityIdentifiers
from Lusid.LegalEntity;

select 
RelationshipCode, 
EntityValue as 'Custodian',
RelatedEntityCode as 'Portfolio'
from Lusid.Relationship
where ToLookUp=@custodians;
