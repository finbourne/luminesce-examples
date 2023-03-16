-- =============================================================
-- Description:
-- In this query, we create a report of Portfolios to
-- Legal Entity Identifiers
-- =============================================================
-- 1. Collect the Legal Entity Identifiers
@lei_data =
use Drive.Excel
--file=/luminesce-examples/custodians.xlsx
--worksheet=custodians
enduse;

@leis =
select 'LegalEntity' as EntityType, 'LEI' as EntityCode, 'default' as EntityScope, lei as EntityValue
from @lei_data;

-- 2. Check which Portfolios in Lusid have the same custodians as these Legal Entities
@relationships =
select RelationshipCode, EntityValue as 'LegalEntity', RelatedEntityCode as 'Portfolio'
from Lusid.Relationship
where ToLookUp = @leis;

-- 3. Generate report of Legal Entities to Portfolios
@ids =
select EntityValue
from @leis;

@report =

select p.EntityId, p.Value as Custodian, r.RelationshipCode, r.Portfolio
from Lusid.Property p
inner join (
   select *
   from @relationships
   ) r
   on r.LegalEntity = p.EntityId
where p.propertycode = 'Custodian'
   and p.propertyscope = 'ibor'
   and p.domain = 'LegalEntity'
   and p.EntityId in @ids
   and p.EntityIdType = 'LEI'
   and p.EntityScope = 'default';

select *
from @report;
