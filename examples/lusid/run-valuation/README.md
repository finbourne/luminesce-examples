# Running valuations

In this section we use Luminesce to setup a portfolio for a simple valuation. Specifically we cover the following:

1. Create equity instruments. These are loaded from a worksheet in an Excel file on LUSID Drive.
2. Create a portfolio.
3. Upload quotes. These are also loaded from an Excel file on Drive.
4. Upload transactions.
5. Run a valuation.

## Source data

* We load prices, transaction and quotes from an Excel file on LUSID drive
* We use the []Drive.Excel](https://support.lusid.com/knowledgebase/article/KA-01682/en-us) provider to load the data into Luminesce

## Implementation details

* The recipe used in the valuation is created in the `setup.py` file
* By default, the valuation provider returns a row per instrument/metric. We use the `pivot` provider to present the data in a more traditional tabular format.
