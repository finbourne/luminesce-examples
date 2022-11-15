-- =============================================================
-- Description:
-- 1. In this query, we perform a reconciliation on 2 portfolios
-- using the generic reconciliation provider
-- =============================================================

------------------------------
-- Table - Lookup to return --
------------------------------

-- (Required)

@lookup = values
('ibor-recon-test', 'ibor-recon-test', 'UkEquity001', 'SinglePortfolio', 'ibor-recon-test', 'UkEquity002', 'SinglePortfolio', 'ibor-recon-test/default', 'ibor-recon-test/default', 'GBP', 'GBP', #2022-11-11#, #2022-11-11#)
;

@lookup_to_return =
select
    column1 as ReconciliationKey,
    column2 as LeftPortfolioScope,
    column3 as LeftPortfolioCode,
    column4 as LeftPortfolioType,
    column5 as RightPortfolioScope,
    column6 as RightPortfolioCode,
    column7 as RightPortfolioType,
    column8 as LeftRecipeId,
    column9 as RightRecipeId,
    column10 as LeftReportCurrency,
    column11 as RightReportCurrency,
    column12 as LeftValuationDate,
    column13 as RightValuationDate
from @lookup;

--------------------------------
-- Table - Measures to return --
--------------------------------

-- (Optional)

@measures = values
('Holding/default/Units', 'Sum', null),
('Holding/default/Cost', 'Sum', null)
;

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
('ReconcileNumericRule', 'AbsoluteDifference', '200', 'Holding/default/Units', 'Sum')
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
    MeasuresToReturn = @measures_to_return
    and
    ToLookup = @lookup_to_return
    and
    ComparisonRules = @comparison_rules
    and
    UseDefaultGroupKeys = false
    and
    KeysToGroupBy = 'Instrument/default/LusidInstrumentId'
    and
    Error is null
;


@pivot = use Tools.Pivot with @rec_response
--key=Measure
--aggregateColumns=LeftMeasureValue,RightMeasureValue,Difference,ResultComparison
enduse;

-- Uncomment one of the below 2 lines for either raw or pivoted output

-- Raw Output
select * from @rec_response;

-- Pivot Output
-- select * from @pivot;