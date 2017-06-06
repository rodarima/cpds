#!/bin/bash

cd $(dirname $0)

while read CONF ; do
	# Conf should be "$CLIENTS, $ENTRIES, $READS, $WRITES, $TIME"
	echo "Running configuration $CONF" >&2

	erl +S 2:2 -noshell -eval "timey:start($CONF)" -run init stop < /dev/null
done
