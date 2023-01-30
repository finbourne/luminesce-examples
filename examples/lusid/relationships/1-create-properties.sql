-- =============================================================
-- Description:
-- In this query, we create a set of LE identifier properties
-- =============================================================

-- UPLOAD PROPERTIES INTO LUSID

@@propertyScope = select 'ibor';

@property_definition = select
'Custodian' as [DisplayName],
'LegalEntity' as [Domain],
@@propertyScope as [PropertyScope],
'Custodian' as [PropertyCode],
'Identifier' as [ConstraintStyle],
'system' as [DataTypeScope],
'string' as [DataTypeCode]
union all
values
('Country',  'LegalEntity',  @@propertyScope, 'Country', 'Property', 'system', 'string');

select * from Lusid.Property.Definition.Writer
where ToWrite = @property_definition;


-- INLINE PROPERTIES IN LUMINESCE

@identifiersToCatalog = values
('LegalEntity/ibor/Custodian',  '_identifier', 'Custodian'),
('LegalEntity/default/LEI',  '_identifier', 'LEI'),
('LegalEntity/ibor/Country',  'Text', 'Country');

@outputFromSaveAs = use Sys.Admin.File.SaveAs with @identifiersToCatalog
--path=/config/lusid/factories/
--type:Csv
--fileNames
legalentityproviderfactory
enduse;

select * from @outputFromSaveAs;