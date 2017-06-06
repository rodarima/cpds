#!/bin/bash

cd $(dirname $0)

CLIENT_NODE='alice@127.0.0.1'
SERVER_NODE='bob@127.0.0.1'

erl +S 2:2 -name $CLIENT_NODE -noshell < /dev/null &
CLIENT_PID=$!
#exit

while read CONF ; do
	# Conf should be "$CLIENTS, $ENTRIES, $READS, $WRITES, $TIME"
	echo "Running configuration $CONF" >&2

	erl +S 2:2 -name $SERVER_NODE -noshell -eval "opty:start($CONF)" -run init stop < /dev/null
done

kill -9 $CLIENT_PID
