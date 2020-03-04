#/bin/bash

# This script>
# 1. Reads a JSON template for a Kafka Connect instance configuration
# 2. Replaces all ${ENV_NAME} with the values from the corresponding environment variable
# 3. Invokes one of the Kafka Connect REST API methods using the templated data
#
# Usage:
#    invoke_connect_rest.sh (-d | -v | -u)
#       -d Deletes the connector instance
#       -s Checks the status of a connector instance
#       -v Validates the connector configuration
#       -u Updates an existing connector instance
#
# When no parameters are provided a new connector instance is created

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

if [ "$1" = "-d" ]; then
	echo "Deleting connector $CONNECTOR_NAME"
	URL=connectors/$CONNECTOR_NAME
	METHOD=DELETE
	curl -i -X $METHOD \
	    -H "Accept:application/json" \
	    -H  "Content-Type:application/json" \
	    $KAFKA_CONNECT_URL/$URL
	exit
elif [ "$1" = "-s" ]; then
	echo "Config of connector $CONNECTOR_NAME"
	URL=connectors/$CONNECTOR_NAME
	METHOD=GET
	RESULT=`curl -s -X $METHOD \
	    -H "Accept:application/json" \
	    $KAFKA_CONNECT_URL/$URL `
	echo $RESULT | jq '.'
	TASKS_ACTIVE=`echo $RESULT | jq '.tasks | length'`
	TASKS_GOAL=`echo $RESULT | jq --raw-output '.config."tasks.max"'`
	echo "There are $TASKS_ACTIVE of $TASKS_GOAL tasks running"
	
    exit
elif [ "$1" = "-v" ]; then
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
	exit
elif [ "$1" = "-u" ]; then
	echo "Updating connector config for $CONNECTOR_NAME"
	URL=connectors/$CONNECTOR_NAME/config
	METHOD=PUT
		
eval "cat <<EOF
$(< ${template} )
EOF
" 2> /dev/null | curl -i -X $METHOD \
		    -H "Accept:application/json" \
		    -H  "Content-Type:application/json" \
		    $KAFKA_CONNECT_URL/$URL --data-binary @-
	exit
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
	exit
fi
