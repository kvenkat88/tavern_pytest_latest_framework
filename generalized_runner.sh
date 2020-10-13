#!/bin/bash

E_BADARGS=85 #Wrong number of arguments passed to script.
SCRIPT=$0

USAGE="Use: $SCRIPT EXEC_FOR_APPLN [Options as all | notifications(web service name)]"
if [ $# -eq 0 ]; then
   echo $USAGE
   echo "Wromg number of arguments passed to script. Please give valid arguments to proceed!!!"
   exit $E_BADARGS
fi

echo "Before first shift command :::Command line arguments are $@"
EXEC_FOR_APPLN=$1
OPERATION=$2

shift
echo "After first shift command :::Command line arguments are $@"

directoryArray=( $(find . -type f -name "run.sh") )

if [ ${#directoryArray[@]} -ne 0 ]; then
	echo "Length of the directoryArray is ${#directoryArray[@]}"
	echo "Mapping these HOST_IP and ENV_TYPE values to environment variables"
	export EXEC_FOR=${EXEC_FOR_APPLN:-"all"} #Environmental variable

	if [[ "$EXEC_FOR" == "all" ]]; then
		USAGE="Use: $SCRIPT all|service_name bulk|specific_dir|marks [OPTIONS]"
		if [ "$#" -eq 0 ]; then
			echo "$USAGE"
			echo "Please provide option specific tests execution(bulk for all test scripts,specific_dir for specific directory tests and marks for pytest marked test scripts) for processing!!!"
			exit $E_BADARGS
		else
			echo "Before second shift command :::Command line arguments are $@"
			shift
			echo "After second shift command :::Command line arguments are $@"

      ENV_TYPE_FETCHED=$1
      export ENV_TYPE=${ENV_TYPE_FETCHED:-"local"} #Environmental variable

			if [ "$#" -eq 0 ]; then
				USAGE="Use: $SCRIPT all bulk|specific_dir|marks ENV_TYPE"
				echo "$USAGE"
				echo "Please provide ENV_TYPE value for processing!!!"
			else
				if [[ "$EXEC_FOR" == "all" ]]; then
					echo "Length of the directoryArray is ${#directoryArray[@]}"
					echo "Framing and executing the Pytest Test Scripts for all web services available......"
					for dir_name in ${directoryArray[@]}; do
						# Navigating to specific directory
            dotted_dir_name=$(dirname $dir_name)
						cd $(dirname $dir_name)
            echo "Running PyTest tests for ${dotted_dir_name:2} Web Services, ${ENV_TYPE}"
            host_info_from_env_file=$(grep "${dotted_dir_name:2}"-host "../${ENV_TYPE}"_env_hosts.env | cut -d '=' -f2)
            export HOST_IP=${host_info_from_env_file} #Environmental variable
            echo "Running tests for ${ENV_TYPE} environment with hostname - $host_info_from_env_file"
						if [[ $(dirname $dir_name) == "./insurance_card" ]]; then
							if [[ $OPERATION == "bulk" ]]; then
								echo "Framing and executing the RobotFramework Regression Test Scripts for bulk test execution......"
								CMD="python -m robot --name Regression_Insurance_Card_API --variable HOST_INFO:$host_info_from_env_file --report InsuranceCard_API_Regression_Test_Report-$(date +'%m_%d_%Y').html --log InsuranceCard_API_Regression_Test_Log-$(date +'%m_%d_%Y').html -d ../reports/insurance_card/regression ./tests/regression"
								echo "Command passed for execution is $CMD"
								$CMD
							else
								echo "Framing and executing the RobotFramework Smoke Test Scripts for bulk test execution......"
								CMD="python -m robot --name Smoke_Insurance_Card_API --variable HOST_INFO:$host_info_from_env_file --report InsuranceCard_API_Smoke_Test_Report-$(date +'%m_%d_%Y').html --log InsuranceCard_API_Smoke_Test_Log-$(date +'%m_%d_%Y').html -d ../reports/insurance_card/smoke ./tests/smoke"
								echo "Command passed for execution is $CMD"
								$CMD
							fi
						else
							if [[ $OPERATION == "bulk" ]]; then
								echo "Framing and executing the Pytest Test Scripts for bulk test execution for $(dirname $dir_name) ......"
								CMD="python -m pytest --cache-clear -vv --metadata Host_Name $host_info_from_env_file --html=../reports/$(dirname $dir_name)-API-TestReports-$(date +'%m_%d_%Y').html --self-contained-html tests/"
								echo "Command passed for execution is $CMD"
								$CMD
							fi

							if [[ $OPERATION == "specific_dir" ]]; then
								if [[ -n "$2" ]]; then
									echo "Framing and executing the Pytest Test Scripts for specific directory test execution for $(dirname $dir_name)......"
									CMD="python -m pytest --cache-clear -vv --metadata Host_Name $host_info_from_env_file --html=../reports/$(dirname $dir_name)-API-TestReports-$2-directory-$(date +'%m_%d_%Y').html --self-contained-html tests/$2"
									echo "Command passed for execution is $CMD"
									$CMD
								else
									echo "Value provided is $2"
									echo "Please provide a specific directory name !!!"
									exit $E_BADARGS
								fi
							fi

							if [[ $OPERATION == "marks" ]]; then
								if [[ -n "$2" ]]; then
									echo "Framing and executing the Pytest Test Scripts with marks for bulk test execution for $(dirname $dir_name)......"
									CMD="python -m pytest --cache-clear -vv --metadata Host_Name $host_info_from_env_file --html=../reports/$(dirname $dir_name)-API-TestReports-$2-marks-$(date +'%m_%d_%Y').html --self-contained-html -m $2 tests/"
									echo "Command passed for execution is $CMD"
									$CMD
								else
									echo "Value provided is $2"
									echo 'Please provide a pytest marker info like "smoke|regression" !!!'
									exit $E_BADARGS
								fi
							fi

							# Come out of the directory
							cd ..
						fi
					done
				else
					echo "Please provide valid value for EXEC_FOR as all and actual value provided is $EXEC_FOR"
					exit $E_BADARGS
				fi
			fi
		fi

	elif [[ $(find . -type d -name "$EXEC_FOR") == "./$EXEC_FOR" ]]; then
		echo "I am here at specific web serive name part execution"

		USAGE="Use: $SCRIPT service_name bulk|specific_dir|marks [OPTIONS]"
		if [ "$#" -eq 0 ]; then
			echo "$USAGE"
			echo "Please provide option specific tests execution(bulk for all test scripts,specific_dir for specific directory tests and marks for pytest marked test scripts) for processing!!!"
			exit $E_BADARGS
		else
			echo "Before second shift command :::Command line arguments are $@"
			shift
			echo "After second shift command :::Command line arguments are $@"

			if [ "$#" -eq 0 ]; then
				USAGE="Use: $SCRIPT service_name bulk|specific_dir|marks HOST_IP ENV_TYPE"
				echo "$USAGE"
				echo "Please provide HOST_IP and ENV_TYPE values for processing!!!"
			else

        # Host IP env variable is only for Specific web services tests execution
        HOST_IP_FETCHED=$1
        export HOST_IP=${HOST_IP_FETCHED:-"http://localhost:5003"} #Environmental variable
        ENV_TYPE_FETCHED=$2
        export ENV_TYPE=${ENV_TYPE_FETCHED:-"local"} #Environmental variable

				if [[ "$EXEC_FOR" == "insurance_card" ]]; then
					if [[ $OPERATION == "bulk" ]]; then
						cd "$EXEC_FOR"
						echo "Framing and executing the RobotFramework Regression Test Scripts for bulk test execution for $EXEC_FOR......"
						CMD="python -m robot --name Regression_Insurance_Card_API --variable HOST_INFO:$HOST_IP --report InsuranceCard_API_Regression_Test_Report-$(date +'%m_%d_%Y').html --log InsuranceCard_API_Regression_Test_Log-$(date +'%m_%d_%Y').html -d ../reports/insurance_card_reports/regression ./tests/regression"
						echo "Command passed for execution is $CMD"
						$CMD
						cd ..
					else
						echo "Framing and executing the RobotFramework Smoke Test Scripts for bulk test execution for $EXEC_FOR......"
						CMD="python -m robot --name Smoke_Insurance_Card_API --variable HOST_INFO:$HOST_IP --report InsuranceCard_API_Smoke_Test_Report-$(date +'%m_%d_%Y').html --log InsuranceCard_API_Smoke_Test_Log-$(date +'%m_%d_%Y').html -d ../reports/insurance_card_reports/smoke ./tests/smoke"
						echo "Command passed for execution is $CMD"
						cd "$EXEC_FOR"
						$CMD
						cd ..
					fi
				else
					if [[ $OPERATION == "bulk" ]]; then
						cd "$EXEC_FOR"
						echo "Framing and executing the Pytest Test Scripts for bulk test execution for $EXEC_FOR ......"
						CMD="python -m pytest --cache-clear -vv --metadata Host_Name $HOST_IP --html=../reports/"$EXEC_FOR"-API-TestReports-$(date +'%m_%d_%Y').html --self-contained-html tests"
						echo "Command passed for execution is $CMD"
						$CMD
						cd ..
					fi

					if [[ $OPERATION == "specific_dir" ]]; then
						if [[ -n "$3" ]]; then
							cd "$EXEC_FOR"
							echo "Framing and executing the Pytest Test Scripts for specific directory test execution for $EXEC_FOR......"
							CMD="python -m pytest --cache-clear -vv --metadata Host_Name $HOST_IP --html=../reports/"$EXEC_FOR"-API-TestReports-$3-directory-$(date +'%m_%d_%Y').html --self-contained-html tests/$3"
							echo "Command passed for execution is $CMD"
							$CMD
							cd ..
						else
							echo "Value provided is $3"
							echo "Please provide a specific directory name !!!"
							exit $E_BADARGS
						fi
					fi

					if [[ $OPERATION == "marks" ]]; then
						if [[ -n "$3" ]]; then
							cd "$EXEC_FOR"
							echo "Framing and executing the Pytest Test Scripts with marks for bulk test execution for $EXEC_FOR......"
							CMD="python -m pytest --cache-clear -vv --metadata Host_Name $HOST_IP --html=../reports/"$EXEC_FOR"-API-TestReports-$3-marks-$(date +'%m_%d_%Y').html --self-contained-html -m $3 tests/"
							echo "Command passed for execution is $CMD"
							$CMD
							cd ..
						else
							echo "Value provided is $3"
							echo 'Please provide a pytest marker info like "smoke|regression" !!!'
							exit $E_BADARGS
						fi
					fi
				fi
			fi
		fi
	else
		echo "EXEC_FOR info you have given is not available in our list - all and ${directoryArray[@]}"
		exit $E_BADARGS
	fi

else
	echo "Length of the directoryArray is ${#directoryArray[@]}. Please check the length!!!!"
	exit $E_BADARGS
fi

# pass up the exit code to the caller
exit $?
