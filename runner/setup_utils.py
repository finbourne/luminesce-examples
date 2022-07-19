import lusid_drive
import os
import json
import logging
from lusid_drive import models as models, ApiException, utilities
from pathlib import Path

# Create loggers
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()

from lusid_drive.utilities import ApiClientFactory


def create_temp_folder(api_factory, folder_name):

    folder_api = api_factory.build(lusid_drive.api.FoldersApi)

    try:

        folder_api.create_folder(models.CreateFolder(path="/", name=folder_name))

    except ApiException as e:
        if json.loads(e.body)["code"] == 664:

            # a folder with this name already exists in the path
            logger.debug(json.loads(e.body)["detail"])


def add_file_to_temp_folder(api_factory, file_path, folder_name):

    files_api = api_factory.build(lusid_drive.api.FilesApi)
    file_name = os.path.basename(file_path)

    try:

        with open(file_path, "rb") as data:

            response = files_api.create_file(
                x_lusid_drive_filename=file_name,
                x_lusid_drive_path=f"/{folder_name}",
                content_length=os.stat(file_path).st_size,
                body=data.read(),
            )

        if file_name not in response.name:
            reason = f"{file_name} not successfully created"
            logger.debug(reason)
            raise lusid_drive.exceptions.ApiException(reason=reason)

    except lusid_drive.exceptions.ApiException as e:
        if json.loads(e.body)["code"] == 671:
            # a file with this name already exists in the path
            logger.debug(json.loads(e.body)["detail"])


def delete_file(api_factory, file_name, folder_name):

    files_api = api_factory.build(lusid_drive.api.FilesApi)
    folder_id = utilities.get_folder_id(api_factory, folder_name)
    file_id = utilities.get_file_id(api_factory, file_name, folder_id)

    if file_id is not None:
        files_api.delete_file(file_id)


def teardown_folder(api_factory, unique_folder_name):

    folder_api = api_factory.build(lusid_drive.api.FoldersApi)

    root_contents = folder_api.get_root_folder().values

    root_id = [i.id for i in root_contents if i.name == unique_folder_name][0]

    logger.debug(f"Deleting file from: {unique_folder_name}")

    folder_api.delete_folder(root_id)


if __name__ == "__main__":

    secrets_file = Path(__file__).parent.joinpath("secrets.json").resolve()

    api_factory = ApiClientFactory(api_secrets_filename=secrets_file)

    teardown_folder(api_factory, "luminesce-examples")
