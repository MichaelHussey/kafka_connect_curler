#/bin/bash

# The name of this connector
if [ -z "$CONNECTOR_NAME" ]
then
	export CONNECTOR_NAME="replicator-to_cc"
fi

export template="`dirname $0`/../templates/replicator-to_cc.properties"
export CONNECTOR_TYPE="io.confluent.connect.replicator.ReplicatorSourceConnector"

`dirname $0`/invoke_connect_rest.sh	$@
