#/bin/bash

if [ -z "$template" ]
then
	echo "No template passed to $0, exiting"
	exit -1
fi
	
# The name of this connector
if [ -z "$CONNECTOR_NAME" ]
then
	echo "No connector name passed to $0, exiting"
	exit -1
fi
echo "*** Connector Name = $CONNECTOR_NAME ***"

# The name of this connector
if [ -z "$CONNECTOR_TYPE" ]
then
	echo "No connector type alias passed to $0, exiting"
	exit -1
fi
echo "*** Connector Type = $CONNECTOR_TYPE ***"

if [ -z "$KAFKA_CONNECT_URL" ]
then
	KAFKA_CONNECT_URL="http://localhost:8083"
fi
if [ -z "$SCHEMA_REGISTRY_URL" ]
then
	SCHEMA_REGISTRY_URL="http://schema-registry:8081"
fi

echo "Using Kafka Connect REST interface at $KAFKA_CONNECT_URL"
echo "Using Schema Registry interface at $SCHEMA_REGISTRY_URL"

if [ "$1" = "-d" ]
then
	echo "Deleting connector $CONNECTOR_NAME"
	URL=connectors/$CONNECTOR_NAME
	METHOD=DELETE
	curl -i -X $METHOD \
	    -H "Accept:application/json" \
	    -H  "Content-Type:application/json" \
	    $KAFKA_CONNECT_URL/$URL
else
if [ "$1" = "-v" ]
	then
		echo "Validating connector config for $CONNECTOR_NAME"
		URL=connector-plugins/$CONNECTOR_TYPE/config/validate
		METHOD=PUT
		
eval "cat <<EOF
$(< ${template} )
EOF
" 2> /dev/null | curl -i -X $METHOD \
		    -H "Accept:application/json" \
		    -H  "Content-Type:application/json" \
		    $KAFKA_CONNECT_URL/$URL --data-binary @-
	else
		echo "Creating connector named $CONNECTOR_NAME"
		URL=connectors/
		METHOD=POST
		
eval "cat <<EOF
{
	"\"name\"": "\"${CONNECTOR_NAME}\"",
	"\"config\"": 
$(< ${template} )
}
EOF
" 2> /dev/null | curl -i -X $METHOD \
		    -H "Accept:application/json" \
		    -H  "Content-Type:application/json" \
		    $KAFKA_CONNECT_URL/$URL --data-binary @-
	fi
fi
	
# TODO add Update using PUT!
