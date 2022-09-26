-- ===============================================================
-- Description:
-- Here you describe what the example does.
-- Your description should follow the following format:
-- In this query, <description>.

-- If the example has multiple steps, then number them as follows,
-- In this query, <description>:
-- 1. <step one>
-- 2. <step two>
-- ...
-- ===============================================================

-- Variable creation:
-- Describe what variables are being defined.
-- For this project, we use the `luminesce-examples` scope.

-- Example:
-- Defining portfolio scope and code.

@@portfolioScope = select 'luminesce-examples';
@@portfolioCode = select 'uk-equity';

-- Example of querying instruments

select * from Lusid.Portfolio 
where PortfolioCode=@@portfolioCode
and PortfolioScope=@@portfolioScope;