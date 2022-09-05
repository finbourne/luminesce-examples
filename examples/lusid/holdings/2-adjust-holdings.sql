@table_of_data = select
 'Finbourne-Examples' as PortfolioScope,
 'UK-Equities' as PortfolioCode,
 #2022-04-21# as EffectiveAt,
 'CCY_GBP' as LusidInstrumentId,
 100000 as Units,
 'Adjust' as WriteAction
;
select * from Lusid.Portfolio.Holding.Writer where toWrite = @table_of_data;