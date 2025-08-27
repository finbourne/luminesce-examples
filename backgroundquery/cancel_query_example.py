import background_query_setup as bqs
import asyncio

# ------


async def cancel_query(api_instance, execution_id):
    '''
    Cancels a running Luminesce background query

        Parameters:
            api_instance (SqlBackgroundExecutionApi): background api instance
            execution_id (string): query id

        Returns
            result (BackgroundQueryCancelResponse): response to query cancellation
    '''
    thread = api_instance.cancel_query(execution_id = execution_id, async_req = True)
    return await thread.get()


def get_sql_for_test_unhappy_canceled():
    return '''
select [Takes500ms] from testing1k limit 240;
'''


async def call_and_cancel(runner, sql_to_run, api, execution_id_to_use, query_name, interval):
    task1 = asyncio.create_task(runner(api, sql_to_run, explicit_execution_id = execution_id_to_use, query_name = query_name, polling_interval = interval))

    task2 = asyncio.create_task(asyncio.sleep(20))
    print("Begun sleep before cancellation of query...")
    await task2
    print("Sleep before cancellation of query is over")
    await cancel_query(api, execution_id_to_use)

    return await task1

# --------

execution_id = bqs.construct_execution_id()
asyncio.run(bqs.main_runner(call_and_cancel, bqs.run_luminesce_background_query, get_sql_for_test_unhappy_canceled, execution_id, query_name="ma_test", interval=2))


