# 1.1 Setup
import luminesce
import time
import string
import random

# 1.2 Imports
from luminesce.exceptions import ApiException
from luminesce import (
    ApiClientFactory,
    SqlBackgroundExecutionApi
)

# 1.3 Class setup


class Response:
    def __init__(self, response_body, error, should_retry):
        self.response_body = response_body
        self.error = error
        self.should_retry = should_retry

# 1.4 Method setup


async def call_and_handle_response(func, additional_error_handling={}, extended_wait=10, call_threshold=5, call_count=0,
                                   **kwargs):
    '''
    Handles a response from a call to a Luminesce SqlBackground API.

            Parameters:
                    func (kwargs -> BackgroundApiResponse): Api call to invoke
                    additional_error_handling (dict): any additional error handling for this api call
                    extended_wait (int): How long to wait if we were rate-limited
                    call_count (int): how many calls have been made to this api?
                    call_threshold (int): how many calls can be made to this api before we give up?
                    kwargs: to pass to func
            Returns:
                    Response object
    '''

    def handle_status_codes(additional_cases):
        async def on_unexpected_error(error):
            return Response(None, error, False)   # Or we can just `raise` here

        async def on_standard_error(error):
            print(f"{func} failed with code: {error.status}. Reason: {error.reason}")
            return Response(None, error, False)

        async def on_rate_limit(error):
            print(f"On func: {func} - rate limited - waiting: {extended_wait}s before retrying")
            time.sleep(extended_wait)
            return await call_and_handle_response(func, additional_error_handling, extended_wait, call_count + 1,
                                                  kwargs)

        standard_cases = {
            401: on_standard_error,
            403: on_standard_error,
            429: on_rate_limit
        }
        standard_cases.update(additional_cases)
        return lambda ex: standard_cases.get(ex.status, on_unexpected_error)

    async def handle_response(task, onException):
        try:
            task_result = await task
            return Response(task_result, None, False)
        except ApiException as e:
            return await onException(e)(e)

    print(f"On func: {func} - call number: {call_count}")
    if call_count >= call_threshold:
        return Response(None, ApiException(f"{func} exhausted retries ({call_threshold})"), False)

    thread = func(**kwargs)
    api_response_task = thread.get()
    # above, ApplyResult -> coroutine

    return await handle_response(api_response_task, handle_status_codes(additional_error_handling))


async def start_luminesce_background_query(api_instance, **kwargs):
    '''
    Start a Luminesce backgroundquery

            Parameters:
                    api_instance (SqlBackgroundExecutionApi): api client for sql background api
                    kwargs - args needed for the startquery api call
            Returns:
                    Response object
    '''

    async def on_parse_error(error):
        print(f"StartQuery - for query: {kwargs['query_name']} failed with a parse error")
        print(f"Details: {error.body}")
        return Response(None, error, False)

    error_cases_for_startquery = {
        400: on_parse_error
    }
    return await call_and_handle_response(api_instance.start_query_with_http_info,
                                          additional_error_handling=error_cases_for_startquery, **kwargs)


async def get_progress_of_luminesce_background_query(api_instance, longer_wait, **kwargs):
    '''
    Gets progress of a Luminesce backgroundquery

            Parameters:
                    api_instance (SqlBackgroundExecutionApi): api client for sql background api
                    longer_wait = if we are rate limited, how much longer to wait?
                    kwargs - args needed for the getprogress api call
            Returns:
                    Response object
    '''

    async def on_no_query(error):
        print(f"GetProgressOf - for query: {kwargs['execution_id']} failed with no query found")
        print(f"Details: {error.body}")
        return Response(None, error, False)

    error_cases_for_getprogressof = {
        404: on_no_query
    }
    return await call_and_handle_response(api_instance.get_progress_of_with_http_info,
                                          additional_error_handling=error_cases_for_getprogressof,
                                          extended_wait=longer_wait, **kwargs)


def should_retry_query(last_response):
    '''
    Should we retry a query based on the outcome of GetProgressOf?
    We want to retry in the case of infrastructure failures that we are able to tell about from GetProgressOf responses

        Parameters:
            last_response (ApiResponse body): tuple of the outcome of the last poll

        Returns:
            should_retry (bool): True if the query should be retried
    '''

    response_dict = last_response.data.to_dict()
    status_from_last_poll = response_dict['status'].value
    progress_from_last_poll = response_dict['progress']
    return status_from_last_poll == 'Faulted' and 'RETRIEVAL STOP POLLING' in progress_from_last_poll


def construct_execution_id():
    '''
    Generates a random execution id for the background query

    :return: (string) execution id to use
    '''
    def get_part(n):
        return ''.join(random.choices(string.hexdigits, k=n))

    separator = '-'
    parts = []

    parts.append(get_part(8))
    parts.append(get_part(4))
    parts.append(get_part(4))
    parts.append(get_part(4))
    parts.append(get_part(12))

    constructed_execution_id = separator.join(parts).lower()
    print(f"Running query with constructed execution id: {constructed_execution_id}")
    return constructed_execution_id


async def wait_for_background_query(
        api_instance,
        execution_id,
        delay_s_between_polls=7,
        longer_delay_s_between_polls=10):
    '''
    Wait for a Luminesce backgroundquery to complete

    Polls the GetProgressOf endpoint for as long as the query is in an incomplete 'WaitingForActivation' state.
    Uses the states provided by .NET themselves: https://learn.microsoft.com/en-us/dotnet/api/system.threading.tasks.taskstatus?view=net-6.0
    Will throw if forbidden/GetProgressOf itself fails

            Parameters:
                    api_instance (SqlBackgroundExecutionApi): api client for sql background api
                    execution_id (string): id of Luminesce query whose completion we are monitoring
                    delay_s_between_polls (int): time to wait between polling for progress of a query. Defaults: 2s
                    longer_delay_s_between_polls (int): if rate-limited, how long to wait before polling next. Defaults: 10s

            Returns:
                    Response object
    '''
    status = "WaitingForActivation"
    idx = 0
    progress = None
    while status == "WaitingForActivation":
        print(f"Polling progress of: {execution_id} - iteration: {idx}")
        progress = await get_progress_of_luminesce_background_query(
            api_instance,
            longer_wait=longer_delay_s_between_polls,
            execution_id=execution_id,
            async_req=True)

        if progress.response_body is None:
            return progress

        response_dict = progress.response_body.data.to_dict()
        status = response_dict['status'].value
        if not str(progress.response_body.status_code).startswith("2"):
            print(f"ODD STATUS: {status}")

        time.sleep(delay_s_between_polls)
        idx += 1

    if should_retry_query(progress.response_body):
        print(
            f"For query with execution id: {execution_id}, GetProgressOf suggests an infrastructure failure. Retrying...")
        progress.should_retry = True

    return progress


async def fetch_query_result(api_instance, last_progress, retry_if_undetermined=True, **kwargs):
    '''
    Returns the result of a Luminesce query as json.

        Parameters:
            api_instance (SqlBackgroundExecutionApi): background api instance
            last_progress - Response object, the last Response received from GetProgressOf
            retry_if_undetermined - if the status code is Gone - and we can't see the response body, should we retry the whole query?
            kwargs - needed for fetching query result

        Returns:
            Response object
    '''

    async def on_no_query(error):
        print(f"FetchQueryResult - for query: {kwargs['execution_id']} failed with no query found")
        print(f"Details: {error.body}")
        return Response(None, error, False)

    async def on_query_error(error):
        print(f"FetchQueryResult - for query: {kwargs['execution_id']} failed with an error in the query")
        print(f"Details: {error.body}")
        return Response(None, error, False)

    async def on_query_gone(error):
        print(
            f"FetchQueryResult - for query: {kwargs['execution_id']} - failed because response is gone. Retrying? {retry_if_undetermined}")
        print(f"Last progress state: {last_progress.response_body.data.to_dict()['status'].value}")
        return Response(None, error, retry_if_undetermined)

    error_cases_for_fetchqueryresult = {
        400: on_query_error,
        404: on_no_query,
        410: on_query_gone
    }

    return await call_and_handle_response(api_instance.fetch_query_result_json_proper,
                                          additional_error_handling=error_cases_for_fetchqueryresult, **kwargs)


async def run_luminesce_background_query(api_instance, get_sql_str, explicit_execution_id="", query_name="",
                                         max_retries=4, retry_count=0, polling_interval=2):
    '''
    Main orchestrating method for background query.
    Will call methods that start the query, poll for progress and fetch the result

    :param api_instance: (SqlBackgroundExecutionApi): background api instance
    :param get_sql_str: (Func[string]) Method that returns string of sql to be executed
    :param explicit_execution_id: (string) Execution id to use when starting the query
    :param query_name: (string) name of query, for finding in logs
    :param max_retries: (int) max number of retries allowed for this query. By default retries will happen on 410 GONE errors
    :param retry_count: (int) current number of retries that have been done for this query
    :param polling_interval: (int) how long to wait between polls of background query progress
    :return: (response body) result of background query
    '''
    def is_error(response):
        return response.should_retry or response.response_body is None

    async def handle_error(response):
        if response.should_retry:
            return await run_luminesce_background_query(api_instance, get_sql_str, query_name=query_name,
                                                        max_retries=max_retries, retry_count=retry_count + 1,
                                                        polling_interval=polling_interval)

        if response.response_body is None:
            return response.response_body

    if retry_count > max_retries:
        print(f"Reached max retries ({max_retries}) for query: {query_name}")
        return None

    # stage 1 - submit the query
    start_response = await start_luminesce_background_query(api_instance, body=get_sql_str(),
                                                            execution_id=explicit_execution_id, query_name=query_name,
                                                            async_req=True)

    if is_error(start_response):
        return await handle_error(start_response)

    # stage 2 - poll
    execution_id_in_use = start_response.response_body.data.to_dict()["executionId"]
    get_progress_of_response = await wait_for_background_query(api_instance, execution_id=execution_id_in_use,
                                                               delay_s_between_polls=polling_interval)

    if is_error(get_progress_of_response):
        return await handle_error(get_progress_of_response)

    # stage 3 - get result
    fetch_query_result_response = await fetch_query_result(api_instance, get_progress_of_response,
                                                           retry_if_undetermined=True, execution_id=execution_id_in_use,
                                                           async_req=True)

    if is_error(fetch_query_result_response):
        return await handle_error(fetch_query_result_response)

    return fetch_query_result_response.response_body

#############


async def main_runner(pre_run_func, main_orchestrator, sql_to_run, execution_id_to_use, query_name, interval):
    '''
    Call into this method to execute a background query.

    :param pre_run_func: (Func) A function that will call the main_orchestrator (and takes its args). Useful to mock actions like cancelling a query as it runs
    :param main_orchestrator: (Func) eg run_luminesce_background_query - what is responsible for starting/polling/getting result of background query
    :param sql_to_run: (Func[string]) - returns string of sql to be executed
    :param execution_id_to_use: (string) - execution id to start background query with
    :param query_name: (string) - name of query, for logging
    :param interval: (int) - seconds, how long to wait between background query polls
    :return: (response body) background query result
    '''
    api_client_factory = ApiClientFactory()
    # Enter a context with an instance of the ApiClientFactory to ensure the connection pool is closed after use
    async with api_client_factory:
        background_api_async_instance = api_client_factory.build(luminesce.SqlBackgroundExecutionApi)
        return await pre_run_func(main_orchestrator, sql_to_run, background_api_async_instance, execution_id_to_use, query_name, interval)


#############


async def pre_run_passthrough(runner, sql_to_run, api, execution_id_to_use, query_name, interval):
    '''
    For the straightforward case, just a pass through that calls runner with the args given
    '''
    return await runner(api, sql_to_run, explicit_execution_id=execution_id_to_use, query_name=query_name, polling_interval=interval)