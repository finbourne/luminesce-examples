# luminesce-examples (WIP)

This repo contains reference examples for Luminence.

This project is a WIP.

![image info](./logo/luminesce_logo.jpg)

| branch | status |
| --- | --- |
| `master` | [![Build and test](https://github.com/finbourne/luminesce-examples/actions/workflows/build-and-test.yml/badge.svg)](https://github.com/finbourne/luminesce-examples/actions/workflows/build-and-test.yml)|
| `master` | [![Daily build](https://github.com/finbourne/luminesce-examples/actions/workflows/daily-build.yml/badge.svg)](https://github.com/finbourne/luminesce-examples/actions/workflows/daily-build.yml)|

## Run using Docker 

You can run with docker as follows.

Build the image:

```
docker build . -t luminesce-examples-runner
```

Run a container by passing auth credentials as environment variables:

```
docker run \
-e FBN_LUSID_API_URL=<API_URL> \
-e FBN_PASSWORD=<PASSWORD> \
-e FBN_APP_NAME=<APP_NAME> \
-e FBN_USERNAME=<USERNAME> \
-e FBN_CLIENT_SECRET=<CLIENT_SECRET> \
-e FBN_CLIENT_ID=<CLIENT_ID> \
-e FBN_TOKEN_URL=<TOKEN_URL> \
-e FBN_DRIVE_API_URL=<DRIVE_URL> \
-e FBN_LUMI_API_URL=<LUMI_URL> \
luminesce-examples-runner -start_dir=examples/drive
```

## Running locally

You can run one or more of these examples locally by using the `--secrets` and `--start_dir` parameters.

For example, to run the Drive examples only:

```
python runner/run.py --secrets=secrets/secrets.json --start_dir=examples/drive
```

You can also choose to keep the sample Drive files created by the runner:

```
python runner/run.py --secrets=secrets/secrets.json --start_dir=examples/drive --keepfiles
```

## List of examples

> 💡 The files in a directory are numbered if they need to be run in order 💡

**Properties**
* [Create instrument properties](examples/lusid/properties/create-instrument-properties.sql)
* [Create properties from csv](examples/lusid/properties/create-properties-from-csv.sql)

**Run a reconciliation**
* [1 create transaction portfolio](examples/lusid/run-a-reconciliation/1-create-transaction-portfolio.sql)
* [2 create instruments](examples/lusid/run-a-reconciliation/2-create-instruments.sql)
* [3 create holdings](examples/lusid/run-a-reconciliation/3-create-holdings.sql)
* [4 create reconciliation view](examples/lusid/run-a-reconciliation/4-create-reconciliation-view.sql)
* [5 run recon with notifications](examples/lusid/run-a-reconciliation/5-run-recon-with-notifications.sql)

**Run valuation**
* [1 create instruments](examples/lusid/run-valuation/1-create-instruments.sql)
* [2 create portfolio](examples/lusid/run-valuation/2-create-portfolio.sql)
* [3 upload quotes](examples/lusid/run-valuation/3-upload-quotes.sql)
* [4 upload transactions](examples/lusid/run-valuation/4-upload-transactions.sql)
* [5 run simple valuation](examples/lusid/run-valuation/5-run-simple-valuation.sql)
* [6 upload external valuations](examples/lusid/run-valuation/6-upload-external-valuations.sql)
* [7 run valuation with srs](examples/lusid/run-valuation/7-run-valuation-with-srs.sql)
* [Readme.md](examples/lusid/run-valuation/README.md)

**Instruments**
* [Query instruments](examples/lusid/instruments/query-instruments.sql)
* [Upload bond instruments](examples/lusid/instruments/upload-bond-instruments.sql)
* [Upload equity instruments](examples/lusid/instruments/upload-equity-instruments.sql)
* [Upload future instruments](examples/lusid/instruments/upload-future-instruments.sql)
* [Upload fx forward](examples/lusid/instruments/upload-fx-forward.sql)
* [Upload simple instruments](examples/lusid/instruments/upload-simple-instruments.sql)
* [Upload term deposit instruments](examples/lusid/instruments/upload-term-deposit-instruments.sql)

**Holdings**
* [1 create transaction portfolio](examples/lusid/holdings/1-create-transaction-portfolio.sql)
* [2 create instruments](examples/lusid/holdings/2-create-instruments.sql)
* [3 set holdings](examples/lusid/holdings/3-set-holdings.sql)
* [4 adjust holdings](examples/lusid/holdings/4-adjust-holdings.sql)
* [5 cancel holdings](examples/lusid/holdings/5-cancel-holdings.sql)

**Returns**
* [1 create transaction portfolio](examples/lusid/returns/1-create-transaction-portfolio.sql)
* [2 upload portfolio returns](examples/lusid/returns/2-upload-portfolio-returns.sql)
* [3 calculate aggregate returns](examples/lusid/returns/3-calculate-aggregate-returns.sql)

**Reference portfolios**
* [1 upload instruments](examples/lusid/reference-portfolios/1-upload-instruments.sql)
* [2 create reference portfolio](examples/lusid/reference-portfolios/2-create-reference-portfolio.sql)
* [3 upload constituents](examples/lusid/reference-portfolios/3-upload-constituents.sql)

**Relationships**
* [1 create properties](examples/lusid/relationships/1-create-properties.sql)
* [2 upsert instrument properties](examples/lusid/relationships/2-upsert-instrument-properties.sql)
* [3 create legal entities](examples/lusid/relationships/3-create-legal-entities.sql)
* [4 create portfolios](examples/lusid/relationships/4-create-portfolios.sql)
* [5 assign lei to portfolio](examples/lusid/relationships/5-assign-lei-to-portfolio.sql)
* [6 create relationship definition](examples/lusid/relationships/6-create-relationship-definition.sql)
* [7 call back custodians](examples/lusid/relationships/7-call-back-custodians.sql)

**Transactions**
* [Upload transactions from csv](examples/lusid/transactions/upload-transactions-from-csv.sql)
* [Upload transactions from excel](examples/lusid/transactions/upload-transactions-from-excel.sql)
* [Upload transactions from txt](examples/lusid/transactions/upload-transactions-from-txt.sql)
* [Upload transactions from xml](examples/lusid/transactions/upload-transactions-from-xml.sql)

**Portfolios**
* [Create transaction portfolio](examples/lusid/portfolios/create-transaction-portfolio.sql)

**Quotes**
* [Upload fx quotes](examples/lusid/quotes/upload-fx-quotes.sql)

**Run a recon holdings in different scopes**
* [1 create transaction portfolios in two scopes](examples/lusid/run-a-recon-holdings-in-different-scopes/1-create-transaction-portfolios-in-two-scopes.sql)
* [2 create instruments](examples/lusid/run-a-recon-holdings-in-different-scopes/2-create-instruments.sql)
* [3 upload abor transactions](examples/lusid/run-a-recon-holdings-in-different-scopes/3-upload-abor-transactions.sql)
* [4 upload ibor holdings](examples/lusid/run-a-recon-holdings-in-different-scopes/4-upload-ibor-holdings.sql)
* [5 create reconciliation view](examples/lusid/run-a-recon-holdings-in-different-scopes/5-create-reconciliation-view.sql)
* [6 run recon workflow](examples/lusid/run-a-recon-holdings-in-different-scopes/6-run-recon-workflow.sql)
* [7 run recon with generic reconciliation provider](examples/lusid/run-a-recon-holdings-in-different-scopes/7-run-recon-with-generic-reconciliation-provider.sql)

**Insights**
* [Count of requests per lusid method](examples/insights/count-of-requests-per-lusid-method.sql)

**Statistical functions**
* [Fuzzy search two files](examples/statistical-functions/fuzzy-search-two-files.sql)

**View management**
* [1 create view with no params](examples/view-management/1-create-view-with-no-params.sql)
* [2 fetch sql used to create view](examples/view-management/2-fetch-sql-used-to-create-view.sql)
* [3 current content of view](examples/view-management/3-current-content-of-view.sql)
* [4 delete a view](examples/view-management/4-delete-a-view.sql)

**Drive**
* [Create and move file in drive](examples/drive/create-and-move-file-in-drive.sql)
* [Create log file on error](examples/drive/create-log-file-on-error.sql)
* [Read a file from drive](examples/drive/read-a-file-from-drive.sql)
* [Read an excel file from drive](examples/drive/read-an-excel-file-from-drive.sql)
* [Save data into drive](examples/drive/save-data-into-drive.sql)

**Pdf generation**
* [1 load data from drive](examples/drive/pdf-generation/1-load-data-from-drive.sql)
* [2 generate pdf](examples/drive/pdf-generation/2-generate-pdf.sql)

**Check for missing instrument fields**
* [1 create instrument properties](examples/data-qc-checks/check-for-missing-instrument-fields/1-create-instrument-properties.sql)
* [2 load instruments into lusid](examples/data-qc-checks/check-for-missing-instrument-fields/2-load-instruments-into-lusid.sql)
* [3 check for missing instrument fields](examples/data-qc-checks/check-for-missing-instrument-fields/3-check-for-missing-instrument-fields.sql)

**Check for price outliers**
* [0 create instrument property definitions](examples/data-qc-checks/check-for-price-outliers/0-create-instrument-property-definitions.sql)
* [1 setup instruments with properties](examples/data-qc-checks/check-for-price-outliers/1-setup-instruments-with-properties.sql)
* [2 upload quotes](examples/data-qc-checks/check-for-price-outliers/2-upload-quotes.sql)
* [3 create iqr checker view](examples/data-qc-checks/check-for-price-outliers/3-create-iqr-checker-view.sql)
* [4 create price outlier view](examples/data-qc-checks/check-for-price-outliers/4-create-price-outlier-view.sql)
* [5 run price outlier view](examples/data-qc-checks/check-for-price-outliers/5-run-price-outlier-view.sql)

**System**
* [Append inline properties to system configuration](examples/system/append-inline-properties-to-system-configuration.sql)
* [Error handling details to file](examples/system/error-handling-details-to-file.sql)
* [Iif and case when statements](examples/system/iif-and-case-when-statements.sql)
* [Load one cell of data to table by delimiters](examples/system/load-one-cell-of-data-to-table-by-delimiters.sql)
* [Managing datetimes in luminesce](examples/system/managing-datetimes-in-luminesce.sql)
* [Pivot data](examples/system/pivot-data.sql)

**For loops with cross apply**
* [1 create instrument upsert view](examples/system/for-loops-with-cross-apply/1-create-instrument-upsert-view.sql)
* [2 loop over csv file](examples/system/for-loops-with-cross-apply/2-loop-over-csv-file.sql)


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


| :warning: This file is generated, any direct edits will be lost. For instructions on how to generate the file, see [docgen](docgen). |
| --- |
