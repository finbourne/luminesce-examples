import lusid_drive
import os
import json
import logging
from lusid_drive import models as models, ApiException, utilities

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

    folder_id = utilities.get_folder_id(api_factory, unique_folder_name)

    logger.debug(f"Deleting file from: {unique_folder_name}")

    folder_api.delete_folder(folder_id)