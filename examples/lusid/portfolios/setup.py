
# Import general modules
import json
import logging
import os
import pathlib

# Import LUSID Drive modules
import lusid_drive
import lusid_drive.utilities.utility_functions as utilities
from lusid_drive import models as models, ApiException, FilesApi
from lusid_drive.utilities import ApiClientFactory
from lusid_drive.utilities import ApiConfigurationLoader

# Import project files
from setup_config import UNIQUE_FOLDER_NAME


def create_temp_folder(folder_name):

    try:

        folder_api.create_folder(models.CreateFolder(path="/", name=folder_name))

    except ApiException as e:
        if json.loads(e.body)["code"] == 664:

            # a folder with this name already exists in the path
            logger.info(json.loads(e.body)["detail"])


def add_file_to_temp_folder(file_name, folder_name):

    data_dir_path = os.path.join(os.path.dirname(__file__), "data")
    local_file_path = os.path.join(data_dir_path, file_name)

    try:
        response = files_api.create_file(
            x_lusid_drive_filename=file_name,
            x_lusid_drive_path=f"/{folder_name}",
            content_length=os.stat(local_file_path).st_size,
            body=local_file_path,
        )

        if file_name not in response.name:
            reason = f"{file_name} not successfully created"
            logger.info(reason)
            raise lusid_drive.exceptions.ApiException(reason=reason)

    except lusid_drive.exceptions.ApiException as e:
        if json.loads(e.body)["code"] == 671:
            # a file with this name already exists in the path
            logger.info(json.loads(e.body)["detail"])


if __name__ == "__main__":

    # Create loggers
    logging.basicConfig(level=logging.INFO)
    logger = logging.getLogger()
    
    # Create API factory
    secrets_file = os.getenv("FBN_SECRETS_PATH")
    config = ApiConfigurationLoader.load(api_secrets_filename=secrets_file)
    api_factory = ApiClientFactory(token=config.api_token, api_url=config.drive_url)

    # Initialise Folder and Files API
    folder_api = api_factory.build(lusid_drive.api.FoldersApi)
    files_api = api_factory.build(lusid_drive.api.FilesApi)

    unique_folder_name = UNIQUE_FOLDER_NAME
    data_dir = pathlib.Path(__file__).parent.joinpath("data").resolve()

    logger.info(f"Create a new folder: {unique_folder_name}")

    create_temp_folder(unique_folder_name)

    for root, dirs, files in os.walk(data_dir):
        for file in files:

            logger.info(f"Adding the following file to folder: {file}")

            add_file_to_temp_folder(str(file), unique_folder_name)

