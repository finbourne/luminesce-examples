-- ============================================================
-- Description:
-- This is the high level query which an end-user might run
-- to collect all P/E Ratio outliers outside 2 Standard Deviations
-- of the mean belonging to the property group (Sector = Tech) on 
-- an AsAt/EffectiveAt
-- ============================================================

select *
from DataQc.CrossSectionalOutlierChecks
where PropertyScopes = 'ibor'
and PropertyKeys= 'Sector'
and PropertyValues= 'Tech'
and StandardDeviations = 2
and AsAt = '2023-07-06'
and EffectiveAt = '2023-07-06'

