-- =============================================================
-- Description:
-- Call the view we have setup to retrieve all instruments associated
-- with this issuer. This in
-- =============================================================
-- 1. Collect the Legal Entity Identifiers

select *
from Views.Luminesce_examples.Instruments_by_issuer
where IssuerIdFilter = '2138002658CPO9NBH955'
;

