@@today = select Date('now');

@table_of_data = select
 'Finbourne-Examples' as PortfolioScope,
 'UK-Equities' as PortfolioCode,
 @@today as EffectiveAt,
 'BBG00WGHTKZ0' as Figi,
 100 as Units,
 12.3 as CostPrice,
 'USD' as CostCurrency,
 #2022-04-19# as PurchaseDate,
 #2022-04-21# as SettleDate,
 'QuantitativeSignal' as Strategy,
 'Set' as WriteAction
;
select * from Lusid.Portfolio.Holding.Writer where toWrite = @table_of_data;