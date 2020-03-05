#/bin/bash

# The name of this connector
if [ -z "$CONNECTOR_NAME" ]
then
	export CONNECTOR_NAME="file-source-connector"
fi

export template="`dirname $0`/../templates/file_source.properties"
export CONNECTOR_TYPE="com.github.jcustenborder.kafka.connect.spooldir.SpoolDirCsvSourceConnector"

# Specific parameters needed by this connector
if [ -z "$OUTPUT_TOPIC" ]
then
	echo "Please set OUTPUT_TOPIC env variable"
	exit -1
fi
if [ -z "$IN_DIR" ]
then
	export IN_DIR="/data/in"
fi
if [ -z "$ERR_DIR" ]
then
	export ERR_DIR="/data/err"
fi
if [ -z "$FIN_DIR" ]
then
	export FIN_DIR="/data/fin"
fi
if [ -z "$FILE_PATTERN" ]
then
	export FILE_PATTERN="^.*.csv$"
fi


`dirname $0`/invoke_connect_rest.sh	$@
