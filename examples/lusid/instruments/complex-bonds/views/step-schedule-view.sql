/*
===========================================
        Step Schedule View Creation
===========================================
*/

-- Step Schedule View Input Table
@stepsTableExample = select
'AssetID' as [AssetID],
'2021-09-15T00:00:00+00:00' as [Date],
1 as [Quantity];

@createStepScheduleJsonView =  use Sys.Admin.SetupView with @stepsTableExample
--provider=Schedules.Step_Schedule
--description="Outputs a table with two columns containing the asset ID and the formatted step schedule json"
--parameters
LevelType,Text,Absolute,true
StepScheduleType,Text,Coupon,true
StepsTable,Table,@stepsTableExample,true
AssetFilter, Text, AssetFilter, true
----
@@levelType = select #PARAMETERVALUE(LevelType);
@@stepScheduleType =  select #PARAMETERVALUE(StepScheduleType);
@@assetFilter = select #PARAMETERVALUE(AssetFilter);
@stepsTable = select * from #PARAMETERVALUE(StepsTable) where AssetID = @@assetFilter;

select
st.[AssetID],
json_object(
    'steps', json_group_array(
        json_object(
            'date', st.[Date],
            'quantity', cast(st.[Quantity] as double)
        )
    ),
    'levelType', @@levelType,
    'stepScheduleType', @@stepScheduleType,
    'scheduleType', 'Step'
) as JsonString
from @stepsTable st;

enduse;
