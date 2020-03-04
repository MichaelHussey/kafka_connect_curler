#/bin/bash

# The name of this connector
if [ -z "$CONNECTOR_NAME" ]
then
	export CONNECTOR_NAME="bigquery-sink-connector"
fi

export template="`dirname $0`/../templates/bigquery_sink.properties"
export CONNECTOR_TYPE="com.wepay.kafka.connect.bigquery.BigQuerySinkConnector"

# Specific parameters needed by this connector
if [ -z "$GCP_PROJECT" ]
then
	echo "Please set GCP_PROJECT env variable"
	exit -1
fi
if [ -z "$GCP_DATASET" ]
then
	echo "Please set GCP_DATASET env variable"
	exit -1
fi
if [ -z "$GCP_KEYFILE" ]
then
	echo "Please set GCP_KEYFILE env variable"
	exit -1
fi

`dirname $0`/invoke_connect_rest.sh $@
	
