import background_query_setup as bqs
import asyncio

# ------


def get_sql_for_test_happy():
    return '''
    pragma dryrun = true;
@a = select str from testing10 wait 30;
select * from tools.describe where todescribe = @a;'''

# --------


execution_id = bqs.construct_execution_id()
result = asyncio.run(bqs.main_runner(bqs.pre_run_passthrough, bqs.run_luminesce_background_query, get_sql_for_test_happy, execution_id, query_name="ma_test", interval=2))
print(f"Query result: {result}")


# Expected output like:
# On func: <bound method SqlBackgroundExecutionApi.get_progress_of_with_http_info of <luminesce.api.sql_background_execution_api.SqlBackgroundExecutionApi object at 0x10c628340>> - call number: 0
# Polling progress of: 5062d2f0-a68b-ff3d-4b6f-74c4f819a473 - iteration: 14
# On func: <bound method SqlBackgroundExecutionApi.get_progress_of_with_http_info of <luminesce.api.sql_background_execution_api.SqlBackgroundExecutionApi object at 0x10c628340>> - call number: 0
# Polling progress of: 5062d2f0-a68b-ff3d-4b6f-74c4f819a473 - iteration: 15
# On func: <bound method SqlBackgroundExecutionApi.get_progress_of_with_http_info of <luminesce.api.sql_background_execution_api.SqlBackgroundExecutionApi object at 0x10c628340>> - call number: 0
# On func: <bound method SqlBackgroundExecutionApi.fetch_query_result_json_proper of <luminesce.api.sql_background_execution_api.SqlBackgroundExecutionApi object at 0x10c628340>> - call number: 0
# Query result: [{'ColumnName': 'Something', 'DataType': 'Something'}]