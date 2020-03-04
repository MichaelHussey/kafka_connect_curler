# kafka_connect_curler
Simple JSON templating to make it easy to invoke Kafka Connect's REST API

All the heavy lifting is done by the `scripts/invoke_connect_rest.sh` script.

This script reads a template JSON file and replaces any instances of `${SOME_ENV_NAME}` by the value of the
 environment variable `SOME_ENV_NAME`
 
It uses a command line flag to determine which of the various REST methods to invoke:
Flag | Description
-----| -----------
-d | Delete
-u | Update
-s | Check the status
-v | Validate the config
If there is no command line flag provided a new connector instance is created.


