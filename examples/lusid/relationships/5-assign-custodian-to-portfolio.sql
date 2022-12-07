-- =============================================================
-- Description:
-- 1. In this query, we create a set of LE identifier properties
-- =============================================================

@@scope = select 'ibor';

@portfolio_data = use Drive.Excel
--file=/luminesce-examples/custodians.xlsx
--worksheet=portfolios
enduse;

@assign_relationships = select 'LegalEntity' as EntityType,
'Custodian' as EntityCode,
@@scope as EntityScope,
custodian_code as EntityValue,
port_code as RelatedEntityCode,
@@scope  as RelatedEntityScope,
'Portfolio' RelatedEntityType,
'CustodianToPortfolio' as RelationshipCode,
@@scope as RelationshipScope
from @portfolio_data;

select * from Lusid.Relationship.Writer
where ToWrite = @assign_relationships;