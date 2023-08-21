/*

--------------------------------
Assign properties to instruments
--------------------------------

In this snippet we assign properties to instruments.

For more details on LUSID providers, see this page:

https://support.lusid.com/knowledgebase/category/?id=CAT-01099

Prerequisite setup steps:

    1. Setup the property definitions referenced below 
    2. Setup the instruments referenced below

*/

@@scope = select 'luminesce-examples';

-- Step 1: Define the property definitions

@newProperties =
values

-- Sectors
('FBNABOR001', @@scope, 'Sector', 'Consumer'),
('FBNABOR002', @@scope, 'Sector', 'Consumer'),
('FBNABOR003', @@scope, 'Sector', 'Consumer'),
('FBNABOR004', @@scope, 'Sector', 'Consumer'),
('FBNABOR005', @@scope, 'Sector', 'Consumer'),
('FBNBND001', @@scope, 'Sector', 'Consumer'),
('FBNBND002', @@scope, 'Sector', 'Consumer'),
('FBNBND003', @@scope, 'Sector', 'Consumer'),
('FBNBND004', @@scope, 'Sector', 'Consumer'),

-- Country
('FBNABOR001', @@scope, 'Country', 'United Kingdom'),
('FBNABOR002', @@scope, 'Country', 'United Kingdom'),
('FBNABOR003', @@scope, 'Country', 'United States'),
('FBNABOR004', @@scope, 'Country', 'United States'),
('FBNABOR005', @@scope, 'Country', 'United Kingdom'),
('FBNBND001', @@scope, 'Country', 'United States'),
('FBNBND002', @@scope, 'Country', 'United States'),
('FBNBND003', @@scope, 'Country', 'United Kingdom'),
('FBNBND004', @@scope, 'Country', 'United Kingdom'),

-- Internal ratings
('FBNABOR001', @@scope, 'InternalRating', 8),
('FBNABOR002', @@scope, 'InternalRating', 8),
('FBNABOR003', @@scope, 'InternalRating', 9),
('FBNABOR004', @@scope, 'InternalRating', 7),
('FBNABOR005', @@scope, 'InternalRating', 7),
('FBNBND001', @@scope, 'InternalRating', 8),
('FBNBND002', @@scope, 'InternalRating', 8),
('FBNBND003', @@scope, 'InternalRating', 6),
('FBNBND004', @@scope, 'InternalRating', 7);

@instProperties =
select 
column1 as EntityId, 
'ClientInternal' as EntityIdType, 
'Instrument' as Domain,
Column2 as PropertyScope, 
Column3 as PropertyCode,
Column4 as Value,
@@scope as EntityScope
from @newProperties;

-- Upload the transformed data into LUSID

select *
from Lusid.Property.Writer
where ToWrite = @instProperties
limit 5;