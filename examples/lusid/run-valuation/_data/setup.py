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

def create_data_map_for_srs(api_factory):
    scope="ibor"
    srs_api = api_factory.build(lusid.api.StructuredResultDataApi)
    srs_data_map = models.DataMapping(
    data_definitions=[
        # Here we will define what data and key type each of the data fields are.
        # composite key         
        models.DataDefinition(address="UnitResult/Portfolio/Id", name="PortfolioCode", data_type="string", key_type="PartOfUnique"),
        models.DataDefinition(address="UnitResult/Portfolio/Scope", name="PortfolioScope", data_type="string", key_type="PartOfUnique"),
        models.DataDefinition(address="UnitResult/Instrument/default/LusidInstrumentId", name="InstrumentId", data_type="string", key_type="PartOfUnique"),
        models.DataDefinition(address="UnitResult/Holding/default/Currency", name="Currency", data_type="string", key_type="PartOfUnique"),

        # holding values         
        models.DataDefinition(address="UnitResult/External-MarketValue", name="External-MarketValue", data_type="decimal", key_type="Leaf"),
    ]
    )

    # Because the data maps are immutable, we must increase the version number each time we make any changes and upload a new version
    srs_data_map_key = models.DataMapKey(version="0.1.1", code="market-srs-valuation-map")

    # Once the map has been completed, we will create the data map in LUSID
    try:    
        srs_api.create_data_map(
            scope=scope, 
            request_body={
                "market-srs-valuation-map": models.CreateDataMapRequest(
                    id=srs_data_map_key,
                    data=srs_data_map
                )
            }
        )
    except lusid.ApiException as e:
        print(e.body)

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
            result_data_rules=[models.ResultDataKeyRule(
                resource_key="UnitResult/*",
                supplier="Client",
                data_scope=scope,
                document_code="MarketValuation",
                quote_interval="1D",
                document_result_type="UnitResult/Holding",
                result_key_rule_type="ResultDataKeyRule"
            )
        ],
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

    lusid_api_factory = LusidApiClientFactory(api_secrets_filename=secrets_file)

    create_recipe(lusid_api_factory)

    create_data_map_for_srs(lusid_api_factory)
