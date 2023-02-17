-- ============================================================
-- Description:
-- 1. This query demonstrates how to apply a Fuzzy search 
--    algorithm to match data entries across two files.
-- 
-- 2. The first data file is from Companies Taking Action (CTA),
--    and second from BCORP Impact Data.
-- 
-- 3. Fuzzy search algorithm (Levenshtein distance) works by comparing
--    the similarity of strings by calculating the number of 
--    characters that need to be changed in the first word to
--    match the second word.
--
-- 4. The Fuzzy score denotes how many characters need to be
--    changed to form a match.
-- 
-- 5. Luminesce's built-in edit_distance function is an 
--    implementation of this algorithm.
-- 
-- Links to Datasets :
-- CTA - https://sciencebasedtargets.org/companies-taking-action
-- BCORP - https://data.world/blab/b-corp-impact-data
-- 
-- Save these files in your drive
-- https://support.lusid.com/knowledgebase/article/KA-01635/en-us
-- 
-- ============================================================

-- Get files from drive
@bcorp = use Drive.Csv
--file=/luminesce-examples/b-corp.csv
enduse;

@cta = use Drive.Csv
--file=/luminesce-examples/companies-taking-action.csv
enduse;

-- Make location values consistent across both datasets to help with comparison
@cta_formatted = 
select "Company Name" as company_name,
"Near term - Target Status" as target,
ISIN,
case
when "Location" = "United Kingdom (UK)" then "United Kingdom"
when "Location" = "United States of America (USA)" then "United States"
when "Location" = "Hong Kong, China" then "Hong Kong S.A.R"
when "Location" = "Netherlands" then "Netherlands The"
when "Location" = "Taiwan, Province of China" then "Taiwan"
when "Location" = "United Arab Emirates (UAE)" then "United Arab Emirates"
else "Location"
end as location
from @cta;

-- Filter down companies that are in same location, restrict search radius
@data = 
select distinct
b.company_name as BCORP_COMPANY,
c.company_name as CTA_COMPANY,
b.description as DESCRIPTION,
c.target as TARGET_STATUS,
b.company_id as COMPANY_ID,
c.ISIN as ISIN
from @bcorp b
inner join @cta_formatted c
where c.location = b.country;

-- Run fuzzy search on remaining matches
@fuzzy = 
select
BCORP_COMPANY,
CTA_COMPANY,
edit_distance(BCORP_COMPANY, CTA_COMPANY) as 'LEVENSHTEIN_RESULTS',
COMPANY_ID,
ISIN,
DESCRIPTION,
TARGET_STATUS
from @data;

-- Display matches with Fuzzy score of less than 2
select * from @fuzzy where "LEVENSHTEIN_RESULTS" < 2;