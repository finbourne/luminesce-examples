-- ===============================================================
-- Description:
-- In this query, make properties available to Luminesce.
--   we create instrument properties needed for the QC
-- See the following page for further details:
-- https://support.lusid.com/knowledgebase/article/KA-01702/en-us
-- ===============================================================
-- 1. Define new properties HERE:
@newProperties = values
('Instrument/ibor/QualityControlStatus', 'Text', 'QualityControlStatus', 'The quality control status of the instrument.'),
('Instrument/ibor/Sector', 'Text', 'Sector', 'The sector that the instrument belongs to.'),
('Instrument/ibor/SourceFile', 'Text', 'SourceFile', 'The source file of the instrument.'),
('Instrument/ibor/InternalRating', 'Text', 'InternalRating', 'The internal rating of the instrument.'),
('Instrument/ibor/SharesOutstanding', 'Decimal', 'SharesOutstanding', 'The number of shares outstanding for the instrument.'),
('Instrument/ibor/RegFlag', 'Text', 'RegFlag', 'Red flag.'),
('Instrument/ibor/MissingFields', 'Text', 'MissingFields', 'Missing fields.');

-- 2. Create a view of new properties to upload to LUSID
@property_definition = select
Column3 as [DisplayName],
'Instrument' as [Domain],
'ibor' as [PropertyScope],
Column3 as [PropertyCode],
'Property' as [ConstraintStyle],
'system' as [DataTypeScope],
case when Column2 == 'Text' then 'string' else 'number' end as [DataTypeCode]
from @newProperties;

-- 3. The results of writing the new property definitions can be seen from the query below:
select * from Lusid.Property.Definition.Writer
where ToWrite = @property_definition;