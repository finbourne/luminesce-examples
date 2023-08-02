-- ============================================================
-- Description:
-- In this query, we run an ETL process on some complex bonds.
-- 1. First, we load an Excel file of complex bond data from Drive.
-- 2. Next, we transform the core data and create schedule json fields.
-- 3. Then we combine the schedules json fields into a single column.
-- 4. Finally we upload the instrument data into LUSID.
-- ============================================================

----------------------
-- Define constants --
----------------------

@@data = select 'fixed-stubs-sinking-bond.xlsx';
@@file = select 'luminesce-examples/complex-bonds';
@@levelType = select 'Absolute';
@@stepScheduleType = select 'Notional';
@@scope = select 'complexBondTesting';


--------------------------------
-- 1. Extract Instrument Data --
--------------------------------

-- Extract bond data from LUSID Drive

@extractCmplxBondAssetData = use Drive.Excel with @@data, @@file
--file={@@file}
--folderFilter={@@data}
--worksheet=bond-data
enduse;

-- Extract step schedule data from LUSID Drive

@extractCmplxBondStepsData = use Drive.Excel with @@data, @@file
--file={@@file}
--folderFilter={@@data}
--worksheet=steps-data
enduse;


---------------------------------
-- 2. Transform data using SQL --
---------------------------------

-- Transform core complex bond fields

@coreCmplxBondData = select
[Name] as [DisplayName],
[ISIN] as [Isin],
[AssetID] as [ClientInternal],
'Standard' as [CalculationType]
from @extractCmplxBondAssetData;

-- Transform front fixed schedule data

@formatFrontStubFixedScheduleData = select
[AssetID] as [AssetID],
[Interest Start Date] as [StartDate],
[First Coupon Date] as [Maturitydate],
[Currency] as [Currency],
[DCC] as [DayCountConvention],
[Payment Frequency] as [PaymentFrequency],
'None' as [RollConvention],
[Currency] as[PaymentCalendars],
[Currency] as [ResetCalendars],
[Settle Days] as [SettleDays],
0 as [ResetDays],
true as [LeapDaysIncluded],
[Notional] as [Notional],
[Coupon] as [CouponRate],
[Currency] as [PaymentCurrency],
[Front Stub Type] as [StubType]
from @extractCmplxBondAssetData;

-- Add front fixed schedule JSON fields to core fields

@addFrontStubSchedule = select d.*, d.ClientInternal, results.*
from @coreCmplxBondData d
outer apply (
    select JsonString as [FixedScheduleJSONFront] from Schedules.Fixed_schedule fs where
fs.AssetID = d.ClientInternal and fs.FixedTable = @formatFrontStubFixedScheduleData and d.ClientInternal = fs.AssetID
) results ;

-- Transform back fixed schedule data

@formatBackStubFixedScheduleData = select
[AssetID] as [AssetID],
[First Coupon Date] as [StartDate],
[Maturity Date] as [Maturitydate],
[Currency] as [Currency],
[DCC] as [DayCountConvention],
[Payment Frequency] as [PaymentFrequency],
'None' as [RollConvention],
[Currency] as[PaymentCalendars],
[Currency] as [ResetCalendars],
[Settle Days] as [SettleDays],
0 as [ResetDays],
true as [LeapDaysIncluded],
[Notional] as [Notional],
[Coupon] as [CouponRate],
[Currency] as [PaymentCurrency],
[Back Stub Type] as [StubType]
from @extractCmplxBondAssetData;

-- Add back fixed schedule JSON fields to core fields

@addBackStubSchedule = select d.*, d.ClientInternal, results.*
from @addFrontStubSchedule d
outer apply (
    select JsonString as [FixedScheduleJSONBack] from Schedules.Fixed_schedule fs where
fs.AssetID = d.ClientInternal and fs.FixedTable = @formatBackStubFixedScheduleData and d.ClientInternal = fs.AssetID
) results ;

-- Transform step schedule data

@formatStepScheduleData = select
[AssetID] as [AssetID],
[Date] as [Date],
[Value] as [Quantity]
from @extractCmplxBondStepsData;

-- Add step schedule JSON fields to core fields

@addStepSchedule = select d.*, d.ClientInternal, results.*
from @addBackStubSchedule d
outer apply (
    select JsonString as [StepScheduleJSON] from Schedules.Step_schedule ss where
ss.StepsTable = @formatStepScheduleData and ss.LevelType = @@levelType and ss.StepScheduleType = @@stepScheduleType and ss.AssetFilter = d.ClientInternal and d.ClientInternal = ss.AssetID
) results ;

-------------------------------
-- 3. Combine schedules JSON --
-------------------------------

-- Format full complex bond data with combined schedules list column

@complexBondDataToLoad = select
[DisplayName],
[Isin],
[ClientInternal],
[CalculationType],
json_array(
    json(FixedScheduleJSONFront), json(FixedScheduleJSONBack), json(StepScheduleJSON)
) as [SchedulesJson]
from @addStepSchedule;

-----------------------------------------
-- 4. Load formatted complex bond data --
-----------------------------------------

@load = select * from Lusid.Instrument.ComplexBond.Writer where
ToWrite = @complexBondDataToLoad;

select * from @load;
