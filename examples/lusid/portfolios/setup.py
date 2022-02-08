# Import general modules
import json
import logging
import os
import pathlib

# Import LUSID Drive modules
import lusid_drive
from lusid_drive import models as models, ApiException
from lusid_drive.utilities import ApiClientFactory
from lusid_drive.utilities import ApiConfigurationLoader

# Import project files
from setup_config import UNIQUE_FOLDER_NAME

# Create loggers
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()


def create_temp_folder(api_factory, folder_name):

    folder_api = api_factory.build(lusid_drive.api.FoldersApi)

    try:

        folder_api.create_folder(models.CreateFolder(path="/", name=folder_name))

    except ApiException as e:
        if json.loads(e.body)["code"] == 664:

            # a folder with this name already exists in the path
            logger.info(json.loads(e.body)["detail"])


def add_file_to_temp_folder(api_factory, file_name, folder_name):

    files_api = api_factory.build(lusid_drive.api.FilesApi)

    data_dir_path = os.path.join(os.path.dirname(__file__), "data")
    local_file_path = os.path.join(data_dir_path, file_name)

    try:

        with open(local_file_path, "rb") as data:

            response = files_api.create_file(
                x_lusid_drive_filename=file_name,
                x_lusid_drive_path=f"/{folder_name}",
                content_length=os.stat(local_file_path).st_size,
                body=data.read(),
            )

        if file_name not in response.name:
            reason = f"{file_name} not successfully created"
            logger.info(reason)
            raise lusid_drive.exceptions.ApiException(reason=reason)

    except lusid_drive.exceptions.ApiException as e:
        if json.loads(e.body)["code"] == 671:
            # a file with this name already exists in the path
            logger.info(json.loads(e.body)["detail"])


def setup_main(api_factory):

    # Create a new temp folder
    unique_folder_name = UNIQUE_FOLDER_NAME
    data_dir = pathlib.Path(__file__).parent.joinpath("data").resolve()
    logger.info(f"Create a new folder: {unique_folder_name}")
    create_temp_folder(api_factory, unique_folder_name)

    # Add data files for testing to temp folder
    for root, dirs, files in os.walk(data_dir):

        for file in files:

            if file.endswith("csv"):

                logger.info(f"Adding the following file to folder: {file}")

                add_file_to_temp_folder(api_factory, str(file), unique_folder_name)


if __name__ == "__main__":

    # Create API factory
    secrets_file = (
        pathlib.Path(__file__)
        .parent.parent.parent.parent.joinpath("runner", "secrets.json")
        .resolve()
    )

    api_factory = ApiClientFactory(api_secrets_filename=secrets_file)

    setup_main(api_factory)
