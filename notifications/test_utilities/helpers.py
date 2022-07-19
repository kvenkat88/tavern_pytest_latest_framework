 

import json

import os

import datetime

import yaml

from datetime import datetime

import re

import sys

import uuid

from box import Box

 

# Join the current working directory/project path, connect to configs directory and access the env.yaml file

configPath = os.path.abspath(os.path.join(os.path.dirname(__file__), '../configs'))

file_name_path = configPath + '/env.yaml'

 

def parse_env_file_to_dict():

    """

    Load the {env}.env file and provide it it as dict

    :param env: env as string. Example values are dev, local, prod, etc

    :return: vars_dict as dict

    """

    cur_path = os.path.abspath(os.path.dirname(__file__))

    file_path = os.path.join(cur_path, r"../../headers.env")

 

    with open(file_path, 'r') as fh:

        print("Env file path fetched is {}".format(file_path))

        vars_dict = dict(

            tuple(line.split('='))

            for line in fh.readlines() if not line.startswith('#')

        )

    # print("Parsed dict values are {}".format(vars_dict))

    return vars_dict

 

def generate_request_headers():

    """

    Generate the request headers based upon the parse_env_file_to_dict() ouput when headers.env file is passed

    :return: header_info as dict

    """

    # Set environment variables

    # os.environ['ENV_TYPE'] = 'api_gateway'

 

    auth_header = None

    if os.environ['ENV_TYPE'] == 'api_gateway':

        header_dict = parse_env_file_to_dict()

        auth_header = {key.strip(): value.strip() for key,value in header_dict.items()}

    else:

        auth_header = {"Accept": "application/json"}

 

    # print(Box(auth_header))

    return Box(auth_header)

 

def get_usa_date_format(days=0):

    """

    Fetch USA current day date as form of new date format based upon timedelta

    :param days: days in int

    :return: date object in formatted string

    """

    import datetime

    # Gives you PT time but don't know why IST time is not displayed

    return (datetime.datetime.now() + datetime.timedelta(days=days)).strftime("%m/%d/%Y %I:%m%p")

 

def return_uuid_create_for_patient_provider_id(from_,to,subject,body):

    """

        Utility function to create UUID4 value

        Returns:

            dict

    """

    framed_info = {

                    "PATIENT_ID": str(uuid.uuid4()),

                    "PROVIDER_ID": str(uuid.uuid4()),

                    "FROM": from_,

                    "TO": to,

                    "SUBJECT": subject,

                    "BODY": body

                  }

    print("Request JSON framed is {}\n".format(framed_info))

    return Box(framed_info)

 

def fetch_send_provider_request_data(response,prov_id,from1,to1,subject1,body1):

    """

    Fetch the send provider API request data

    Args:

        prov_id: pat_id as str

        from1: pat_id as str

        to1: pat_id as str

        subject1: pat_id as str

        body1: pat_id as str

    Returns: dict

    """

    fetched_info = {

                    "provider_id_created": prov_id,

                    "from_provided": from1,

                    "to_provided": to1,

                    "subject_provided": subject1,

                    "body_provided": body1

                  }

    return Box(fetched_info)

 

def fetch_send_provider_request_data1(response,prov_id,from1,to1,subject1,body1):

    """

    Fetch the send provider API request data

    Args:

        prov_id: pat_id as str

        from1: pat_id as str

        to1: pat_id as str

        subject1: pat_id as str

        body1: pat_id as str

    Returns: dict

    """

    fetched_info = {

                    "provider_id_created1": prov_id,

                    "from_provided1": from1,

                    "to_provided1": to1,

                    "subject_provided1": subject1,

                    "body_provided1": body1

                  }

    return Box(fetched_info)

 

def fetch_send_provider_request_data_multiple(response,prov_id,from1,to1,subject1,body1):

    """

    Fetch the send provider API request data

    Args:

        prov_id: pat_id as str

        from1: pat_id as str

        to1: pat_id as str

        subject1: pat_id as str

        body1: pat_id as str

    Returns: dict

    """

    fetched_list = []

    fetched_info = {

                    "provider_id_created": prov_id,

                    "from_provided": from1,

                    "to_provided": to1,

                    "subject_provided": subject1,

                    "body_provided": body1

                  }

    return Box({"final_resp_dict":fetched_list.append(fetched_info)})

 

def datetime_formatter():

 

    """

        Utility function to create the timestamp with string formatting. It would take current time as

        input and output formatted datetime text

 

        Args:

            NA

 

        Returns:

            Datetime stamp returned would be 01-07-2019 and represented in the html filename as "report_type1_diabetes_01-07-2019.html"

    """

    now = datetime.now()

    return now.strftime("%m-%d-%Y")

 

def assert_quick_response(response):

    """

    Make sure that a request doesn't take too long

 

    Args:

        response (json object): Interact with the response object of the API interacted

    Returns:

        True|False

    """

    print("Validating the performance of the stages available")

    assert response.elapsed < datetime.timedelta(seconds=20)

 

 

def save_response(response):

    """

        Utility function to fetch the API response and save it as json file in the current directory.

 

        Args:

            response (json object): Interact with the response object of the API interacted

 

        Returns:

            Create a api_resp.json file in the current working directory

    """

    filename = 'api_resp.json'

    with open(filename, 'w') as f:

        json.dump(response.json(), f)

 

 

def parse_yaml_file(file_name):

    """

        Utility function to parse the yaml file to fetch the config options

 

        Args:

            file_name (file object): yaml file for loading the data

 

        Returns:

            Return the loaded yaml file

    """

    yaml_file = None

    with open(file_name, 'r') as stream:

        try:

            yaml_file = yaml.load(stream, Loader=yaml.FullLoader)

        except yaml.YAMLError as exc:

            print(exc)

    return yaml_file

 

 

def fetch_env_type_from_environment_file():

    """

        Utility function to fetch the env types from environmenty.yaml file

 

        Args:

            NA

 

        Returns:

            Returns a env type info list

    """

    yaml_file_loaded = parse_yaml_file(file_name_path)

    final_env_type_retrieved = []

    for a in range(len(yaml_file_loaded['variables']['host']['env'])):

        final_env_type_retrieved.append(list(yaml_file_loaded['variables']['host']['env'][a].keys())[0])

    return final_env_type_retrieved

 

def retrieve_host_info_from_yaml_file(env):

    """

        Utility function to parse the yaml file based upon the env from env.yaml file

 

        Args:

            env (str): environment for testing

 

        Returns:

            Return ServerUrl

    """

    yaml_file_loaded = parse_yaml_file(file_name_path)

    returned_info = None

    # print(user_name)

    for a in range(len(yaml_file_loaded['variables']['host']['env'])):

        if env in yaml_file_loaded['variables']['host']['env'][a]:

            # returned_info =  yaml_file_loaded['variables']['host']['env'][a][env]['server_url']

            returned_info = yaml_file_loaded['variables']['host']['env'][a][env]

            break

    # print(returned_info)

    return returned_info

 

 

def validate_date(date_text):

    """

        Utility function to validate the date based upon the format provided

 

        Args:

            date_text (str): date_text as input

 

        Returns:

            True | False

    """

    import datetime

    date_format = datetime.datetime.strptime(date_text, '%Y-%m-%d')

    if date_format:

        return True

    else:

        return False

 

def retrieve_show_resp(response):

    """

        Utility function to retrieve and show response for api response validation

 

        Args:

            response (json object): response.json() from the api

 

        Returns:

            NA

    """

    print(

        "\n\n################################################################################### Response Retrieved from Tavern Test Stages###################################################################################")

    json_resp_fetched = json.dumps(response.json(), indent=4)

    print(json_resp_fetched)

    print(

        "\n\n################################################################################### Response Retrieved from Tavern Test Stages###################################################################################")

 

 

def retrieve_show_resp_api(response, from_api):

    """

         Utility function to retrieve and show response for api response validation

         Args:

             response (json object): response.json() from the api

             from_api (str): from_api - API name

         Returns:

             NA

     """

    print(

        "\n\n################################################################################### Start - Response Retrieved from Tavern Test Stages - {} ###################################################################################".format(from_api))

    json_resp_fetched = json.dumps(response.json(), indent=4)

    print(json_resp_fetched)

    print("\n\n################################################################################### End - Response Retrieved from Tavern Test Stages - {} ###################################################################################".format(from_api))

