from lumipy.client import Client
import os
import subprocess
import pathlib
import logging

lm_client = Client()

# Create loggers
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()


def open_and_run_sql(sql_file_path):

    with open(sql_file_path) as sql_file:
        sql_statements = sql_file.read()

    results_df = lm_client.query_and_fetch(sql_statements)

    if len(results_df) > 0:

        logger.info(f"SQL file {os.path.basename(sql_file_path)} [PASSED]")

    else:
        assert False


def check_sql():

    examples_path = pathlib.Path(__file__).parent.parent.resolve().joinpath("examples")

    # traverse root directory, and list directories as dirs and files as files
    for root, dirs, files in os.walk(examples_path):

        if "setup.py" in files:

            setup_file = os.path.join(root, "setup.py")

            logger.info(f"Running setup file: {setup_file}")

            subprocess.Popen(f"python {setup_file}")

        for file in files:

            if file.endswith(".sql"):

                full_path_sql_file = os.path.join(root, file)

                logger.info(f"Checking sql file: {full_path_sql_file}")

                open_and_run_sql(full_path_sql_file)

        if "teardown.py" in files:

            teardown_file = os.path.join(root, "teardown.py")

            logger.info(f"Running teardown file: {teardown_file}")

            subprocess.run(["python", f"{teardown_file}"])


if __name__ == "__main__":

    logger.info("Starting SQL Luminesce tests...")

    check_sql()
