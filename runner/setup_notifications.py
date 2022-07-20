# Import general modules
import logging
import os
import pathlib
from pathlib import Path


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

def create_manual_email_subscription(subs_api, scope, code):

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


def create_email_notification(notifications_api, scope, code):

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


def notifications_setup(secrets_file):

    # Notifications API
    naf = ApiClientFactory(lusid_notifications, api_secrets_filename=secrets_file)
    subs_api = naf.build(lusid_notifications.api.SubscriptionsApi)
    notifications_api = naf.build(lusid_notifications.api.NotificationsApi)

    # Drive APIs
    api_factory = DriveApiClientFactory(api_secrets_filename=secrets_file)

    notification_scope = "luminesce-examples"
    notification_codes = ["HoldingReconFailed", "HoldingReconPassed"]

    for code in notification_codes:

        create_manual_email_subscription(subs_api, scope=notification_scope, code=code)

        create_email_notification(notifications_api, scope=notification_scope, code=code)


if __name__ == "__main__":

    secrets_file = Path(__file__).parent.joinpath("secrets.json").resolve()

    notifications_setup("secrets.json")
