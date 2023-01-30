-- =============================================================
-- Description:
-- 1. In this query, we create a relationship entity to 
-- capture the mapping between portfolio and custodian
-- =============================================================


@port_custodian_relationship = select 'CustodianToPortfolio' as Code,
'CustodianToPortfolio'as DisplayName,
'CustodianToPortfolio' as OutwardDescription,
'PortfolioToCustodian' as InwardDescription,
'ibor' as Scope,
'LegalEntity' as SourceEntityType,
'Portfolio' as TargetEntityType;

select * from Lusid.Relationship.Definition.Writer
where ToWrite = @port_custodian_relationship;