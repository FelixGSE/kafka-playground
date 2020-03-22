#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'


env | grep ^KAFKA_CFG_ | sed 's/^KAFKA_CFG_//' | while IFS='=' read -r n v; do

	key=$(echo $n | awk '{print tolower($0)}' | sed 's/\_/./g')

	if [[ ! -z $(grep "$key=" $KAFKA_RUNTIME_HOME/config/server.properties) ]]; then
    
    	sed -i "/$key/d" $KAFKA_RUNTIME_HOME/config/server.properties
	
	fi 

	echo "$key=$v" >> $KAFKA_RUNTIME_HOME/config/server.properties 

done

exec kafka-server-start.sh $KAFKA_RUNTIME_HOME/config/server.properties