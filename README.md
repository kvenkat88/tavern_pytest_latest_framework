#### Framework Overview
 1. tavern-pytest API Automation and Integration automation test framework for evaluating the API services.
 2. This framework uses two of the most common framework available in python called Tavern(YAML based API test automation) and  Pytest(simplified and easy to use unit test plugin).
 3. By using generalized_runner.sh file we can perform bulk execution all test scenarios for all APIs available at a single point of time.

#### Requested Libraries for this framework and Installation
 1. Refer requirements.txt file available at root of the directory
 2. Use this command for installation, python -m pip3 install --upgrade --no-cache -r requirements.txt

#### Headers for other than local Environment URI
 1. Always include headers info in headers.env.
 2. During the runtime, headers would be automatically parsed and applied to HTTP Request function

#### Host Information mention for bulk/all web services test at single time
  1. Include local environment host info local_env_hosts.env in the format of notifications-host="http://localhost:5000"
  2. Include api_gateway environment host info api_gateway_env_hosts.env in the format of notifications-host="https:/some.domainname.com:5000"
  3. If you want to execute bulk tests for new environment say staging, then create a staging_env_hosts.env file and place the  host name instructions and issue the command with "staging" environment

#### Points to Remember
 1. Include or remove any environment or test related artifacts info in configs/env.yaml of the specific API test directory.
 2. Reusable yaml test stages are available in reusable_components/common.yaml of the specific API test directory.
 3. Add test helper/test utility functions under test_utilities/helpers.py of the specific API test directory.
 4. To add, modify and view pytest fixtures logic implemented, then refer tests/conftest.py of the specific API test directory.
 5. Test scenarios are categorized under positive and negative folders. Have to use and implement pytest marks for denoting smoke  and regression test scenarios.
 6. Test execution reports are available under hps-api-tavern-tests/reports/ directory.
 7. For our project setup in Linux/Jenkins,absoluete path should be mentioned in tavern-global-cfg section of pytest.ini config file (eg.API_Tier/tests/xxx/configs/env.yaml).For windows/local path in linux, we can simply use like configs/env.yaml of the specific API test directory.
 8. All of the tests are using the Tavern's Parameterization feature and if you want to add any tests for postive cases , simply include the test scenario name.

#### generalized_runner.sh CLI Commands

  ##### Bulk/Regression Tests Execution for all Web Services category available

      sh generalized_runner.sh EXEC_FOR bulk ENV_TYPE
                  or
      ./generalized_runner.sh EXEC_FOR bulk ENV_TYPE

      where EXEC_FOR holds values as all

      where ENV_NAME(accepted values are api_gateway, local)

  ##### Specific Directory Tests Execution for all Web Services category available

      sh run.sh EXEC_FOR specific_dir ENV_TYPE DIR_NAME
                  or
      ./run.sh EXEC_FOR specific_dir ENV_TYPE DIR_NAME

      where EXEC_FOR holds values as all

      where ENV_NAME(accepted values are api_gateway, local)

      where DIR_NAME accepts values like positive, negative

 ##### Invoke Tests Execution Command using Pytest Marks Utility (Use this mark to invoke Smoke/health check Tests) for all Web  Services category available

      sh run.sh EXEC_FOR marks ENV_TYPE MARK_NAME
                 or
      ./run.sh EXEC_FOR marks ENV_TYPE MARK_NAME

      where EXEC_FOR holds values as all

      where ENV_NAME(accepted values are api_gateway, local)

      where MARK_NAME accepts values like smoke, regression, health

 ##### Bulk/Regression Tests Execution for specific Web Services category

       sh generalized_runner.sh EXEC_FOR bulk HOST_IP ENV_TYPE
                   or
       ./generalized_runner.sh EXEC_FOR bulk HOST_IP ENV_TYPE

       where EXEC_FOR holds values as specific web services category name like risk-scores, p360 and provided name has to match with directory name available

       where HOST_IP holds values like http://localhost:5000

       where ENV_NAME(accepted values are api_gateway, local)

 ##### Specific Directory Tests Execution for specific Web Services category available

       sh run.sh EXEC_FOR specific_dir HOST_IP ENV_TYPE DIR_NAME
                   or
       ./run.sh EXEC_FOR specific_dir HOST_IP ENV_TYPE DIR_NAME

       where EXEC_FOR holds values as specific web services category name like risk-scores, p360 and provided name has to match with directory name available

       where HOST_IP holds values like http://localhost:5000

       where ENV_NAME(accepted values are api_gateway, local)

       where DIR_NAME accepts values like positive, negative

 ##### Invoke Tests Execution Command using Pytest Marks Utility (Use this mark to invoke Smoke/health check Tests) for specific Web  Services category available

       sh run.sh EXEC_FOR marks HOST_IP ENV_TYPE MARK_NAME
                   or
       ./run.sh EXEC_FOR marks HOST_IP ENV_TYPE MARK_NAME

       where EXEC_FOR holds values as specific web services category name like risk-scores, p360 and provided name has to match with directory name available

       where HOST_IP holds values like http://localhost:5000

       where ENV_NAME(accepted values are api_gateway, local)

       where MARK_NAME accepts values like smoke, regression, health
