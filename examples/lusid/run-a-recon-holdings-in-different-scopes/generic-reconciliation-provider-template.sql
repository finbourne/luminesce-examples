------------------------------
-- Table - Lookup to return --
------------------------------

-- (Required)

-- Define rows of table
@lookup = values
-- (ReconciliationKey, LeftPortfolioScope*, LeftPortfolioCode*, LeftPortfolioType, RightPortfolioScope*, RightPortfolioCode*, RightPortfolioType, LeftRecipeId*, RightRecipeId*, LeftReportCurrency, RightReportCurrency, LeftValuationDate, RightValuationDate)
('RecKey1', 'PortScopeA', 'PortCodeA', 'SinglePortfolio', 'PortScopeY', 'PortCodeY', 'SinglePortfolio', 'RecipeScope/RecipeCode', 'RecipeScope/RecipeCode', 'GBP', 'USD', #2022-01-01#, #2022-01-01#),
('RecKey1', 'PortScopeB', 'PortCodeB', 'SinglePortfolio', 'PortScopeZ', 'PortCodeZ', 'SinglePortfolio', 'RecipeScope/RecipeCode', 'RecipeScope/RecipeCode', 'GBP', 'USD', #2022-01-01#, #2022-01-01#),
('RecKey2', 'PortScopeA', 'PortCodeA', 'SinglePortfolio', 'PortScopeY', 'PortCodeY', 'SinglePortfolio', 'RecipeScope/RecipeCode', 'RecipeScope/RecipeCode', 'GBP', 'USD', #2022-01-01#, #2022-01-01#),
('RecKey3', 'PortScopeB', 'PortCodeB', 'SinglePortfolio', 'PortScopeZ', 'PortCodeZ', 'SinglePortfolio', 'RecipeScope/RecipeCode', 'RecipeScope/RecipeCode', 'GBP', 'USD', #2022-01-01#, #2022-01-01#)
;

-- Assign rows to columns
@lookup_to_return =
select
    column1 as ReconciliationKey, -- Optional, defaults to 'LeftScope/LectCode-RightScope/RightCode'
    column2 as LeftPortfolioScope, -- Required
    column3 as LeftPortfolioCode, -- Required
    column4 as LeftPortfolioType, -- Optional, defaults to 'SinglePortfolio'
    column5 as RightPortfolioScope, -- Required
    column6 as RightPortfolioCode, -- Required
    column7 as RightPortfolioType, -- Optional, defaults to 'SinglePortfolio'
    column8 as LeftRecipeId, -- Optional, defaults to 'PortfolioScope/default'
    column9 as RightRecipeId, -- Optional, defaults to 'PortfolioScope/default'
    column10 as LeftReportCurrency, -- Optional
    column11 as RightReportCurrency, -- Optional
    column12 as LeftValuationDate, -- Optional, defaults to query date
    column13 as RightValuationDate -- Optional, defaults to query date
from @lookup;

--------------------------------
-- Table - Measures to return --
--------------------------------

-- (Optional)

-- Define rows of table
@measures = values
-- Instrument metrics
('Instrument/...', 'Value', null),
('Instrument/...', 'Sum', null),
-- Portfolio metrics
('Portfolio/...', 'Value', null),
('Portfolio/...', 'Sum', null),
-- Holding metrics
('Holding/...', 'Value', null),
('Holding/...', 'Sum', null),
-- Transaction metrics
('Transaction/...', 'Value', null),
('Transaction/...', 'Sum', null),
-- Quotes metrics
('Quotes/...', 'Value', 'Left'),
('Quotes/...', 'Sum', 'Right'),
-- Valuation Metrics
('Valuation/...', 'Value', 'Left'),
('Valuation/...', 'Sum', 'Right'),
-- Analytic metrics
('Analytic/...', 'Value', 'Left'),
('Analytic/...', 'Sum', 'Right')
;

-- Assign rows to columns
@measures_to_return = select
    column1 as 'MeasureName',
    column2 as 'Operation',
    column3 as 'ReconciliationSide'

from @measures;

------------------------------
-- Table - Comparison Rules --
------------------------------

-- (Optional)

@comparisons = values
-- (RuleType, ComparisonType, Tolerance, AppliesToKey, AppliedToOp)
('ReconcileNumericRule', 'AbsoluteDifference', 1000, 'Example/Numeric/Metric', 'Value')
;

@comparison_rules = select
    column1 as 'RuleType',
    column2 as 'ComparisonType',
    column3 as 'Tolerance',
    column4 as 'AppliesToKey',
    column5 as 'AppliesToOp'
from @comparisons;

----------------------------------
-- Reconciliation Provider Call --
----------------------------------

@rec_response = select * from Lusid.Portfolio.Reconciliation.Generic where
    MeasuresToReturn = @measures_to_return -- Optional, defaults to ('Valuation/Pv/Amount', 'Sum'), ('Valuation/Pv/Ccy', 'Value')
    and
    ToLookup = @lookup_to_return -- Required
    and
    ComparisonRules = @comparison_rules -- Optional
    and
    UseDefaultGroupKeys = false -- Optional, defaults to true
    and
    KeysToGroupBy = 'Example/Key' -- Optional, defaults to 'Instrument/default/LusidInstrumentId'
    and
    Error is null
;

@pivot = use Tools.Pivot with @rec_response
--key=Measure
--aggregateColumns=LeftMeasureValue,RightMeasureValue,Difference,ResultComparison
enduse;

-- Raw output (Multiple rows per instrument, single left and right value columns)
select * from @rec_response;

-- Pivoted output (Single row per instrument, multiple left and right value columns)
select * from @pivot;