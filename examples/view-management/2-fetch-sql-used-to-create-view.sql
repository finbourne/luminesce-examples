-- ============================================================
-- Description:
-- 1. This query shows the query which was run to create a view
-- ============================================================

select
   Sql, At
from
   sys.logs.hcquery
where
   Sql like '%SetupView%'
   and Sql like '%Test.Example.TestHoldings%'
   and Sql not like '%HcQuery%'
   and ShowAll = true
order by At desc
limit 1