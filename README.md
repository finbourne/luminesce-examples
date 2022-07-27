# luminesce-examples (WIP)

This repo contains reference examples for Luminence.

This project is a WIP.

![image info](./logo/luminesce_logo.jpg)

| branch | status |
| --- | --- |
| `master` | [![Build and test](https://github.com/finbourne/luminesce-examples/actions/workflows/build-and-test.yml/badge.svg)](https://github.com/finbourne/luminesce-examples/actions/workflows/build-and-test.yml)|
| `master` | [![Daily build](https://github.com/finbourne/luminesce-examples/actions/workflows/daily-build.yml/badge.svg)](https://github.com/finbourne/luminesce-examples/actions/workflows/daily-build.yml)|

## List of examples

> INFO: The files are numbered if they should be run in order.

**Examples/lusid/run a reconciliation**
* [1 create transaction portfolio](examples/lusid/run-a-reconciliation/1-create-transaction-portfolio.sql)
* [2 create instruments](examples/lusid/run-a-reconciliation/2-create-instruments.sql)
* [5 run recon with notifications](examples/lusid/run-a-reconciliation/5-run-recon-with-notifications.sql)
* [4 create reconciliation view](examples/lusid/run-a-reconciliation/4-create-reconciliation-view.sql)
* [3 create holdings](examples/lusid/run-a-reconciliation/3-create-holdings.sql)

**Examples/lusid/portfolios**
* [Create reference portfolio](examples/lusid/portfolios/create-reference-portfolio.sql)
* [Create transaction portfolio](examples/lusid/portfolios/create-transaction-portfolio.sql)

**Examples/lusid/instruments**
* [Upload equity instruments](examples/lusid/instruments/upload-equity-instruments.sql)
* [Upload term deposit instruments](examples/lusid/instruments/upload-term-deposit-instruments.sql)

**Examples/lusid/properties**
* [Create properties from csv](examples/lusid/properties/create-properties-from-csv.sql)
* [Create instrument properties](examples/lusid/properties/create-instrument-properties.sql)

**Examples/lusid/run a recon holdings in different scopes**
* [2 create instruments](examples/lusid/run-a-recon-holdings-in-different-scopes/2-create-instruments.sql)
* [4 upload ibor holdings](examples/lusid/run-a-recon-holdings-in-different-scopes/4-upload-ibor-holdings.sql)
* [6 run recon workflow](examples/lusid/run-a-recon-holdings-in-different-scopes/6-run-recon-workflow.sql)
* [1 create transaction portfolios in two scopes](examples/lusid/run-a-recon-holdings-in-different-scopes/1-create-transaction-portfolios-in-two-scopes.sql)
* [5 create reconciliation view](examples/lusid/run-a-recon-holdings-in-different-scopes/5-create-reconciliation-view.sql)
* [3 upload abor transactions](examples/lusid/run-a-recon-holdings-in-different-scopes/3-upload-abor-transactions.sql)

**Examples/system**
* [Load one cell of data to table by delimiters](examples/system/load-one-cell-of-data-to-table-by-delimiters.sql)
* [Iif and case when statements](examples/system/iif-and-case-when-statements.sql)
* [Make properties available to luminesce](examples/system/make-properties-available-to-luminesce.sql)
* [Pivot data](examples/system/pivot-data.sql)
* [Error handling details to file](examples/system/error-handling-details-to-file.sql)

**Examples/system/for loops with cross apply**
* [Loop over csv file](examples/system/for-loops-with-cross-apply/loop-over-csv-file.sql)
* [Create instrument upsert view](examples/system/for-loops-with-cross-apply/create-instrument-upsert-view.sql)

**Examples/insights**
* [Count of requests per lusid method](examples/insights/count-of-requests-per-lusid-method.sql)

**Examples/view management**
* [4 delete a view](examples/view-management/4-delete-a-view.sql)
* [2 fetch sql used to create view](examples/view-management/2-fetch-sql-used-to-create-view.sql)
* [1 create view with no params](examples/view-management/1-create-view-with-no-params.sql)
* [3 current content of view](examples/view-management/3-current-content-of-view.sql)

**Examples/drive**
* [Create log file on error](examples/drive/create-log-file-on-error.sql)
* [Create and move file in drive](examples/drive/create-and-move-file-in-drive.sql)
* [Read a file from drive](examples/drive/read-a-file-from-drive.sql)
* [Save data into drive](examples/drive/save-data-into-drive.sql)
* [Read an excel file from drive](examples/drive/read-an-excel-file-from-drive.sql)


## Automated testing

We run automated tests on the SQL files in this project via GitHub Actions. The configurtion for these tests live in the `.github/workflows`
directory.

Many of our tests require setup data. To create this data, there is a process where the testing <b>runner</b>
will search for a `_data` directory wherever it finds `.sql` files. Then, two things happen:

1. If there are data files in the `_data` directory, the runner will upload these to a `luminesce-examples` folder in
LUSID Drive
2. If there is a `setup.py` file in this directory, the runner will run the `setup.py` file. We use this `setup.py`
file to configure recipes and other configurations we don't want to setup via Luminesce.

Sample structure below:

```
upload_equity_instruments.sql
upload_bond_instruments.sql
_data
    eq_instruments.csv
    instruments.txt
    setup.py
```


| :warning: This file is generated, any direct edits will be lost. For instructions on how to generate the file, see [docgen/README](../docgen/). |
| --- |