#### Framework Overview
 1. tavern-pytest API Automation and Integration automation test framework for evaluating the Notifications API's.
 2. This framework uses two of the most common framework available in python called Tavern(YAML based API test automation) and Pytest(simplified and easy to use unit test plugin).

#### Requested Libraries for this framework
 1. pytest
 2. tavern
 3. pytest-html
 4. pyyaml
 5. python-box

#### Points to Remember
 1. Include or remove any environment or test related artifacts info in configs/env.yaml.
 2. Reusable yaml test stages are available in reusable_components/common.yaml
 3. Add test helper/test utility functions under test_utilities/helpers.py
 4. To add, modify and view pytest fixtures logic implemented, then refer tests/conftest.py
 5. Test scenarios are categorized under positive and negative folders. Have to use and implement pytest marks for denoting smoke  and regression test scenarios.
 6. Test execution reports are available under hps-api-tavern-tests/reports/ directory(global) and inside the project directory reports/
 7. To invoke the test invocation for our project products , have to use pytest commands. Refer the below respected sections and jenkinsfile available for more information.
 8. For our project setup in Linux/Jenkins,absoluete path should be mentioned in tavern-global-cfg section of pytest.ini config file (eg.API_Tier/tests/eva/configs/env.yaml).For windows/local path in linux, we can simply use like configs/env.yaml.
 9. All of the tests are using the Tavern's Parameterization feature and if you want to add any tests for postive cases , simply include the test scenario name.

#### PyTest CLI(Command Line Interface)

  ##### Bulk Smoke Tests Command(using default tavern and pytest CLI(Command Line Interface)) by using default host info

        python -m pytest -vv --html=reports/smoke/report.html --self-contained-html -m smoke tests/smoke --env local_qa

        where HOST_IP and ENV_NAME(accepted values are api_gateway, local) are environment variables. This has to set using linux/windows export command before issuing above command

        where -m smoke flag would be utilized if smoke tag is mentioned inside the test scripts. We can trigger with or without -m flag

  ##### Specific test directory/folder Command(using default tavern and pytest CLI(Command Line Interface))
        python -m pytest -vv --html=reports/smoke/report.html --self-contained-html tests/smoke/<folder_name>

        where HOST_IP and ENV_NAME(accepted values are api_gateway, local) are environment variables. This has to set using linux/windows export command before issuing above command

  ##### Bulk Regression Tests Exceution Command(using default tavern and pytest CLI(Command Line Interface))

        python -m pytest -vv --html=reports/regression/report.html --self-contained-html tests/regression

        where HOST_IP and ENV_NAME(accepted values are api_gateway, local) are environment variables. This has to set using linux/windows export command before issuing above command

#### run.sh CLI Commands(Preferred)

  ##### Bulk/Regression Tests Execution Command

      sh run.sh bulk HOST_IP ENV_TYPE
                  or
      ./run.sh bulk HOST_IP ENV_TYPE

      where HOST_IP receives values like http://localhost:5000

      where ENV_NAME(accepted values are api_gateway, local)

  ##### Specific Directory Tests Execution Command

      sh run.sh specific_dir HOST_IP ENV_TYPE DIR_NAME
                  or
      ./run.sh specific_dir HOST_IP ENV_TYPE DIR_NAME

      where HOST_IP receives values like http://localhost:5000

      where ENV_NAME(accepted values are api_gateway, local)

      where DIR_NAME accepts values like positive, negative

 ##### Invoke Tests Execution Command using Pytest Marks Utility (Use this mark to invoke Smoke/health check Tests)

      sh run.sh marks HOST_IP ENV_TYPE MARK_NAME
                 or
      ./run.sh marks HOST_IP ENV_TYPE MARK_NAME

      where HOST_IP receives values like http://localhost:5000

      where ENV_NAME(accepted values are api_gateway, local)

      where MARK_NAME accepts values like smoke, regression, health
