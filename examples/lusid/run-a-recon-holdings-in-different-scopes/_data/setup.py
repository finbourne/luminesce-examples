# Import general modules
import logging
import os
import pathlib


import lusid_notifications
from fbnsdkutilities import ApiClientFactory
import lusid_notifications.models as ln_models
import json

# Import LUSID Drive modules
from lusid_drive.utilities import ApiClientFactory as DriveApiClientFactory

from runner import create_temp_folder, add_file_to_temp_folder

# Create loggers
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()

unique_folder_name = "recon-data-bootstrap"


def portfolio_setup_main(api_factory, data_dir):

    # Create a new temp folder
    logger.debug(f"Create a new folder: {unique_folder_name}")
    create_temp_folder(api_factory, unique_folder_name)

    for file in data_dir.iterdir():

        file_name = os.path.basename(file)

        if file_name.endswith(("csv", "xlsx")):

            logger.debug(f"Adding the following file to folder: {file}")

            add_file_to_temp_folder(api_factory, file, unique_folder_name)


def create_manual_email_subscription(scope, code):

    try:

        subs_api.create_subscription(

            create_subscription=ln_models.CreateSubscription(
                id=ln_models.ResourceId(scope=scope, code=code),
                display_name="Subscription for holdings rec result",
                description="Subscription for holdings rec result",
                status="Active",
                matching_pattern=ln_models.MatchingPattern(event_type="Manual",
                                                           filter=f"Message eq '{code}'"))
        )

    except lusid_notifications.ApiException as e:

        if json.loads(e.body)["code"] == 711:
            logging.debug( json.loads(e.body)["title"])


def notifications_setup():

    notification_scope = "ibor"
    notification_codes = ["HoldingReconFailed", "HoldingReconPassed"]

    for code in notification_codes:

        create_manual_email_subscription(scope=notification_scope, code=code)
        create_email_notification(scope=notification_scope, code=code)


def create_email_notification(scope, code):

    """
    IMPORTANT:
    This function is used to create Email notifications.
    We have disabled the function for CI/CD.
    To enable this function, add an email as a param under the
    CreateEmailNotification model
    """

    try:

        notifications_api.list_notifications(scope=scope, code=code)

    except:

        notifications_api.create_email_notification(
            scope=scope, code=code,
            create_email_notification=ln_models.CreateEmailNotification(

                description="Email for results of holding recon",
                subject=f"Holding reconcilation: {code}",
                plain_text_body=f"""
                Holdings reconcilation has finished with status {code}.
                Please see results in the following LUSID drive directory:
                <Enter LUSID Drive location here>
                """,
                email_address_to=["<EMAIL FOR NOTIFICATIONS>"] # IMPORTANT - update this email

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

    # Notifications API
    naf = ApiClientFactory(lusid_notifications, api_secrets_filename=secrets_file)
    subs_api = naf.build(lusid_notifications.api.SubscriptionsApi)
    notifications_api = naf.build(lusid_notifications.api.NotificationsApi)

    # Drive APIs
    api_factory = DriveApiClientFactory(api_secrets_filename=secrets_file)

    # Setup porfolio data in Drive
    portfolio_setup_main(api_factory, data_dir)

    # Create email notifications

    ### NOTE ###
    # Uncomment to run.
    # This will attempt to generate emails.

    #notifications_setup()

