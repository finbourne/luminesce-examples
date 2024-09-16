-- =============================================================
-- Description:
-- In this query, we create an identifier to use for our issuer
-- =============================================================
-- 1. Create new property definition
@@propertyScope = select 'luminesce-examples';

@property_definition = select
'IssuerId' as [DisplayName],
'LegalEntity' as [Domain],
@@propertyScope as [PropertyScope],
'IssuerId' as [PropertyCode],
'Identifier' as [ConstraintStyle],
'system' as [DataTypeScope],
'string' as [DataTypeCode]
;

-- 2. Upload new properties to LUSID and print result to console here:
@created_prop =
select * from Lusid.Property.Definition.Writer
where ToWrite = @property_definition;


/*

=============================================
        2. Create LE Identifiers
=============================================

*/

@identifiersToCatalog =
select 
'LegalEntity/luminesce-examples/IssuerId' as [Key];


select * from Sys.Admin.Lusid.Provider.Configure wait 2
where Provider = 'Lusid.LegalEntity'
and Configuration = @identifiersToCatalog
and WriteAction = 'Modify';
