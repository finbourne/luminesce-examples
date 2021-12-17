from lumipy.client import Client
import os
import pathlib

secrets_file = os.getenv("FBN_SECRETS_PATH")
lm_client = Client(secrets_path=secrets_file)

def open_and_run_sql(sql_file_path):

    with open(sql_file_path) as sql_file:
        sql_statements = sql_file.read()

    results_df = lm_client.query_and_fetch(sql_statements)

    if len(results_df)>0:

        print(f"SQL file {os.path.basename(sql_file_path)} [PASSED]")


    else:
        assert False

def check_sql():

    current_path = pathlib.Path(__file__).parent.parent.resolve().joinpath("examples")

    print(current_path)

    # traverse root directory, and list directories as dirs and files as files  
    for root, dirs, files in os.walk(current_path):
        for file in files:
            print(file)
            if file.endswith(".sql"):

                full_path_sql_file = os.path.join(root, file)

                print(f"Checking sql file: {full_path_sql_file}")

                open_and_run_sql(full_path_sql_file)

if __name__ == "__main__":

    print("Starting SQL Luminesce tests...")

    check_sql()