#/bin/bash

# The name of this connector
if [ -z "$CONNECTOR_NAME" ]
then
	export CONNECTOR_NAME="mysql-source-connector"
fi

export template="`dirname $0`/../templates/jdbc_mysql_source.properties"
export CONNECTOR_TYPE="io.confluent.connect.jdbc.JdbcSourceConnector"

# Specific parameters needed by this connector
if [ -z "$OUTPUT_TOPIC" ]
then
	echo "Please set OUTPUT_TOPIC env variable"
	exit -1
fi
# Specific parameters needed by this connector
if [ -z "$DB_USER" ]
then
	echo "Please set DB_USER env variable"
	exit -1
fi
# Specific parameters needed by this connector
if [ -z "$DB_PASSWORD" ]
then
	echo "Please set DB_PASSWORD env variable"
	exit -1
fi

`dirname $0`/invoke_connect_rest.sh	$@
