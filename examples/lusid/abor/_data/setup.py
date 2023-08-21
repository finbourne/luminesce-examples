# Import general modules
import logging
import os
import pathlib
import lusid
import lusid.models as models
import json 

# Import LUSID Drive modules
from lusid_drive.utilities import ApiClientFactory as DriveApiClientFactory
from lusid.utilities import ApiClientFactory as LusidApiClientFactory

# from runner import create_temp_folder, add_file_to_temp_folder

# Create loggers
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()

def create_recipe(api_factory):

    recipes_api = api_factory.build(lusid.api.ConfigurationRecipeApi)

    scope="luminesce-examples"
    recipe_code="marketValue"

    configuration_recipe = models.ConfigurationRecipe(
    scope=scope,
    code=recipe_code,
    market=models.MarketContext(
        market_rules=[
            models.MarketDataKeyRule(
                key="Quote.ClientInternal.*",
                supplier="Lusid",
                data_scope=scope,
                quote_type="Price",
                field="mid",
                quote_interval="10D.0D",
            ),
            models.MarketDataKeyRule(
                key="FX.*.*",
                supplier="Lusid",
                data_scope=scope,
                quote_type="Rate",
                field="mid",
                quote_interval="10D.0D",
            ),
        ],
        suppliers=models.MarketContextSuppliers(
            commodity="Client",
            credit="Client",
            equity="Client",
            fx="Client",
            rates="Client",
        ),
        options=models.MarketOptions(
            default_supplier="Lusid",
            default_instrument_code_type="ClientInternal",
            default_scope=scope,
            attempt_to_infer_missing_fx=True,
        ),
    ),
    pricing=models.PricingContext(
        
        model_rules=[models.VendorModelRule(supplier="Lusid",
            model_name="SimpleStatic",
            instrument_type="Bond")]
       
        )
    )

    upsert_configuration_recipe_response = recipes_api.upsert_configuration_recipe(
        upsert_recipe_request=models.UpsertRecipeRequest(
            configuration_recipe=configuration_recipe
        )
    )

def create_txn_types(api_factory):

    system_configuration = api_factory.build(lusid.api.SystemConfigurationApi)

    try:

        create_txn_type = system_configuration.create_configuration_transaction_type(
            transaction_configuration_data_request=models.TransactionConfigurationDataRequest(
                aliases=[
                    models.TransactionConfigurationTypeAlias(
                        type="AborFundsIn",
                        description="Deposit New Funds",
                        transaction_class="CashTransfers",
                        transaction_group="default",
                        transaction_roles="Longer",
                    )
                ],
                movements=[
                    models.TransactionConfigurationMovementDataRequest(
                        movement_types="CashReceivable",
                        side="Side1",
                        direction=1,
                        movement_options=["Capital"],
                    )
                ],
            )
        )

    except lusid.ApiException as e:

        print(json.loads(e.body)["title"])
    
if __name__ == "__main__":

    data_dir = pathlib.Path(__file__).parent.resolve()

    # Create API factory
    secrets_file = (
        pathlib.Path(__file__)
        .parent.parent.parent.parent.parent.joinpath("runner", "secrets.json")
        .resolve()
    )

    lusid_api_factory = LusidApiClientFactory(api_secrets_filename=secrets_file)

    create_recipe(lusid_api_factory)
    create_txn_types(lusid_api_factory)