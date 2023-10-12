-- ====================================================================
-- Description:
-- 1. In this query, we create a relationship entity to 
-- capture the mapping between Issuer and Instruments
-- ====================================================================

@@scope = select 'luminesce-examples';

@inst_issuer_relationship = 
select 
'Issuer' as Code,
'Issuer' as DisplayName,
'Issued By' as OutwardDescription,
'Issues' as InwardDescription,
@@scope as Scope,
'Instrument' as SourceEntityType,
'LegalEntity' as TargetEntityType,
'ManyToOne' as RelationshipCardinality
;

select * from Lusid.Relationship.Definition.Writer
where ToWrite = @inst_issuer_relationship;
