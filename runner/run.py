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
import subprocess
from urllib3.connection import HTTPConnection
import socket


lm_client = Client()

# Create loggers
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()


class LuminesceRunnerTestHost(asynctest.TestCase):
    """
    Placeholder test case to add generated tests to
    """

    use_default_loop = True

    def run_query(self, sql_statement):
        results_df = lm_client.query_and_fetch(sql_statement)
        self.assertTrue(len(results_df) > 0)

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
                        self.run_query(query)

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

                logging.debug(f"completed notebook: {luminesce_query}")

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

        for file_path in pathlib.Path(source).iterdir():

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


def run_data_teardown(root_dir, setup_teardown_file):
    """

    Parameters
    ----------
    root_dir : str
        Root folder containing a setup and teardown script
    setup_teardown_file : str
        The name of the script to execute - setup or teardown

    Returns
    -------
    Executes a setup or teardown python file

    """

    for root, dirs, files in os.walk(root_dir):

        if os.path.basename(root) == "_data":

            if setup_teardown_file in files:

                setup_teardown_file = os.path.join(root, setup_teardown_file)

                logger.info(f"Running setup file: {setup_teardown_file}")

                process = subprocess.Popen(["python", f"{setup_teardown_file}"])

                process.wait()


def main():

    # TCP Keep Alive Probes for different platforms
    platform = sys.platform
    # TCP Keep Alive Probes for Linux

    if platform == 'linux':
        HTTPConnection.default_socket_options = (
                HTTPConnection.default_socket_options + [
            (socket.SOL_SOCKET, socket.SO_KEEPALIVE, 1),
            (socket.SOL_TCP, socket.TCP_KEEPIDLE, 45),
            (socket.SOL_TCP, socket.TCP_KEEPINTVL, 10),
            (socket.SOL_TCP, socket.TCP_KEEPCNT, 6)
        ])

    # TCP Keep Alive Probes for Windows OS
    elif platform == 'win32':

        HTTPConnection.default_socket_options = (
                HTTPConnection.default_socket_options + [
            (socket.SOL_SOCKET, socket.SO_KEEPALIVE, 1),
            (socket.SOL_TCP, socket.TCP_KEEPIDLE, 45),
            (socket.SOL_TCP, socket.TCP_KEEPINTVL, 10),
        ])


    # TCP Keep Alive Probes for Mac OS
    elif platform == 'darwin':

        HTTPConnection.default_socket_options = (
                HTTPConnection.default_socket_options + [
            (socket.SOL_SOCKET, socket.SO_KEEPALIVE, 1),
            (socket.SOL_TCP, socket.TCP_KEEPINTVL, 10),
        ])

    runner = LuminesceRunner()

    start_time = time.perf_counter()

    source = pathlib.Path(__file__).parent.parent.resolve().joinpath("examples")

    for root, dirs, files in os.walk(source):

        # Find directories with a "_data" sub directory
        # The parent directory of "_data" contains the sql files for testing

        if os.path.basename(root) == "_data":

            testing_folder = os.path.basename(pathlib.Path(root).parent)

            logger.info(f"{Fore.YELLOW}===================================================", )
            logger.info(f"Starting tests in {testing_folder}...")
            logger.info(f"==================================================={Fore.RESET}")

            # Run the setup file in each sub-directory
            # This creates the dependency data for each Luminesce query

            try:

                run_data_teardown(root, "setup.py")

                # Move back one directory to find the Luminesce files
                sql_file_path = pathlib.Path(root).parent

                # run the Luminesce fle tests
                result = runner.run(sql_file_path, "secrets.json")

                end_time = time.perf_counter()
                duration = f"{end_time - start_time:0.4f}s"

                failed = len(result.errors)
                passed = result.testsRun - failed

                logging.info(
                    f"{Fore.CYAN}{result.testsRun} TOTAL, {Fore.GREEN}{passed} PASS, {Fore.RED}{failed} FAIL{Fore.RESET}, completed in {duration}"
                )

                if failed > 0:
                    sys.exit(1)

            finally:

                # Teardown dependency data created for the tests
                run_data_teardown(root, "teardown.py")


if __name__ == "__main__":

    main()
