-- =======================================================
-- Description:
-- 1. In this query, we add a new holding to the portfolio
-- =======================================================

-- Defining date of holding
@@today = select Date('now');

-- Defining scope and code variables
@@portfolioScope =

select 'luminesce-examples';

@@portfolioCode1 =

select 'UkEquity';

-- Create new table to store holding's data
@holding_data = 

select  @@portfolioScope as PortfolioScope,
        @@portfolioCode1 as PortfolioCode,
        @@today as EffectiveAt,
        'LUID_00003D6Z' as LusidInstrumentId,
        'GBP' as CostCurrency,
        100 as Units,
        12.3 as CostPrice,
        #2022-04-19# as PurchaseDate,
        #2022-04-21# as SettleDate,
        'QuantitativeSignal' as Strategy,
        'Set' as WriteAction

        union all

select  @@portfolioScope as PortfolioScope,
        @@portfolioCode1 as PortfolioCode,
        @@today as EffectiveAt,
        'LUID_00003D76' as LusidInstrumentId,
        'GBP' as CostCurrency,
        100 as Units,
        12.3 as CostPrice,
        #2022-04-19# as PurchaseDate,
        #2022-04-21# as SettleDate,
        'QuantitativeSignal' as Strategy,
        'Set' as WriteAction;
        

-- Write table to the portfolio
select * from Lusid.Portfolio.Holding.Writer where toWrite = @holding_data;
