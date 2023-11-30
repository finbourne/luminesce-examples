# Import general modules
import logging
import lusid
import lusid.models as models
import argparse

# Import LUSID Drive modules
from lusid.utilities import ApiClientFactory as LusidApiClientFactory
from lusidjam import RefreshingToken

# Create loggers
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()

def create_recipe(api_factory):
    recipes_api = api_factory.build(lusid.api.ConfigurationRecipeApi)

    scope = "luminesce-examples"
    recipe_code = "marketValue"

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
                    quote_interval="100D.0D",
                ),
                models.MarketDataKeyRule(
                    key="FX.*.*",
                    supplier="Lusid",
                    data_scope=scope,
                    quote_type="Rate",
                    field="mid",
                    quote_interval="100D.0D",
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
            model_rules=[
                models.VendorModelRule(
                    supplier="Lusid", model_name="SimpleStatic", instrument_type="Bond"
                )
            ]
        ),
    )

    upsert_configuration_recipe_response = recipes_api.upsert_configuration_recipe(
        upsert_recipe_request=models.UpsertRecipeRequest(
            configuration_recipe=configuration_recipe
        )
    )

    print(upsert_configuration_recipe_response)


def create_txn_types(api_factory):

    scope = "luminesce-examples"
    
    system_configuration = api_factory.build(lusid.api.SystemConfigurationApi)

    response = system_configuration.set_transaction_configuration_source(
        source="abor",
        set_transaction_configuration_source_request=[
            models.SetTransactionConfigurationSourceRequest(
                aliases=[
                    models.TransactionConfigurationTypeAlias(
                        type="FundsIn",
                        description="Deposit New Funds",
                        transaction_class="CashTransfers",
                        transaction_group="abor",
                        transaction_roles="Longer",
                    )
                ],
                movements=[
                    models.TransactionConfigurationMovementDataRequest(
                        name="Subscription",
                        movement_types="CashReceivable",
                        side="Side1",
                        direction=1,
                        movement_options=["Capital"],
                        mappings=[
                            models.TransactionPropertyMappingRequest(
                            property_key=f"Transaction/{scope}/CashType",
                            set_to="CashAtBank"
                        
                        )
                        ]
                    )
                ],
            ),
            models.SetTransactionConfigurationSourceRequest(
                aliases=[
                    models.TransactionConfigurationTypeAlias(
                        type="FundsOut",
                        description="Deposit New Funds",
                        transaction_class="CashTransfers",
                        transaction_group="abor",
                        transaction_roles="Shorter",
                    )
                ],
                movements=[
                    models.TransactionConfigurationMovementDataRequest(
                        name="Redemption",
                        movement_types="CashReceivable",
                        side="Side1",
                        direction=-1,
                        movement_options=["Capital"],
                        mappings=[
                            models.TransactionPropertyMappingRequest(
                            property_key=f"Transaction/{scope}/CashType",
                            set_to="CashAtBank"
                        
                        )]),
                
                ],
            ),
            models.SetTransactionConfigurationSourceRequest(
                aliases=[
                    models.TransactionConfigurationTypeAlias(
                        type="CashIn",
                        description="New cash into portfolio",
                        transaction_class="CashTransfers",
                        transaction_group="abor",
                        transaction_roles="Longer",
                    )
                ],
                movements=[
                    models.TransactionConfigurationMovementDataRequest(
                        name="CashIn",
                        movement_types="CashReceivable",
                        side="Side1",
                        direction=1
                    )
                ],
            ),
            models.SetTransactionConfigurationSourceRequest(
                aliases=[
                    models.TransactionConfigurationTypeAlias(
                        type="Buy",
                        description="Buy",
                        transaction_class="Buy",
                        transaction_group="abor",
                        transaction_roles="AllRoles",
                    )
                ],
                movements=[
                    models.TransactionConfigurationMovementDataRequest(
                        name="Bought",
                        movement_types="StockMovement",
                        side="Side1",
                        direction=1,
                        movement_options=[],
                        mappings=[
                            models.TransactionPropertyMappingRequest(
                            property_key=f"Transaction/{scope}/CashType",
                            set_to="NonCashInvestments"
                        
                        )]
                    ),
                    models.TransactionConfigurationMovementDataRequest(
                        name="CashInvested",
                        movement_types="CashCommitment",
                        side="Side2",
                        direction=-1,
                        movement_options=[],
                        mappings=[
                            models.TransactionPropertyMappingRequest(
                            property_key=f"Transaction/{scope}/CashType",
                            set_to="CashAtBank"
                        
                        )]
                        ,
                        
                        
                    ),
                ],
            ),
            models.SetTransactionConfigurationSourceRequest(
                aliases=[
                    models.TransactionConfigurationTypeAlias(
                        type="Sell",
                        description="Sell",
                        transaction_class="Sell",
                        transaction_group="abor",
                        transaction_roles="AllRoles",
                    )
                ],
                movements=[
                    models.TransactionConfigurationMovementDataRequest(
                        name="Sale",
                        movement_types="StockMovement",
                        side="Side1",
                        direction=-1,
                        movement_options=[],
                         mappings=[
                            models.TransactionPropertyMappingRequest(
                            property_key=f"Transaction/{scope}/CashType",
                            set_to="NonCashInvestments"
                        
                        )]
                    ),
                    models.TransactionConfigurationMovementDataRequest(
                        name="CashProceeds",
                        movement_types="CashCommitment",
                        side="Side2",
                        direction=1,
                        movement_options=[],
                        mappings=[
                            models.TransactionPropertyMappingRequest(
                            property_key=f"Transaction/{scope}/CashType",
                            set_to="CashAtBank"
                        
                        )]
                    ),
                ],
            ),
            models.SetTransactionConfigurationSourceRequest(
                aliases=[
                    models.TransactionConfigurationTypeAlias(
                        type="FxSpotBuy",
                        description="FxSpotBuy",
                        transaction_class="FxSpotBuy",
                        transaction_group="abor",
                        transaction_roles="AllRoles",
                    )
                ],
                movements=[
                    models.TransactionConfigurationMovementDataRequest(
                        name="FxSpotBuyLeg",
                        movement_types="CashCommitment",
                        side="Side1",
                        direction=1,
                        movement_options=[],
                        mappings=[
                            models.TransactionPropertyMappingRequest(
                            property_key=f"Transaction/{scope}/CashType",
                            set_to="CashAtBank"
                        
                        )]
                    ),
                    models.TransactionConfigurationMovementDataRequest(
                        name="FxSpotSellLeg",
                        movement_types="CashCommitment",
                        side="Side2",
                        direction=-1,
                        movement_options=[],
                        mappings=[
                            models.TransactionPropertyMappingRequest(
                            property_key=f"Transaction/{scope}/CashType",
                            set_to="CashAtBank"
                        
                        )]
                    ),
                ],
            ),
        ],
    )
    
    return response


if __name__ == "__main__":
    token = RefreshingToken()

    if token is not None:
        lusid_api_factory = LusidApiClientFactory(token=token)

    else:
        ap = argparse.ArgumentParser()
        ap.add_argument("-s", "--secrets", type=str, help="full path to json file")
        args = ap.parse_args()
        secrets_file = args.secrets
        lusid_api_factory = LusidApiClientFactory(api_secrets_filename=secrets_file)

    create_recipe(lusid_api_factory)
    create_txn_types(lusid_api_factory)