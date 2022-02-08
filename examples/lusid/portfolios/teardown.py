import logging
import os

import lusid_drive
import lusid_drive.utilities.utility_functions as utilities
from lusid_drive.utilities import ApiClientFactory
from lusid_drive.utilities import ApiConfigurationLoader

from setup_config import UNIQUE_FOLDER_NAME

# Create loggers
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()

unique_folder_name = UNIQUE_FOLDER_NAME


def delete_file(api_factory, file_name, folder_name):

    files_api = api_factory.build(lusid_drive.api.FilesApi)
    folder_id = utilities.get_folder_id(api_factory, folder_name)
    file_id = utilities.get_file_id(api_factory, file_name, folder_id)

    if file_id is not None:
        files_api.delete_file(file_id)


def teardown_main(api_factory):

    folder_api = api_factory.build(lusid_drive.api.FoldersApi)

    delete_file(api_factory, "test_123.txt", unique_folder_name)

    folder_id = utilities.get_folder_id(api_factory, unique_folder_name)

    logger.info(f"Deleting file from: {unique_folder_name}")

    folder_api.delete_folder(folder_id)


if __name__ == "__main__":

    # Create API factory
    secrets_file = os.getenv("FBN_SECRETS_PATH")
    api_factory = ApiClientFactory(api_secrets_filename=secrets_file)
    teardown_main(api_factory)
