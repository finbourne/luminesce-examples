import logging
from pathlib import Path

# Import LUSID Drive modules
from lusid_drive.utilities import ApiClientFactory

from runner import create_temp_folder, add_file_to_temp_folder

# Create loggers
logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger()


def upload_files_to_drive(api_factory, files_for_upload, unique_folder_name):

    for file in files_for_upload:

        logger.debug(f"Adding the following file to folder: {file}")

        add_files = add_file_to_temp_folder(api_factory, file, unique_folder_name)

    return add_files


def lusid_drive_setup(api_factory, source, unique_folder_name):

    create_folder = create_temp_folder(api_factory, unique_folder_name)

    files_for_upload = [
        file
        for file in Path(source).iterdir()
        if str(file).endswith((".csv", ".xlsx", ".txt", ".xml", ".pdf"))
    ]

    upload_files = upload_files_to_drive(
        api_factory, files_for_upload, unique_folder_name
    )

    return upload_files


if __name__ == "__main__":

    api_factory = ApiClientFactory(api_secrets_filename="secrets.json")

    source = Path(__file__).parent.parent.resolve().joinpath("examples")

    pass
