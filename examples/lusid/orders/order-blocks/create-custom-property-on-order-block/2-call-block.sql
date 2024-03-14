/*

-----------
call Block
-----------

Description:

    - In this query, we will call the Blocks that i just set

*/


-- Loading in block data from Excel spreadsheet
@block_data_from_spreadsheet = 
use Drive.Excel
--file=/luminesce-examples/order-blocks/block_seed.xlsx
--worksheet=blocks
--addFileName
enduse;

-- Defining scope and code variables

@@blockScope =
select bdfs.Block_Scope FROM @block_data_from_spreadsheet bdfs;

@@blockCode =
select bdfs.Block_Code from @block_data_from_spreadsheet bdfs ;

select * from Lusid.Block
where BlockCode= @@blockCode
and BlockScope= @@blockScope;

