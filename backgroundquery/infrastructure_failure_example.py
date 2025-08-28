import background_query_setup as bqs
import asyncio

# ------

def get_sql_for_test_infrastructure_failure():
    return '''
pragma dryrun = true;
@a = select str from testing10 wait 180;
select * from tools.describe where todescribe = @a;
'''

# ------
# To run this example, you need to:
# Find out which querycoordinator (qc) pod is running the query, once it begins. Terminate that pod
# If the query is picked up by other qc's:
# Either let them finish the query (and you should see a successful result)
# Or terminate those pods too.
# (Intended to represent qc pods being reclaimed in short succession or a query being terminated after its ttl)
# Eventually the client app will consider this an infra failure and retry the query

execution_id = bqs.construct_execution_id()
result = asyncio.run(bqs.main_runner(bqs.pre_run_passthrough, bqs.run_luminesce_background_query, get_sql_for_test_infrastructure_failure, execution_id, query_name="ma_test", interval=2))
print(f"Query result: {result}")


# Expected result like:
# ...
# On func: <bound method SqlBackgroundExecutionApi.get_progress_of_with_http_info of <luminesce.api.sql_background_execution_api.SqlBackgroundExecutionApi object at 0x7f35bf3954d0>> - call number: 0
# Polling progress of: 0be6e153-532e-4a96-b95e-1c44f94db258 - iteration: 194
# On func: <bound method SqlBackgroundExecutionApi.get_progress_of_with_http_info of <luminesce.api.sql_background_execution_api.SqlBackgroundExecutionApi object at 0x7f35bf3954d0>> - call number: 0
# Polling progress of: 0be6e153-532e-4a96-b95e-1c44f94db258 - iteration: 195
# On func: <bound method SqlBackgroundExecutionApi.get_progress_of_with_http_info of <luminesce.api.sql_background_execution_api.SqlBackgroundExecutionApi object at 0x7f35bf3954d0>> - call number: 0
# For query with execution id: 0be6e153-532e-4a96-b95e-1c44f94db258, GetProgressOf suggests an infrastructure failure. Retrying...
# On func: <bound method SqlBackgroundExecutionApi.start_query_with_http_info of <luminesce.api.sql_background_execution_api.SqlBackgroundExecutionApi object at 0x7f35bf3954d0>> - call number: 0
# Polling progress of: a9bb2064-6713-496c-8a7c-7e8c08d06b8c - iteration: 0
# On func: <bound method SqlBackgroundExecutionApi.get_progress_of_with_http_info of <luminesce.api.sql_background_execution_api.SqlBackgroundExecutionApi object at 0x7f35bf3954d0>> - call number: 0
# Polling progress of: a9bb2064-6713-496c-8a7c-7e8c08d06b8c - iteration: 1
# On func: <bound method SqlBackgroundExecutionApi.get_progress_of_with_http_info of <luminesce.api.sql_background_execution_api.SqlBackgroundExecutionApi object at 0x7f35bf3954d0>> - call number: 0
# ...
# Polling progress of: a9bb2064-6713-496c-8a7c-7e8c08d06b8c - iteration: 91
# On func: <bound method SqlBackgroundExecutionApi.get_progress_of_with_http_info of <luminesce.api.sql_background_execution_api.SqlBackgroundExecutionApi object at 0x7f35bf3954d0>> - call number: 0
# On func: <bound method SqlBackgroundExecutionApi.fetch_query_result_json_proper of <luminesce.api.sql_background_execution_api.SqlBackgroundExecutionApi object at 0x7f35bf3954d0>> - call number: 0