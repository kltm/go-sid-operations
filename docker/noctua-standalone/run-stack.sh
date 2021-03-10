#!/usr/bin/env bash

###
### AmiGO on Apache first.
###

echo "Starting the apache2 server with amigo installed"
cd /srv/amigo
/etc/init.d/apache2 start

echo "Launched, waiting for server response"

COUNTER=0
while ! nc -z localhost 9999; do
  echo "Not found on 9999, rechecking after 2 sec"
  sleep 2 # wait for 1 second before check again
  COUNTER=$((COUNTER + 1))

  if [ $COUNTER -gt 10 ]
  then
      echo "Something is wrong, exiting"
      exit 1 ;
  fi
done

echo "Server found on 9999"

SOLR_MEM=${GOLR_SOLR_MEMORY:="4G"}

echo "Starting the jetty server with Solr installed ($SOLR_MEM)"
cd /usr/share/jetty9
java -Xms$SOLR_MEM -Xmx$SOLR_MEM -DentityExpansionLimit=8172000 -Djava.awt.headless=true -Dsolr.solr.home=/srv/solr -Djava.io.tmpdir=/tmp/jetty9 -Djava.library.path=/usr/lib -Djetty.home=/usr/share/jetty9 -Djetty.logs=/var/log/jetty9 -Djetty.state=/tmp/jetty.state -Djetty.host=0.0.0.0 -Djetty.port=8080 -jar /usr/share/jetty9/start.jar --daemon /etc/jetty9/jetty-started.xml

echo "Check that results have been stored properly"
curl "http://localhost:8080/solr/select?q=*:*&rows=0"
echo "End of results"
