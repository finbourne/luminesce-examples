# Import general modules
import logging
import os
import pathlib

# Import LUSID Drive modules
from lusid_drive.utilities import ApiClientFactory

from runner import create_temp_folder, add_file_to_temp_folder

# Create loggers
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()

unique_folder_name = "luminesce-temp-system-testing-folder"


def portfolio_setup_main(api_factory, data_dir):

    # Create a new temp folder
    logger.debug(f"Create a new folder: {unique_folder_name}")
    create_temp_folder(api_factory, unique_folder_name)

    for file in data_dir.iterdir():

        file_name = os.path.basename(file)

        if file_name.endswith(("csv", "txt")):

            logger.debug(f"Adding the following file to folder: {file}")

            add_file_to_temp_folder(api_factory, file, unique_folder_name)


if __name__ == "__main__":

    data_dir = pathlib.Path(__file__).parent.resolve()

    print(data_dir)

    # Create API factory
    secrets_file = (
        pathlib.Path(__file__)
        .parent.parent.parent.parent.joinpath("runner", "secrets.json")
        .resolve()
    )

    api_factory = ApiClientFactory(api_secrets_filename=secrets_file)

    portfolio_setup_main(api_factory, data_dir)