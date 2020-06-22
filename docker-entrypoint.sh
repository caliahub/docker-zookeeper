#!/bin/bash

set -e

# Generate the config only if it doesn't exist
if [[ ! -f "${ZOO_DIR}/conf/zoo.cfg" ]]; then
    CONFIG="${ZOO_DIR}/conf/zoo.cfg"
    {
        echo "dataDir=${ZOO_DIR}/data" 
        echo "dataLogDir=${ZOO_DIR}/logs"

        echo "tickTime=${ZOO_TICK_TIME}"
        echo "initLimit=${ZOO_INIT_LIMIT}"
        echo "syncLimit=${ZOO_INIT_LIMIT}"

        echo "autopurge.snapRetainCount=${ZOO_AUTOPURGE_SNAPRETAINCOUNT}"
        echo "autopurge.purgeInterval=${ZOO_AUTOPURGE_PURGEINTERVAL}"
        echo "maxClientCnxns=${ZOO_MAX_CLIENT_CNXNS}"
        echo "standaloneEnabled=${ZOO_STANDALONE_ENABLED}"
        echo "admin.enableServer=${ZOO_ADMINSERVER_ENABLED}"
    } >> "${CONFIG}"
    if [[ -z ${ZOO_SERVERS} ]]; then
      ZOO_SERVERS="server.1=127.0.0.1:2888:3888;2181"
    fi

    for server in ${ZOO_SERVERS}; do
        echo "${server}" >> "${CONFIG}"
    done

    if [[ -n ${ZOO_4LW_COMMANDS_WHITELIST} ]]; then
        echo "4lw.commands.whitelist=${ZOO_4LW_COMMANDS_WHITELIST}" >> "${CONFIG}"
    fi

fi

# Write myid only if it doesn't exist
if [[ ! -f "${ZOO_DIR}/data/myid" ]]; then
    echo "${ZOO_MY_ID:-1}" > "${ZOO_DIR}/data/myid"
fi

exec "$@"
