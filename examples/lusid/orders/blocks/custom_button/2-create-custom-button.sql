@@providerName = select 'Set_Contingent_Order_ID_KR_five';
@data = values
  ('blockUpdateExample', "ORD-BLKTEST-BLK1");
@block_ids = select
  column1 as scope,
  column2 as code
FROM @data;

--- Create the view
@view = use Sys.Admin.SetupView with @@providerName, @block_ids
--provider={@@providerName}
--description="An example process that can be triggered for a set of Blocks"
--parameters
BlockIds,Table,@block_ids,true,Block scopes+codes
----

@block_ids = select * from #PARAMETERVALUE(BlockIds);

-- Trigger sequence and get contingent id

@sequence = SELECT 1 as NextBatch, 
'order_block_contingent_id' as Code, 
'Next' as WriteAction,
'blockUpdateExample' as Scope;
@contingent_id = select NextValueInSequence as Contingent_Id from Lusid.Sequence.Writer where toWrite = @sequence;

-- Add contingent Ids to the target blocks
@block_ids_with_contingent_ids = SELECT 
    b.scope,
    b.code,
    cid.Contingent_Id
FROM 
    @block_ids b
INNER JOIN (@contingent_id) cid;

-- Generate Blocks with updated values
@blocks = SELECT
biwci.Contingent_Id as Contingent_Id,
b.* 
FROM @block_ids_with_contingent_ids biwci
INNER JOIN Lusid.Block b
ON biwci.scope = b.BlockScope AND
biwci.code = b.BlockCode;
        
-- Write updated values to the block
@inserpt = select * from Lusid.Block.Writer where toWrite = @blocks;

select "Contingent IDS written!" as result;

enduse;
@created = select * from @view;

--- Set the requirement metadata on the view
@metadata = values
  (@@providerName, 'OrderBlotterBlockAction', 'True');
@toWrite = select
  column1 as ProviderName,
  column2 as MetadataKey,
  column3 as MetadataValue
from @metadata;
select * from Sys.Registration.Metadata.Writer
  where ToWrite = @toWrite