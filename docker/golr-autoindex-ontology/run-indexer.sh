#!/usr/bin/env bash

SOLR_MEM=${GOLR_SOLR_MEMORY:="4G"}

echo "Starting the jetty server with solr installed ($SOLR_MEM)"
cd /usr/share/jetty9
java -Xms$SOLR_MEM -Xmx$SOLR_MEM -DentityExpansionLimit=8172000 -Djava.awt.headless=true -Dsolr.solr.home=/srv/solr -Djava.io.tmpdir=/tmp/jetty9 -Djava.library.path=/usr/lib -Djetty.home=/usr/share/jetty9 -Djetty.logs=/var/log/jetty9 -Djetty.state=/tmp/jetty.state -Djetty.host=0.0.0.0 -Djetty.port=8080 -jar /usr/share/jetty9/start.jar --daemon etc/jetty-started.xml &

echo "Launched, waiting for server response"

COUNTER=0
while ! nc -z localhost 8080; do
  echo "Not found on 8080, rechecking after 2 sec"
  sleep 2 # wait for 1 second before check again
  COUNTER=$((COUNTER + 1))

  if [ $COUNTER -gt 10 ]
  then
      echo "Something is wrong, exiting"
      exit 1 ;
  fi
done

echo "Server found on 8080"

ONTOLOGIES=${GOLR_INPUT_ONTOLOGIES:= \
			      "http://skyhook.berkeleybop.org/release/ontology/extensions/go-gaf.owl" \
			      "http://skyhook.berkeleybop.org/release/ontology/extensions/gorel.owl" \
			      "http://skyhook.berkeleybop.org/release/ontology/extensions/go-modules-annotations.owl" \
			      "http://skyhook.berkeleybop.org/release/ontology/extensions/go-taxon-subsets.owl" \			       "http://purl.obolibrary.org/obo/eco.owl" \
			      "http://purl.obolibrary.org/obo/ncbitaxon/subsets/taxslim.owl" \
			      "http://purl.obolibrary.org/obo/cl/cl-basic.owl" \
			      "http://purl.obolibrary.org/obo/pato.owl" \
			      "http://purl.obolibrary.org/obo/po.owl" \
			      "http://purl.obolibrary.org/obo/chebi.owl" \
			      "http://purl.obolibrary.org/obo/uberon/basic.owl" \
			      "http://purl.obolibrary.org/obo/wbbt.owl"
	  }

LOADER_MEM=${GOLR_LOADER_MEMORY:="32G"}

echo "Running indexer command ($LOADER_MEM)"
# Internal config.
# General config.
# Ontology config.
# PANTHER (reading--annotations need them too)
# Load GAFs
# PANTHER (loading their own doc types)
# Optimize.
java \
    -Xms$LOADER_MEM \
    -Xmx$LOADER_MEM \
    -DentityExpansionLimit=8172000 \
    -Djava.awt.headless=true \
    -jar /srv/amigo/java/lib/owltools-runner-all.jar  \
    $ONTOLOGIES \
    --log-info \
    --solr-config /srv/amigo/metadata/ont-config.yaml \
    --merge-support-ontologies \
    --merge-imports-closure \
    --remove-subset-entities upperlevel \
    --remove-disjoints \
    --silence-elk \
    --reasoner elk \
    --solr-taxon-subset-name amigo_grouping_subset \
    --solr-eco-subset-name go_groupings \
    --solr-url http://localhost:8080/solr/ \
    --solr-log /tmp/golr_timestamp.log \
    --solr-load-ontology \
    --solr-load-ontology-general  \
    --solr-optimize

echo "Check that results have been stored properly"
curl "http://localhost:8080/solr/select?q=*:*&rows=0"
echo "End of results"
