-- ================================================================
-- Description:
-- In this query, we assign Portfolios to a Legal Entity Identifier
-- ================================================================
@@scope = select 'ibor';

-- 1. Create view with LEIs and portfolios joined on custodian name.
@portfolio_data =
use Drive.Excel
--file=/lib-luminesce-examples/custodians.xlsx
--worksheet=portfolios
enduse;

@custodians_data =
use Drive.Excel
--file=/luminesce-examples/custodians.xlsx
--worksheet=custodians
enduse;

@portfolio_custodian_data = select p.port_code, c.lei
from @portfolio_data p
inner join (
   select lei, custodian_code
   from @custodians_data
   ) c
   on p.custodian_code = c.custodian_code;

-- 2. Define a relationship between LEI and Portfolio
@assign_relationships =
select 'LegalEntity' as EntityType, 'LEI' as EntityCode, 'default' as EntityScope, lei as EntityValue, port_code as
   RelatedEntityCode, @@scope as RelatedEntityScope, 'Portfolio' RelatedEntityType, 'LEIToPortfolio' as RelationshipCode,
   @@scope as RelationshipScope
from @portfolio_custodian_data;

-- 3. Write the relationship to Lusid.Relationship.Writer and print results to console
select *
from Lusid.Relationship.Writer
where ToWrite = @assign_relationships;