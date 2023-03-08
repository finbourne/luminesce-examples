# Running valuations

In this section we use Luminesce to run a valuation on an equity portfolio. Specifically we cover the following:

1. Create the equity instruments (these are loaded from a worksheet in an Excel file which is stored in LUSID Drive)
2. Create a portfolio.
3. Upload quotes (also loaded from the same Excel file on Drive)
4. Upload transactions (also loaded from the same Excel file on Drive)
5. Run a valuation.
6. Upload external market value into Structured Result Store (loaded from csv file on Drive)
7. Run a valuation including both LUSID and External Market Value

See this [support page](https://support.lusid.com/knowledgebase/article/KA-01678/en-us) for more details on running valuations via the Luminesce Webtool.

## Source data

* We load prices, transaction and quotes from an Excel file on LUSID drive
* We load external valuations from a csv file on LUSID drive
* We use [Drive.Excel](https://support.lusid.com/knowledgebase/article/KA-01682/en-us) and [Drive.Csv](https://support.lusid.com/knowledgebase/article/KA-01680/) providers to load the data into Luminesce

## Implementation details

* The recipe used in the valuation is created in the `setup.py` file
* The SRS data map is also created in `setup.py` file
* By default, the valuation provider returns a row per instrument/metric. We then use the `pivot` provider to present the data in a more traditional tabular format.
