import background_query_setup as bqs
import asyncio

# ------


def get_sql_for_test_unhappy_exception():
    return '''
@x = select [Takes500ms] from testing1k limit 40;
@@cnt = select count(*) from @x;
select * from testing10 where @@cnt > 0;'''

# --------


execution_id = bqs.construct_execution_id()
result = asyncio.run(bqs.main_runner(bqs.pre_run_passthrough, bqs.run_luminesce_background_query, get_sql_for_test_unhappy_exception, execution_id, query_name="ma_test", interval=2))
print(f"Query result: {result}")


# Expected output like:
# ...
# On func: <bound method SqlBackgroundExecutionApi.get_progress_of_with_http_info of <luminesce.api.sql_background_execution_api.SqlBackgroundExecutionApi object at 0x10fcbf340>> - call number: 0
# Polling progress of: b0ae71af-bda4-e2d0-7fdb-becd69daf0d9 - iteration: 11
# On func: <bound method SqlBackgroundExecutionApi.get_progress_of_with_http_info of <luminesce.api.sql_background_execution_api.SqlBackgroundExecutionApi object at 0x10fcbf340>> - call number: 0
# Polling progress of: b0ae71af-bda4-e2d0-7fdb-becd69daf0d9 - iteration: 12
# On func: <bound method SqlBackgroundExecutionApi.get_progress_of_with_http_info of <luminesce.api.sql_background_execution_api.SqlBackgroundExecutionApi object at 0x10fcbf340>> - call number: 0
# On func: <bound method SqlBackgroundExecutionApi.fetch_query_result_json_proper of <luminesce.api.sql_background_execution_api.SqlBackgroundExecutionApi object at 0x10fcbf340>> - call number: 0
# FetchQueryResult - for query: b0ae71af-bda4-e2d0-7fdb-becd69daf0d9 failed with an error in the query
# ...
# Query result: None