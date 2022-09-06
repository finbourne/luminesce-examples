-- ===============================================================
-- Description:
-- Here you describe what the example does.
-- Your description should follow the following format:
-- In this query, <description>.
-- ===============================================================

-- Variable creation:
-- Describe what variables are being defined.
-- For this project, we use the `luminesce-examples` scope.

-- Example:
-- Defining portfolio scope and code.
@@portfolioScope = select 'luminesce-examples';

@@portfolioCode = select 'uk-equity'


-- Reading from a file:
-- Files can be loaded from the LUSID drive in the following formats: 
-- CSV, Excel, Sqlite, RawText, Xml.

-- The generic 'Drive.File' can also be used to search for specific files.
-- More information on this can be found here: https://support.lusid.com/knowledgebase/article/KA-01687/

-- CSV example:
@data_from_csv = 

use Drive.Csv
--file=<file_path>
enduse;

-- Excel example:
@data_from = 

use Drive.Excel
--file=<file_path>
--worksheet=<worksheet_name>
enduse;

-- Sqlite example:
@data_from_sqlite = 

use Drive.Sqlite
--file=<file_path>
enduse;

-- RawText example:
@data_from_text = 

use Drive.RawText
--file=<file_path>
enduse;

-- Xml example:
@data_from_xml = 
use Drive.Xml
--file=<file_path>
--nodePath=<node_path>
--columns
enduse;

-- File example:
-- Retreives all files in root directory
select * from Drive.File


-- Reading portfolios or instruments:
-- Any data stored in LUSID can be queried through Luminesce. To access portfolios
-- or instruments, an object specific 'provider' can be used, which
-- requires object-specific parameters.

-- Generic example
select * from Lusid.[ Portfolio | Instrument ];


-- Writing to portfolios/instruments/transactions:
-- Luminesce has the power to write to any part of the LUSID platform, meaning any
-- updates to the data of users' portfolios can be performed through luminesce. 
-- Object-specific 'providers,' denoted by 'Lusid.<object>.Writer' can take a data-table
-- and write the information in to LUSID. 

-- Portfolio example:
@data_table = 

select  '<BaseCurrency>' as BaseCurrency,
        '<PortfolioCode>' as PortfolioCode,
        '<PortfolioScope>' as PortfolioScope,
        '<PortfolioType>' as PortfolioType

select * from Lusid.Portfolio.Writer 
where toWrite = @data_table;


-- Response information:
-- All 'Writer' providers in Luminesce provide a response table, providing information
-- on the success of the upsert. To access this response, simply assign a table to the
-- 'Writer' provider, and then select everything from the table.

-- Generic example (using Portfolio.Writer example above):
@data_table = 

select  '<BaseCurrency>' as BaseCurrency,
        '<PortfolioCode>' as PortfolioCode,
        '<PortfolioScope>' as PortfolioScope,
        '<PortfolioType>' as PortfolioType

@response = 

select * from Lusid.Portfolio.Writer 
where toWrite = @data_table;

select * from @response