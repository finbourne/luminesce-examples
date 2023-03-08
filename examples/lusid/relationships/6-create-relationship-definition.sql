-- ====================================================================
-- Description:
-- 1. In this query, we create a relationship entity to 
-- capture the mapping between Portfolios and Legal Entity Identifiers
-- ====================================================================

@port_custodian_relationship = select 'LEIToPortfolio' as Code,
'LEIToPortfolio'as DisplayName,
'LEIToPortfolio' as OutwardDescription,
'PortfolioToLEI' as InwardDescription,
'default' as Scope,
'LegalEntity' as SourceEntityType,
'Portfolio' as TargetEntityType;

select * from Lusid.Relationship.Definition.Writer
where ToWrite = @port_custodian_relationship;