/*

-----------------------------------
Create Order Block Custom property 
-----------------------------------

Description:

    -- Creates a custom property in the block domain called Contingent_Id
    -- Inlines that property to the scope and code used in this example

*/

-- Create a custom property to store the contingent order id
@@scope = SELECT 'blockUpdateExample';
@@propertyCode = SELECT 'Contingent_Id';
@@propertyDisplayName = SELECT 'Contingent Id';
@@propertyDescription = SELECT 'A property representing the contingent ID of the Block';

-- Create Property definition
@table_of_data = SELECT 
    'Block' AS Domain, 
    @@scope AS PropertyScope, 
    'system' AS DataTypeScope, 
    'string' AS DataTypeCode, 
    'property' AS ConstraintStyle, 
    @@propertyCode AS PropertyCode, 
    @@propertyDisplayName AS DisplayName, 
    'insert' AS WriteAction;

SELECT * 
FROM Lusid.Property.Definition.Writer 
WHERE ToWrite = @table_of_data;

-- Inline Property https://support.lusid.com/knowledgebase/article/KA-01702/
@@builtKeyString = SELECT 'Block' || '/' ||  @@scope ||  '/' ||  @@propertyCode;

@keysToCatalog = VALUES
    (@@builtKeyString, @@propertyCode, False, @@propertyDescription );

@config = 
SELECT 
    column1 AS [Key], 
    column2 AS Name, 
    column3 AS IsMain, 
    column4 AS Description 
FROM 
    @keysToCatalog;

SELECT 
    * 
FROM 
    Sys.Admin.Lusid.Provider.Configure
WHERE 
    Provider = 'Lusid.Block' AND 
    Configuration = @config AND 
    WriteAction = 'Modify';