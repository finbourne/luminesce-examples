-- =============================================================
-- Description:
-- In this query, we create a report of portfolios to 
-- custodians
-- =============================================================

-- Collect all custodians in scope

@custodians = select 'LegalEntity' as EntityType,
'Custodian' as EntityCode,
'ibor' as EntityScope,
Custodian as EntityValue,
'True' as ShowAllRelatedEntityIdentifiers
from Lusid.LegalEntity;

-- Check which portfolios are assigned to these custodians

@relationships = select 
RelationshipCode, 
EntityValue as 'Custodian',
RelatedEntityCode as 'Portfolio'
from Lusid.Relationship
where ToLookUp=@custodians;

-- Generate report of custodians to portfolios

@le_data = select LegalEntityId, Custodian, Country from Lusid.LegalEntity
where Custodian is not null;

@report = select le.Custodian,
le.LegalEntityId,
le.Country,
r.RelationshipCode,
r.Portfolio
from @relationships r
join @le_data le on (r.Custodian = le.Custodian);

select * from @report;