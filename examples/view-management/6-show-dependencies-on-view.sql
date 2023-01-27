-- ============================================================
-- Description:
-- This query shows which views depending on a particular view
-- ============================================================

select
  *
from
  sys.dependency
where
  dependency = 'Drive.Csv'
and
  includeindirect = true
and
  showall = true
