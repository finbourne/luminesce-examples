-- ============================================================
-- Description:
-- This query shows what deoendencies a view has, including other views and data providers.
-- "includeindirect" means the dependencies are fully expanded all the way to the data providers 
-- ============================================================

select
  *
from
  sys.dependency
where
  name = 'Test.Example.Testholdings'
and
  includeindirect = true
and
  showall = true
