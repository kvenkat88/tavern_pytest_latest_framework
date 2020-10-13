#!/bin/bash

# https://tldp.org/LDP/Bash-Beginners-Guide/html/sect_09_07.html
# https://stackoverflow.com/questions/36007240/what-is-the-use-of-in-bash
# https://coderwall.com/p/85jnpq/bash-built-in-variables
# https://askubuntu.com/questions/939620/what-does-mean-in-bash  --> we can't directly use "$#" inside the function and it always return 0
# utility function for failing with a message

E_BADARGS=85 #Wrong number of arguments passed to script.

SCRIPT=$0

USAGE="Use: $SCRIPT bulk|specific_dir|marks [OPTIONS]"
if [ $# -eq 0 ]; then
   echo $USAGE
   echo "Wromg number of arguments passed to script. Please give valid arguments to proceed!!!"
   exit $E_BADARGS
fi

OPERATION=$1
# Shift is a builtin command in bash which after getting executed, shifts/move the command line arguments to one position left.
# The first argument is lost after using shift command.
shift

if [[ "$OPERATION" == "bulk" || "$OPERATION" == "specific_dir" || "$OPERATION" == "marks" ]]; then
   USAGE="Use: $SCRIPT bulk|specific_dir|marks HOST_IP ENV_TYPE"
   if [ "$#" -eq 0 ]; then
      echo "$USAGE"
      echo "Please provide HOST_IP and ENV_TYPE values for processing!!!"
      exit $E_BADARGS
   else
      HOST_IP_FETCHED=$1
      ENV_TYPE_FETCHED=$2
      echo "Mapping these HOST_IP and ENV_TYPE values to environment variables"
      export HOST_IP=${HOST_IP_FETCHED:-"http://localhost:5003"}
      export ENV_TYPE=${ENV_TYPE_FETCHED:-"local"}

      if [[ $OPERATION == "bulk" ]]; then
         echo "Framing and executing the Pytest Test Scripts for bulk test execution......"
         CMD="python -m pytest --cache-clear -vv --metadata Host_Name $HOST_IP --html=../reports/Notifications-API-TestReports-$(date +'%m_%d_%Y').html --self-contained-html tests/"
         echo "Command passed for execution is $CMD"
         $CMD
      fi

      if [[ $OPERATION == "specific_dir" ]]; then
         if [[ -n "$3" ]]; then
            echo "Framing and executing the Pytest Test Scripts for specific directory test execution......"
            CMD="python -m pytest --cache-clear -vv --metadata Host_Name $HOST_IP --html=../reports/Notifications-API-TestReports-$3-directory-$(date +'%m_%d_%Y').html --self-contained-html tests/$3"
            echo "Command passed for execution is $CMD"
            $CMD
         else
            echo "Value provided is $3"
            echo "Please provide a specific directory name !!!"
            exit $E_BADARGS

         fi
      fi

      if [[ $OPERATION == "marks" ]]; then
         if [[ -n "$3" ]]; then
             echo "Framing and executing the Pytest Test Scripts for bulk test execution......"
             CMD="python -m pytest --cache-clear -vv --metadata Host_Name $HOST_IP --html=../reports/Notifications-API-TestReports-$3-marks-$(date +'%m_%d_%Y').html --self-contained-html -m $3 tests/"
             echo "Command passed for execution is $CMD"
             $CMD
         else
            echo "Value provided is $3"
            echo 'Please provide a pytest marker info like "smoke|regression" !!!'
            exit $E_BADARGS
         fi
      fi

   fi

else
    echo "OPERATION ARG value provided is $OPERATION not valid. Please provide from bulk, marks and specific_dir !!!!!"
    exit $E_BADARGS
fi

# pass up the exit code to the caller
exit $?
