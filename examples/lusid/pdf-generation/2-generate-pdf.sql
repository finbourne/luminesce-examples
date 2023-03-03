-- ===============================================================
-- Description:
-- In this query we will generate a PDF holdings report. In order
-- to do so, we must provide a template which has a set of fields.
-- This is the report-template.pdf file within the data folder.
-- 
-- We add data to our template in two ways. The first is to assign
-- values directly to their form field names abd the other is to
-- add the value into the provider. For our table of holdings 
-- we use the second method, and for our variables we use the first.
-- 
-- For more information, see the knowledge base article at:
-- https://support.lusid.com/knowledgebase/article/KA-01693/en-us
-- ===============================================================

-- Declare variables

@@portfolio_scope = select 'pdf-report';
@@portfolio_code = select 'uk-equity';
@@portfolio_name = select 'UK EQUITY';
@@date_now = select '('|| date('now') || ')';

-- Get holdings and format

@holdings =
select
Units,
CostAmount,
CostCurrency,
LusidInstrumentId
from
Lusid.Portfolio.Holding h
where
h.PortfolioScope = @@portfolio_scope 
and 
h.PortfolioCode = @@portfolio_code;

@txn_data =
select
h.Units,
h.CostAmount as 'Cost Amount',
h.CostCurrency as 'Cost Currency',
t.TransactionDate as 'Transaction Date',
t.LusidInstrumentId
from
Lusid.Portfolio.Txn t
inner join 
@holdings h
where
h.LusidInstrumentId = t.LusidInstrumentId
and
t.PortfolioScope = @@portfolio_scope 
and 
t.PortfolioCode = @@portfolio_code;

@table_data =
select distinct
i.DisplayName as "Equity Name",
t.Units,
t."Cost Amount",
t."Cost Currency",
t."Transaction Date",
i.Isin as 'ISIN',
i.Sedol as 'SEDOL'
from 
Lusid.Instrument.Equity i
inner join
@txn_data t
where 
t.LusidInstrumentId = i.LusidInstrumentId;

-- Add values into our pre-defined form fields in the format:
-- (FIELD_NAME, VALUE, FONT, FONT_SIZE)

@replacements = values 
('DATE', @@date_now, 'Liberation Sans', '14'),
('PORTFOLIO_NAME', @@portfolio_name, 'Liberation Sans', '11'),
('PORTFOLIO_CODE', @@portfolio_code, 'Liberation Sans', '11'),
('PORTFOLIO_SCOPE', @@portfolio_scope, 'Liberation Sans', '11');

-- Generate PDF, passing in our replacement values and table of holdings data

@response =
use Drive.SaveAs with @replacements, @table_data
--templatePath=luminesce-examples/report-template.pdf
--type=Pdf
--path=luminesce-examples
--combineToOne=fund-performance.pdf
--fileNames
Text:replacements
table_data
enduse;

select * from @response