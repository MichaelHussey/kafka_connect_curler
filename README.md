# kafka_connect_curler
Simple JSON templating to make it easy to invoke Kafka Connect's REST API

All the heavy lifting is done by the `scripts/invoke_connect_rest.sh` script.

This script reads a template JSON file and replaces any instances of `${SOME_ENV_NAME}` by the value of the
 environment variable `SOME_ENV_NAME`
 
It uses a command line flag to determine which of the various REST methods to invoke:
| Flag | Description |
| ---- | ----------- |
| -d | Delete |
| -u | Update |
| -s | Check the status |
| -v | Validate the config |

If there is no command line flag provided a new connector instance is created.

The script uses a number of environment variables:
| Variable | Optional | Notes |
| -------- | -------- | ----- |
| CONNECTOR_NAME | No | The name of the connector instance |
| CONNECTOR_TYPE | No | The full java class name of the connector implementation |
| KAFKA_CONNECT_URL | Yes | The location of the REST interface, defaults to `http://localhost:8083` if not set |
| SCHEMA_REGISTRY_URL | Yes | The location of the Schema Registry interface, defaults to `http://localhost:8081` if not set |


