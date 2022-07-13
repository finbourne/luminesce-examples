import logging
import pathlib

from lusid_drive.utilities import ApiClientFactory
from runner import teardown_folder
from examples.lusid.instruments._data.setup import unique_folder_name

# Create loggers
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()

if __name__ == "__main__":

    # Create API factory
    secrets_file = (
        pathlib.Path(__file__)
        .parent.parent.parent.parent.parent.joinpath("runner", "secrets.json")
        .resolve()
    )

    api_factory = ApiClientFactory(api_secrets_filename=secrets_file)
    teardown_folder(api_factory, unique_folder_name)

