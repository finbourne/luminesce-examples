-- =============================================================
-- Description:
-- 1. In this query, we create a set of LE identifier properties
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