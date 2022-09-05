@table_of_data = select
 'Finbourne-Examples' as PortfolioScope,
 'UK-Equities' as PortfolioCode,
 #2022-04-26# as EffectiveAt,
 'Cancel' as WriteAction
;
select * from Lusid.Portfolio.Holding.Writer where toWrite = @table_of_data;