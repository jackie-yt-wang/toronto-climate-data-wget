#!/bin/bash

##########################################################
# SET DEFAUL VARIABLES

filenametime=$(date +"%m%d%Y%H%M%S")

#########################################################
# SET VARIABLES 
# dir_path=$(cd "$(dirname "${BASH_SOURCE:-$0}")" && pwd)
export BASE_FOLDER='/Users/apple/Desktop/DataEngineeringBootCamp/1-Linux/MiniProject/Toronto-Climate-Data-DE'
export SCRIPTS_FOLDER=${BASE_FOLDER}'/scripts'
export INPUT_FOLDER=${BASE_FOLDER}'/input'
export OUT_FOLDER=${BASE_FOLDER}'/output'
export LOGDIR=${BASE_FOLDER}'/logs'
export SHELL_SCRIPT_NAME='toronto-climate-data-de'
export LOG_FILE=${LOGDIR}/${SHELL_SCRIPT_NAME}_${filenametime}.log
export PYTHON_SCRIPT='concat.py'
#########################################################

# SET LOG RULES
exec > >(tee ${LOG_FILE})
exec 2> >(tee ${LOG_FILE})

#########################################################
# DOWNLOAD DATA
echo "Start download data"

for year in {2020..2022}; 
do wget --content-disposition "https://climate.weather.gc.ca/climate_data/bulk_data_e.html?format=csv&stationID=48549&Year=${year}&Month=2&Day=14&timeframe=1&submit= Download+Data" -P ${INPUT_FOLDER};
done;

RC1=$?
if [ ${RC1} != 0 ];
then
	echo "DOWNLOAD DATA FAILED"
	echo "[ERROR:] RETURN CODE:  ${RC1}"
	echo "[ERROR:] REFER TO THE LOG FOR THE REASON FOR THE FAILURE."
	exit 1
fi

#########################################################
# RUN PYTHON
echo 'Install necessary Python Libraries'
pipenv install
echo "Start to run Python Script"
pipenv run python3 ${SCRIPTS_FOLDER}/${PYTHON_SCRIPT}


RC1=$?
if [ ${RC1} != 0 ];
then
	echo "PYTHON RUNNING FAILED"
	echo "[ERROR:] RETURN CODE:  ${RC1}"
	echo "[ERROR:] REFER TO THE LOG FOR THE REASON FOR THE FAILURE."
	exit 1
fi

echo "PROGRAM SUCCEEDED"

exit 0 