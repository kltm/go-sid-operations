#!/usr/bin/env bash

SOLR_MEM=${GOLR_SOLR_MEMORY:="4G"}

COMMAND='echo "NO COMMAND FOUND"'

echo "Starting the jetty server with solr installed ($SOLR_MEM)"
cd /usr/share/jetty9
java -Xms$SOLR_MEM -Xmx$SOLR_MEM -DentityExpansionLimit=8172000 -Djava.awt.headless=true -Dsolr.solr.home=/srv/solr -Djava.io.tmpdir=/tmp/jetty9 -Djava.library.path=/usr/lib -Djetty.home=/usr/share/jetty9 -Djetty.logs=/var/log/jetty9 -Djetty.state=/tmp/jetty.state -Djetty.host=0.0.0.0 -Djetty.port=8080 -jar /usr/share/jetty9/start.jar --daemon /etc/jetty9/jetty-started.xml &

echo "Launched, waiting for server response"

COUNTER=0
while ! nc -z localhost 8080; do
  echo "Not found on 8080, rechecking after 2 sec"
  sleep 10 # wait for 10 seconds before check again
  COUNTER=$((COUNTER + 1))

  if [ $COUNTER -gt 10 ]
  then
      echo "Something is wrong, exiting"
      exit 1 ;
  fi
done

echo "Server found on 8080"

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

echo "Command finished"
