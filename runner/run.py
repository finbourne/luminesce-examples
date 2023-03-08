import subprocess
import argparse
from lumipy.client import Client
import os
import pathlib
import logging
import asynctest
import sys
from colorama import Fore
import time
import unittest
import io
from urllib3.connection import HTTPConnection
import socket
from lusid_drive.utilities import ApiClientFactory
from lusid_drive.utilities import ApiConfigurationLoader
from runner import lusid_drive_setup, teardown_folder
from pathlib import Path

# Create loggers
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()

TEST_DRIVE_FOLDER = "luminesce-examples"


class LuminesceRunnerTestHost(asynctest.TestCase):
    """
    Placeholder test case to add generated tests to
    """

    use_default_loop = True

    def run_query(self, lm_client, sql_statement):
        results_df = lm_client.query_and_fetch(sql_statement)
        self.assertGreater(len(results_df), 0)

    pass


class LuminesceRunner:
    """
    Main runner for running the tests. unittest TestCases are dynamically generated and added to LuminesceRunnerTestHost
    which runs them to ensure they complete without errors
    """

    def convert_luminesce_query(self, folder, filename, safe_name, secrets_file):
        """
        Takes an sql file and returns a function which executes the luminesce sql file via
        Lumipy https://pypi.org/project/dve-lumipy-preview/

        ----------
        folder : str
            Root folder to Luminesce sql files
        filename : str
            Sql file name
        safe_name : str
            Name of the test case, based on the sql file name
        secrets_file : str
            Path to api secrets file

        Returns
        -------
        Callable
            The generated test function
        """

        luminesce_query = os.path.join(folder, filename)

        lm_client = Client(api_secrets_filename=secrets_file)

        ####################################################
        #                                                  #
        #                  !!! IMPORTANT !!!               #
        #                                                  #
        # The lusid module import MUST be done locally     #
        # to ensure that the correct version is loaded if  #
        # one is specified. If the import is done outside  #
        # this function it will load the original one but  #
        # not reload the newer one even if using           #
        # importlib.reload(module)                         #
        #                                                  #
        ####################################################

        from lusid import ApiConfigurationLoader

        config = ApiConfigurationLoader.load(api_secrets_filename=secrets_file)

        if not config.api_url:
            logging.error(
                "missing api credentials, check the environment variables have been set"
            )
            sys.exit(1)

        cwd = os.getcwd()

        async def fn(self):

            logging.debug(f"loading luminesce query: {luminesce_query}")

            try:

                with open(f"{luminesce_query}") as file:
                    query = file.read()

                    logging.debug(f"opened luminesce query: {luminesce_query}")

                    # set a correlation id based on the name of the generated test, this is set as
                    # the FBN_CORRELATION_ID env var which is used by the SDK to set the header
                    corr_id = safe_name
                    os.environ["FBN_CORRELATION_ID"] = corr_id

                    # change to the working dir for the notebook being executed, this needs to be within the function
                    # so the correct folder is used when the function is executed
                    os.chdir(os.path.dirname(luminesce_query))

                    nb_log_info = f"{luminesce_query} correlationId: {Fore.CYAN}{corr_id}{Fore.RESET}"
                    start_time = time.perf_counter()

                    logging.debug(f"executing notebook: {luminesce_query}")

                    try:

                        # execute the notebook
                        self.run_query(lm_client, query)

                        end_time = time.perf_counter()
                        duration = f"{end_time - start_time:0.4f}s"
                        logging.info(
                            f"{nb_log_info} {Fore.GREEN}PASSED{Fore.RESET} ({duration})"
                        )

                    # catch and log any unhandled exceptions during the notebook execution
                    except Exception as ex0:
                        end_time = time.perf_counter()
                        duration = f"{end_time - start_time:0.4f}s"
                        logging.error(
                            f"{nb_log_info} {Fore.RED}FAILED{Fore.RESET} ({duration})"
                        )
                        logging.error(f"{luminesce_query}\n{ex0}")
                        raise

                    finally:
                        os.chdir(cwd)

                logging.debug(f"completed luminesce query: {luminesce_query}")

            # log any unexpected exceptions in the test runner
            except Exception as ex1:
                logging.error(ex1)
                raise

        return fn

    def run(self, source, secrets_file=None):
        """

        Parameters
        ----------
        source : str
            Root folder containing Luminesce sql files
        secrets_file : str, default=None
            Path to api secrets file

        Returns
        -------
        TestResult
            Result of executing the test case

        """
        logging.info(f"testing luminesce queries in {source}")

        test_funcs = []

        for file_path in Path(source).iterdir():

            file = os.path.basename(file_path)

            logging.debug(f"found {file}")

            if not file.endswith(".sql"):
                continue

            safe_name = file.replace(" ", "_").replace("-", "_")

            test = self.convert_luminesce_query(source, file, safe_name, secrets_file)

            # generate a test case from the converted notebook
            test_funcs.append((f"test_{safe_name}", test))

        # add the generated functions to the host
        for name, fn in test_funcs:
            setattr(LuminesceRunnerTestHost, name, fn)

        loader = unittest.TestLoader()
        suite = loader.loadTestsFromTestCase(LuminesceRunnerTestHost)

        # create a runner redirecting the output to an in-memory stream, this is
        # available with result.stream.getvalue() if needed
        runner = unittest.TextTestRunner(stream=io.StringIO())
        result = runner.run(suite)

        # remove the generated functions as they are preserved which
        # causes errors when running tests
        for name, fn in test_funcs:
            delattr(LuminesceRunnerTestHost, name)

        return result


def main():

    ap = argparse.ArgumentParser()
    ap.add_argument("-s", "--secrets", type=str, help="full path to json file")
    ap.add_argument("-d", "--start_dir", type=str, default="examples", help="starting directory of Luminesce files")
    ap.add_argument('--keepfiles', default=False, action=argparse.BooleanOptionalAction)
    args = ap.parse_args()

    starting_dir = args.start_dir
    secrets_file = args.secrets
    keep_files = args.keepfiles

    if secrets_file is not None:
        secrets_file = os.path.join(os.getcwd(), secrets_file)

    config = ApiConfigurationLoader.load(secrets_file)

    drive_api_factory = ApiClientFactory(token=config.api_token,
            drive_url=config.drive_url,
            api_secrets_filename=secrets_file)

    # TCP Keep Alive Probes for different platforms
    platform = sys.platform
    logging.info(f"PLATFORM: {platform}")
    # TCP Keep Alive Probes for Linux

    if platform == "linux":
        HTTPConnection.default_socket_options = (
            HTTPConnection.default_socket_options
            + [
                (socket.SOL_SOCKET, socket.SO_KEEPALIVE, 1),
                (socket.SOL_TCP, socket.TCP_KEEPIDLE, 45),
                (socket.SOL_TCP, socket.TCP_KEEPINTVL, 10),
                (socket.SOL_TCP, socket.TCP_KEEPCNT, 6),
            ]
        )

    # TCP Keep Alive Probes for Windows OS
    elif platform == "win32":

        HTTPConnection.default_socket_options = (
            HTTPConnection.default_socket_options
            + [
                (socket.SOL_SOCKET, socket.SO_KEEPALIVE, 1),
                (socket.SOL_TCP, socket.TCP_KEEPIDLE, 45),
                (socket.SOL_TCP, socket.TCP_KEEPINTVL, 10),
            ]
        )

    # TCP Keep Alive Probes for Mac OS
    elif platform == "darwin":

        HTTPConnection.default_socket_options = (
            HTTPConnection.default_socket_options
            + [
                (socket.SOL_SOCKET, socket.SO_KEEPALIVE, 1),
                (socket.SOL_TCP, socket.TCP_KEEPINTVL, 10),
            ]
        )

    runner = LuminesceRunner()

    start_time = time.perf_counter()

    source = Path(__file__).parent.parent.resolve().joinpath(starting_dir)

    failed_any = False
    all_tests_passed = 0
    all_tests_failed = 0
    all_tests_total = 0

    for root, dirs, files in os.walk(source):

        # Find directories with a "_data" sub directory
        # The parent directory of "_data" contains the sql files for testing
        dirs.sort()

        if len([i for i in files if i.endswith(".sql")]) > 0:

            testing_folder = os.path.basename(Path(root))
            logger_section_string = f"Starting tests in {testing_folder} directory"
            line_breaker = "=" * len(logger_section_string)

            logger.info(f"{Fore.YELLOW} {line_breaker}")
            logger.info(f"{Fore.YELLOW} {logger_section_string}")
            logger.info(f"{Fore.YELLOW} {line_breaker}")

            try:
                # If the folder contains a "_data" directory, then setup the test data
                duration = 0
                result = None

                data_dir = os.path.join(root, "_data")

                if os.path.exists(data_dir):

                    logger.info("Adding testing files to LUSID Drive")

                    upload_files_to_drive = lusid_drive_setup(
                        drive_api_factory, data_dir, TEST_DRIVE_FOLDER
                    )

                    full_setup_path = os.path.join(root, "_data", "setup.py")

                    if Path(full_setup_path) in list(Path(data_dir).iterdir()):

                        logger.info(f"Running setup file: {full_setup_path}")

                        process = subprocess.Popen(["python", f"{full_setup_path}"])

                # Get root path for SQL files
                sql_file_path = Path(root)

                # run the Luminesce fle tests
                result = runner.run(sql_file_path, secrets_file)

                end_time = time.perf_counter()
                duration = f"{end_time - start_time:0.4f}s"

            finally:
                if(result != None):
                    failed = len(result.errors)
                    passed = result.testsRun - failed
                else:
                    failed = 0
                    passed = 0

                all_tests_failed += failed
                all_tests_passed += passed
                all_tests_total += failed + passed

                logging.info(
                    f"{Fore.CYAN}{failed + passed} TOTAL, {Fore.GREEN}{passed} PASS, {Fore.RED}{failed} FAIL{Fore.RESET}, completed in {duration}"
                )

                if failed > 0:
                    failed_any = True

                if not keep_files:

                    # Teardown dependency data created for the tests
                    logger.info("Deleting testing files from LUSID Drive")

                    try:

                        teardown_folder(drive_api_factory, TEST_DRIVE_FOLDER)

                    except:

                        pass
                pass

    if failed_any:
        logging.error(
            f"{Fore.CYAN}{all_tests_total} TOTAL, {Fore.GREEN}{all_tests_passed} PASS, {Fore.RED}{all_tests_failed} FAIL{Fore.RESET}, completed in {duration}"
        )

        sys.exit(1)

    logging.info(
        f"{Fore.CYAN}{all_tests_total} TOTAL, {Fore.GREEN}{all_tests_passed} PASS, {Fore.RED}{all_tests_failed} FAIL{Fore.RESET}, completed in {duration}"
    )


if __name__ == "__main__":

    main()
