### Notes to Remember::
1. Entrypoint for the docker run command is generalized_runner.sh file available in root directory.
2. Commands available in generalized_runner.sh file is applicable to docker run commands mentioned below.
3. Refer README.md file available in root directory for more info about command line arguments passing while performing tests.
4. To use other than local environment, we need headers(auth headers) for HTTP request processing, so update it in headers.env   file available. To parse from the python function inside of all our tests, headers.env has to be placed in root directory.
5. For bulk web services test cases execution(all web services at single go), have to create the file called <env_type>_env_hosts.env. For example, file for local environment is local_env_hosts.env
6. For example, hosts info available under the local_env_hosts.env should be created with <web service name>-host="http://localhost:5000"(example - drug-safety-host=http://localhost:8082) and like this all web services host information should be mentioned.

### Docker build image for Tavern REST API Tests
  `docker build --rm -t <aws_ecr_account_id>.dkr.ecr.us-east-2.amazonaws.com/testing/testflow:<tag_name> .`

### Docker Run Command(-d/daemon is not needed, since we will run this docker on demand basis)
##### Docker Run Command - Bulk regression test execution
  `docker run --rm -it -v $HOME/tavern_api_tests/reports:/usr/local/testflow/reports -v $HOME/tavern_api_tests/config/local_env_hosts.env:/usr/local/testflow/local_env_hosts.env --name testflow-api <aws_ecr_account_id>.dkr.ecr.us-east-2.amazonaws.com/testing/testflow:<tag_name> all bulk local
  `

  ` where all - represents script to fetch all test folders available
          bulk - represents perform regression test execution for the test folder available
          local - represents Local Environment/Localhost service
  `

  ` -v  $HOME/tavern_api_tests/reports:/usr/local/testflow/reports  - volume mount path for redirecting the report files from docker container to docker hosted machine
     where first part before : is path from host machine and part after is path for logs in docker container running.
  `

  ` -v $HOME/tavern_api_tests/config/local_env_hosts.env:/usr/local/testflow/local_env_hosts.env  - volume mount path for redirecting the files from docker container to docker hosted machine
     where first part before : is path from host machine and part after is path in docker container running. $HOME expansion is
     /home/{configured_linux_user}/tavern_api_tests/config. Inside of this path, .env would be available.
  `

  `Under the path - /home/{configured_linux_user}/tavern_api_tests/config of host machine, actual values of environment specific  host URLs are mapped.
    For example, drug-safety-host=http://localhost:8082 would be mapped in .env. Key name representation is from <web service name>-host
  `
##### Docker Run Command - Local Environment/Localhost bulk regression test execution for other env(say api_gateway)
    `docker run --rm -it -v $HOME/tavern_api_tests/reports:/usr/local/testflow/reports -v $HOME/tavern_api_tests/config/api_gateway_env_hosts.env:/usr/local/testflow/api_gateway_env_hosts.env -v $HOME/tavern_api_tests/config/headers.env:/usr/local/testflow/headers.env --name testflow-api <aws_ecr_account_id>.dkr.ecr.us-east-2.amazonaws.com/testing/testflow:<tag_name> all bulk api_gateway
    `

    ` where all - represents script to fetch all test folders available
            bulk - represents perform regression test execution for the test folder available
            api_gateway - represents api_gateway service or we can provide any other env
    `

##### Docker Run Command - Bulk regression test execution for specific folders
    `docker run --rm -it -v $HOME/tavern_api_tests/reports:/usr/local/testflow/reports -v $HOME/tavern_api_tests/config/local_env_hosts.env:/usr/local/testflow/local_env_hosts.env --name testflow-api <aws_ecr_account_id>.dkr.ecr.us-east-2.amazonaws.com/testing/testflow:<tag_name> all specific_dir local positive
    `

    ` where all - represents script to fetch all test folders available
            specific_dir - represents perform regression test execution for the test folder available
            local - represents api_gateway service or we can provide any other env. For other than local env, headers.env
                    and <env_type>_env_hosts.env file has to be provided using docker run -v flag
            positive - name of the test directory and you can give other directory which is available in test path
    `

##### Docker Run Command - Bulk regression test execution using pytest marks(using this to run smoke, health tests)
    `docker run --rm -it -v $HOME/tavern_api_tests/reports:/usr/local/testflow/reports -v $HOME/tavern_api_tests/config/local_env_hosts.env:/usr/local/testflow/local_env_hosts.env --name testflow-api <aws_ecr_account_id>.dkr.ecr.us-east-2.amazonaws.com/testing/testflow:<tag_name> all marks local smoke
    `

    ` where all - represents script to fetch all test folders available
            marks - pytest mark feature functionality
            local - represents api_gateway service or we can provide any other env. For other than local env, headers.env
                    and <env_type>_env_hosts.env file has to be provided using docker run -v flag
            smoke - smoke tests for the web services would be selected and you can give other mark names as regression, health
    `

##### Docker Run Command - Single Web Service regression test cases execution
  `docker run --rm -it -v $HOME/tavern_api_tests/reports:/usr/local/testflow/reports -v $HOME/tavern_api_tests/config/local_env_hosts.env:/usr/local/testflow/local_env_hosts.env --name testflow-api <aws_ecr_account_id>.dkr.ecr.us-east-2.amazonaws.com/testing/testflow:<tag_name> <web_service_type> bulk <host_ip> <env_type>
  `

  ` where web_service_type - name of the web services to test(for example, p360)
          bulk - represents perform regression test execution
          host_ip - holds values like http://localhost:5000
          env_type - represents env_type env or we can provide any other env. For other than local env, headers.env
                  and <env_type>_env_hosts.env file has to be provided using docker run -v flag
  `

##### Docker Run Command - Single Web Service regression test cases execution for specific folder available
  `docker run --rm -it -v $HOME/tavern_api_tests/reports:/usr/local/testflow/reports -v $HOME/tavern_api_tests/config/local_env_hosts.env:/usr/local/testflow/local_env_hosts.env --name testflow-api <aws_ecr_account_id>.dkr.ecr.us-east-2.amazonaws.com/testing/testflow:<tag_name> <web_service_type> specific_dir <host_ip> <env_type> <dir_name>
  `

  ` where web_service_type - name of the web services to test(for example, p360)
          specific_dir - represents perform regression test execution for the test folder available
          host_ip - holds values like http://localhost:5000
          env_type - represents env_type env or we can provide any other env. For other than local env, headers.env
                  and <env_type>_env_hosts.env file has to be provided using docker run -v flag
          dir_name - name of the test directory and you can give other directory which is available in test path
  `

##### Docker Run Command - Single Web Service regression test cases using pytest marks(using this to run smoke, health tests)
  `docker run --rm -it -v $HOME/tavern_api_tests/reports:/usr/local/testflow/reports -v $HOME/tavern_api_tests/config/local_env_hosts.env:/usr/local/testflow/local_env_hosts.env --name testflow-api <aws_ecr_account_id>.dkr.ecr.us-east-2.amazonaws.com/testing/testflow:<tag_name> <web_service_type> marks <host_ip> <env_type> <mark_name>
  `

  ` where web_service_type - name of the web services to test(for example, p360)
          marks - pytest mark feature functionality
          host_ip - holds values like http://localhost:5000
          env_type - represents env_type env or we can provide any other env. For other than local env, headers.env
                  and <env_type>_env_hosts.env file has to be provided using docker run -v flag
          mark_name - smoke tests for the web services would be selected if mark_name is set as smoke and you can give other mark names as regression, health
  `

### Remove docker container service running
  `docker container rm -f <docker_container_name>
  `
