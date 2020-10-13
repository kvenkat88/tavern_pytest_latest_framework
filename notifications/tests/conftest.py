#Refer the below mentioned link for goog docstring implementation
# https://sphinxcontrib-napoleon.readthedocs.io/en/latest/example_google.html

#pytest not recognising the path hence used the below line of sys path code
#https://chrisyeh96.github.io/2017/08/08/definitive-guide-python-imports.html
#https://stackoverflow.com/questions/10253826/path-issue-with-pytest-importerror-no-module-named-yadayadayada
#https://stackoverflow.com/questions/20971619/ensuring-py-test-includes-the-application-directory-in-sys-path

import logging
import pytest
import time
import json

import sys, os
myPath = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, myPath + '/../')

@pytest.fixture(name="time_request")
def fix_time_request():
    """
        Pytest fixture created to verify execution time. Final execution would be calculated by substracting stop - start and logging
        it to the pytest commandline/log file if provided

        Args:
            NA

        Returns:
            Log the time taken for test execution in seconds
    """
    t0= time.time()
    yield
    t1 = time.time()
    logging.info("Test took %s seconds", t1 - t0)

@pytest.fixture
def json_loader():
    """ Pytest Fixture to load data from JSON file

    Args:
        Outer function won't receive any information

    Returns:
        Returns the inner function(_loader) and it holds the loaded json data
    """
    def _loader(filename):
        """
            Function to validate and load the json file and return as fixture for later usage

            Args:
                filename (file object) : holds the necessary json filepath

            Returns:
                Returns the json file loaded and validated

        """
        with open(filename, 'r') as f:
            print(filename)
            data = json.load(f)
        return data

    return _loader


def pytest_configure(config):
  """
    Pytest hook to retrieve the metadata of tests using pytest-metadata plugin to use it in html test reports. It have the option to
    include the custom environment metadata information also.This metadata would be used while creating the html reports using pytest-html plugin.

    Args:
        config (_pytest.config.Config): Holds the config info for usage

    Returns:
        metadata information to use automatically with pytest-html plugin to create the environment info
  """
  config.addinivalue_line(
      "markers", "smoke: mark to run smoke test scripts"
  )

  config.addinivalue_line(
        "markers", "regression: mark to run regression test scripts"
  )

  config.addinivalue_line(
        "markers", "health: mark to run health check specific test scripts"
  )