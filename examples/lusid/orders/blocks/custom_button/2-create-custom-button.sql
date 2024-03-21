/*

---------------------------------------------------------
Create a Custom action that sets Order Block Contingent ID
---------------------------------------------------------

Description:

-- This query creates a custom action view that allows the end user of the view to add contingent ids to blocks
-- the contingent ids are generated via sequences
-- To see the results:
    1. Go to the order blotter, 
    2. Select the Set_contingent_order_id action
    3. Select some order blocks
    4. Click run
    5. See contingent id be set with a dynamically generated value from sequences

More details:

    https://support.lusid.com/knowledgebase/article/KA-01767/en-us

*/
@@providerName = SELECT 'Set_contingent_order_id';

@data = 
VALUES
  ('blockUpdateExample', "ORD-BLKTEST-BLK1");

@block_ids = 
SELECT
  column1 AS scope,
  column2 AS code
FROM @data;

--- Create the view
@view = USE Sys.Admin.SetupView WITH @@providerName, @block_ids
--provider={@@providerName}
--description="An example process that can be triggered for a set of Blocks"
--parameters
BlockIds,Table,@block_ids,true,Block scopes+codes
----

  @block_ids = 
  SELECT * FROM #PARAMETERVALUE(BlockIds);

  -- Trigger sequence and get contingent id

  @sequence = 
  SELECT 
    1 AS NextBatch, 
    'order_block_contingent_id_cycling' AS Code, 
    'Next' AS WriteAction,
    'blockUpdateExample' AS Scope;

  @contingent_id = 
  SELECT 
    NextValueInSequence as Contingent_Id, 
    WriteErrorCode, 
    WriteError 
  FROM 
    Lusid.Sequence.Writer 
  WHERE toWrite = @sequence;

  @@contingent_id_string = SELECT Contingent_Id FROM @contingent_id LIMIT 1;

  -- Add contingent Ids to the target blocks
  @blocks = 
  SELECT
    @@contingent_id_string AS Contingent_Id,
    b.* 
  FROM 
    @block_ids bi
  INNER JOIN 
    Lusid.Block b
  ON 
    bi.scope = b.BlockScope AND
    bi.code = b.BlockCode;

  -- Write updated values to the block
  @inserpt = 
  SELECT
    * 
  FROM 
    Lusid.Block.Writer 
  WHERE 
    toWrite = @blocks;

  @@result = 
  SELECT
    CASE
        WHEN WriteErrorCode = 0 
        THEN 'Contingent IDS written as ' || Contingent_Id
        ELSE 'There was an issue with your Contingent ID. Error: ' || WriteError
    END AS 
      result
    FROM 
      @contingent_id 
    LIMIT 1;

  SELECT @@result AS result;

enduse;

@created = SELECT * FROM @view;

--- Set the requirement metadata on the view
@metadata = VALUES
  (@@providerName, 'OrderBlotterBlockAction', 'True');
@toWrite = 
SELECT
  column1 AS ProviderName,
  column2 AS MetadataKey,
  column3 AS MetadataValue
FROM @metadata;

SELECT * 
FROM Sys.Registration.Metadata.Writer
WHERE ToWrite = @toWrite