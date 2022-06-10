# Import general modules
import logging
import os
import pathlib
import lusid
import lusid.models as models

# Import LUSID Drive modules
from lusid_drive.utilities import ApiClientFactory as DriveApiClientFactory
from lusid.utilities import ApiClientFactory as LusidApiClientFactory

from runner import create_temp_folder, add_file_to_temp_folder

# Create loggers
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()

unique_folder_name = "lumi-temp-val"


def portfolio_setup_main(api_factory, data_dir):

    # Create a new temp folder
    logger.debug(f"Create a new folder: {unique_folder_name}")
    create_temp_folder(api_factory, unique_folder_name)

    for file in data_dir.iterdir():

        file_name = os.path.basename(file)

        if file_name.endswith("xlsx"):

            logger.debug(f"Adding the following file to folder: {file}")

            add_file_to_temp_folder(api_factory, file, unique_folder_name)


def create_recipe(api_factory):

    recipes_api = api_factory.build(lusid.api.ConfigurationRecipeApi)

    scope="ibor"
    code="market-value"

    configuration_recipe = models.ConfigurationRecipe(
        scope=scope,
        code=code,
        market=models.MarketContext(
            market_rules=[
                # define how to resolve the quotes
                models.MarketDataKeyRule(
                    key="Quote.Figi.*",
                    supplier="Lusid",
                    data_scope=scope,
                    quote_type="Price",
                    field="mid",
                ),
            ],
            options=models.MarketOptions(
                default_supplier="Lusid",
                default_instrument_code_type="Isin",
                default_scope=scope,
            ),
        ),
        pricing=models.PricingContext(
            options={"AllowPartiallySuccessfulEvaluation": True},
        ),
    )

    upsert_configuration_recipe_response = recipes_api.upsert_configuration_recipe(
        upsert_recipe_request=models.UpsertRecipeRequest(
            configuration_recipe=configuration_recipe
        )
    )




if __name__ == "__main__":

    data_dir = pathlib.Path(__file__).parent.resolve()

    # Create API factory
    secrets_file = (
        pathlib.Path(__file__)
        .parent.parent.parent.parent.parent.joinpath("runner", "secrets.json")
        .resolve()
    )

    drive_api_factory = DriveApiClientFactory(api_secrets_filename=secrets_file)
    lusid_api_factory = LusidApiClientFactory(api_secrets_filename=secrets_file)

    portfolio_setup_main(drive_api_factory, data_dir)

    create_recipe(lusid_api_factory)
