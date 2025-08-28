import background_query_setup as bqs
import asyncio

# ------


def get_sql_for_test_unhappy():
    return '''
    pragma dryrun = true;
@a = select str from testing10 waiter 30;
select * from tools.describe where todescribe = @a;'''

# --------


execution_id = bqs.construct_execution_id()
result = asyncio.run(bqs.main_runner(bqs.pre_run_passthrough, bqs.run_luminesce_background_query, get_sql_for_test_unhappy, execution_id, query_name="ma_test", interval=2))
print(f"Query result: {result}")

# Expected output like:
# ...
# On func: <bound method SqlBackgroundExecutionApi.start_query_with_http_info of <luminesce.api.sql_background_execution_api.SqlBackgroundExecutionApi object at 0x108a31310>> - call number: 0
# StartQuery - for query: ma_test failed with a parse error
# ...
# Query result: None