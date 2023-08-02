/*
============================================
        Fixed Schedule View Creation
============================================
*/

-- Fixed Schedule View Input Table
@fixedTableExample = select
'AssetID' as [AssetID],
'2020-01-01T00:00:00+00:00' as [StartDate],
'2022-01-01T00:00:00+00:00' as [MaturityDate],
'GBP' as [Currency],
'3M' as [PaymentFrequency],
'ActAct' as [DayCountConvention],
'None' as [RollConvention],
'GBP' as [PaymentCalendars],
'GBP"]' as [ResetCalendars],
3 as [SettleDays],
0 as [ResetDays],
true as [LeapDaysIncluded],
1 as [Notional],
0.0123 as [CouponRate],
'GBP' as [PaymentCurrency],
'LongFront' as [StubType];

@createFixedScheduleJsonView =  use Sys.Admin.SetupView with @fixedTableExample
--provider=Schedules.Fixed_Schedule
--description="Outputs a table with two columns containing the asset ID and the formatted fixed schedule json"
--parameters
FixedTable,Table,@fixedTableExample,true
----

@fixedTable = select * from #PARAMETERVALUE(FixedTable);

select
ft.[AssetID],
json_object(
    'startDate', ft.[StartDate],
    'maturityDate', ft.[MaturityDate],
    'flowConventions', json_object(
        'currency', ft.[Currency],
        'paymentFrequency', ft.[PaymentFrequency],
        'dayCountConvention', ft.[DayCountConvention],
        'rollConvention', ft.[RollConvention],
        'paymentCalendars', json_array(ft.[PaymentCalendars]),
        'resetCalendars', json_array(ft.[ResetCalendars]),
        'settleDays', cast(ft.[SettleDays] as int),
        'resetDays', cast(ft.[ResetDays] as int),
        'leapDaysInclueded', ft.[LeapDaysIncluded]
    ),
    'notional', cast(ft.[Notional] as double),
    'couponRate', cast(ft.[CouponRate] as decimal),
    'paymentCurrency', ft.[PaymentCurrency],
    'stubType', ft.[StubType],
    'scheduleType', 'Fixed'
) as JsonString
from @fixedTable ft;

enduse;