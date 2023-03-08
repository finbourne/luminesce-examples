-- =============================================================
-- Description:
-- In this query, we inline the Legal Entity properties
-- =============================================================
-- 2.  Define custom prop:
@newProperties =
values
('LegalEntity/ibor/Custodian', 'Text', 'Custodian', 'Custodian'),
('LegalEntity/ibor/Country',  'Text', 'Country', 'Country');

-- 4. Write new and old properties into LUSID

@property_definition = select
    Column3 as [DisplayName],
    'LegalEntity' as [Domain],
    'ibor' as [PropertyScope],
    Column3 as [PropertyCode],
    'Property' as [ConstraintStyle],
    'system' as [DataTypeScope],
    case when Column2 == 'Text'
            then 'string'
            else 'number'
      end as [DataTypeCode]
    from @newProperties;

@create_properties =
select * from Lusid.Property.definition.Writer
    where ToWrite = @property_definition;

-- The results of writing the new property definitions can be seen from the query below:
select * from @create_properties;