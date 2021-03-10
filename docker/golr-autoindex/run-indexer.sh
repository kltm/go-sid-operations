#!/usr/bin/env bash

SOLR_MEM=${GOLR_SOLR_MEMORY:="4G"}

echo "Starting the jetty server with solr installed ($SOLR_MEM)"
cd /usr/share/jetty9
java -Xms$SOLR_MEM -Xmx$SOLR_MEM -DentityExpansionLimit=8172000 -Djava.awt.headless=true -Dsolr.solr.home=/srv/solr -Djava.io.tmpdir=/tmp/jetty9 -Djava.library.path=/usr/lib -Djetty.home=/usr/share/jetty9 -Djetty.logs=/var/log/jetty9 -Djetty.state=/tmp/jetty.state -Djetty.host=0.0.0.0 -Djetty.port=8080 -jar /usr/share/jetty9/start.jar --daemon /etc/jetty9/jetty-started.xml &

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

GAFS=${GOLR_INPUT_GAFS:= \
		  "http://www.geneontology.org/gene-associations/submission/paint/pre-submission/gene_association.paint_other.gaf" \
		  "http://skyhook.berkeleybop.org/release/annotations/aspgd.gaf.gz" \
		  "http://skyhook.berkeleybop.org/release/annotations/cgd.gaf.gz" \
		  "http://skyhook.berkeleybop.org/release/annotations/dictybase.gaf.gz" \
		  "http://skyhook.berkeleybop.org/release/annotations/ecocyc.gaf.gz" \
		  "http://skyhook.berkeleybop.org/release/annotations/fb.gaf.gz" \
		  "http://skyhook.berkeleybop.org/release/annotations/genedb_lmajor.gaf.gz" \
		  "http://skyhook.berkeleybop.org/release/annotations/genedb_pfalciparum.gaf.gz" \
		  "http://skyhook.berkeleybop.org/release/annotations/genedb_tbrucei.gaf.gz" \
		  "http://skyhook.berkeleybop.org/release/annotations/goa_chicken.gaf.gz" \
		  "http://skyhook.berkeleybop.org/release/annotations/goa_chicken_complex.gaf.gz" \
		  "http://skyhook.berkeleybop.org/release/annotations/goa_chicken_rna.gaf.gz" \
		  "http://skyhook.berkeleybop.org/release/annotations/goa_cow.gaf.gz" \
		  "http://skyhook.berkeleybop.org/release/annotations/goa_cow_complex.gaf.gz" \
		  "http://skyhook.berkeleybop.org/release/annotations/goa_cow_rna.gaf.gz" \
		  "http://skyhook.berkeleybop.org/release/annotations/goa_dog.gaf.gz" \
		  "http://skyhook.berkeleybop.org/release/annotations/goa_dog_complex.gaf.gz" \
		  "http://skyhook.berkeleybop.org/release/annotations/goa_dog_rna.gaf.gz" \
		  "http://skyhook.berkeleybop.org/release/annotations/goa_human.gaf.gz" \
		  "http://skyhook.berkeleybop.org/release/annotations/goa_human_complex.gaf.gz" \
		  "http://skyhook.berkeleybop.org/release/annotations/goa_human_rna.gaf.gz" \
		  "http://skyhook.berkeleybop.org/release/annotations/goa_pig.gaf.gz" \
		  "http://skyhook.berkeleybop.org/release/annotations/goa_pig_complex.gaf.gz" \
		  "http://skyhook.berkeleybop.org/release/annotations/goa_pig_rna.gaf.gz" \
		  "http://skyhook.berkeleybop.org/release/annotations/goa_uniprot_all_noiea.gaf.gz" \
		  "http://skyhook.berkeleybop.org/release/annotations/gramene_oryza.gaf.gz" \
		  "http://skyhook.berkeleybop.org/release/annotations/jcvi.gaf.gz" \
		  "http://skyhook.berkeleybop.org/release/annotations/mgi.gaf.gz" \
		  "http://skyhook.berkeleybop.org/release/annotations/pamgo_atumefaciens.gaf.gz" \
		  "http://skyhook.berkeleybop.org/release/annotations/pamgo_ddadantii.gaf.gz" \
		  "http://skyhook.berkeleybop.org/release/annotations/pamgo_mgrisea.gaf.gz" \
		  "http://skyhook.berkeleybop.org/release/annotations/pamgo_oomycetes.gaf.gz" \
		  "http://skyhook.berkeleybop.org/release/annotations/pombase.gaf.gz" \
		  "http://skyhook.berkeleybop.org/release/annotations/pseudocap.gaf.gz" \
		  "http://skyhook.berkeleybop.org/release/annotations/rgd.gaf.gz" \
		  "http://skyhook.berkeleybop.org/release/annotations/sgd.gaf.gz" \
		  "http://skyhook.berkeleybop.org/release/annotations/sgn.gaf.gz" \
		  "http://skyhook.berkeleybop.org/release/annotations/tair.gaf.gz" \
		  "http://skyhook.berkeleybop.org/release/annotations/wb.gaf.gz" \
		  "http://skyhook.berkeleybop.org/release/annotations/zfin.gaf.gz"
    }

LOADER_PANTHER_TREES=${GOLR_INPUT_PANTHER_TREES:= "http://skyhook.berkeleybop.org/release/products/panther/arbre.tgz"}

echo "Grabbing latest PANTHER data into /tmp ($LOADER_PANTHER_TREES)"
#svn --non-interactive --trust-server-cert --ignore-externals checkout svn://ext.geneontology.org/trunk/experimental/trees/panther_data/ /tmp/panther_data
mkdir /tmp/panther_data
wget $LOADER_PANTHER_TREES
tar -zxvf arbre.tgz --directory /tmp/panther_data

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
    --read-panther /tmp/panther_data/ \
    --solr-load-gafs $GAFS \
    --solr-load-panther \
    --solr-load-panther-general \
    --solr-optimize

echo "Check that results have been stored properly"
curl "http://localhost:8080/solr/select?q=*:*&rows=0"
echo "End of results"
