#!/usr/bin/env bash

## Run an arbitrary command in the running Solr environment.
while getopts ":c:" opt; do
    case ${opt} in
	c )
	    echo "Current opt: $opt"
	    COMMAND=${OPTARG}
	    echo "Run command: $COMMAND"
	    eval $COMMAND
	    ;;
	\? )
	    echo "Invalid option: $OPTARG" 1>&2
	    ;;
	: )
	    echo "Invalid option: $OPTARG requires an argument" 1>&2
	    ;;
    esac
done
