# Uploading Complex Bonds

The complex bond provider takes a tabular input with columns for the core fields as well as a 'SchedulesJson' column.
This column and the data within it need to be created and formatted correctly in order to successfully define the bond 
schedules. 

## Front Stub Fixed Sinking Bond Example

In this complex bond example for a Front Stub Fixed Sinking Bond, 2 different schedule types are required (Fixed & Step). 
To achieve this, 2 views are set up to convert tabular data to the required schedules JSON.

## Data

The data file in this example is an Excel file with 2 tabs, one for the bond definition (bond-data) which is used 
to determine the core fields and fixed schedules and the other for the steps data (steps-data) which is used for the step 
schedules.

## Views ([Read more here](https://support.lusid.com/knowledgebase/article/KA-01767/en-us))

### 1. Fixed Schedule View

This view takes a single input of a formatted table with the below columns and returns a table with 2 columns: AssetID 
and JsonString.

#### Inputs
- FixedTable
  - AssetID
  - StartDate
  - MaturityDate
  - Currency
  - PaymentFrequency
  - DayCountConvention
  - RollConvention
  - PaymentCalendars
  - ResetCalendars
  - SettleDays
  - ResetDays
  - LeapDaysIncluded
  - Notional
  - CouponRate
  - PaymentCurrency
  - StubType

### 2. Step Schedule View

This view takes an input of 3 values and a formatted table with the below columns and returns a table with 2 columns: 
AssetID and JsonString.

#### Inputs
- LevelType
- StepScheduleType
- AssetFilter
- StepsTable
  - AssetID
  - Date
  - Quantity

## The Complex Bond Query

#### Before running the upload query: 

- The queries for the above views must be run in order to create them in the current environment.
- The data file must be saved to drive here: luminesce-examples/complex-bonds/ (these folders may need to be created).

### Overview

The complex bond provider takes a singular tabular input which is formatted from the extracted data. All but one of the 
columns are simply transformed/mapped from the extracted data, however, the 'SchedulesJson' column requires all 
necessary schedules to be formatted as a list of JSON.

In this load example, the core fields are transformed/mapped directly from the extracted data and the required schedules
are created through the views and added to the table in their own columns before being combined into the required 
'SchedulesJson' column.

### Data Formatting & Schedules

In the upload query, the data from the 2 Excel tabs is extracted into 2 temporary tables.

The core (non-schedule) fields are formatted into a table from the bond-data temp-table.

#### Fixed Schedules

The bonds are being uploaded with 2 fixed schedules to account for both front and back stubs.

The JSON for these 2 schedules is created through the fixed schedule view discussed above. The extracted bond data is 
transformed/mapped to the required view inputs and passed in. The formatted JSON schedule is then returned in one column
as well as an additional column for the AssetID so that the JSON can be linked back to the core asset fields.

The JSON columns of the 2 returned tables are appended to the core fields table with the names 'FixedScheduleJSONFront' 
and 'FixedScheduleJSONBack'.

#### Step Schedules

The bonds are also being uploaded with step schedules as they are sinking bonds.

The JSON for these step schedules is created through the step schedule view discussed above. As with the fixed schedules,
the extracted bond data is transformed/mapped to the required view inputs and passed in. The formatted JSON schedule is 
then returned in one column as well as an additional column for the AssetID so that the JSON can be linked back to the 
core asset fields.

The JSON column of the returned table is appended to the core fields table with the name 'StepScheduleJSON'.

The schedules in these 3 columns are then combined into a json array and saved to the required column called 
'SchedulesJson' in the table with the core fields.

The fully formatted table is then passed into the complex bond writer provider and the bonds are written into LUSID.







