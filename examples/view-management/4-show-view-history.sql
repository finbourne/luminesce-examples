-- ============================================================
-- Description:
-- This query shows the history of changes to a view
-- (essentially SCCM for views)
-- ============================================================

select
  *
from
  sys.file.history
where
  directory = 'databaseproviders/Test/Example'
and
  name = 'TestHoldings'