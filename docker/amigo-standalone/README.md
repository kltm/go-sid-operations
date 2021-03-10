
## Build own system (example with ontology and GAF, similar to AmiGO):

```bash
docker run -e "GOLR_SOLR_MEMORY=4G" -e "GOLR_LOADER_MEMORY=8G" -e "GOLR_INPUT_ONTOLOGIES=http://purl.obolibrary.org/obo/ncbitaxon/subsets/taxslim.owl" -e "GOLR_INPUT_GAFS=http://current.geneontology.org/annotations/aspgd.gaf.gz" -v /tmp/srv-solr-data:/srv/solr/data -t geneontology/golr-autoindex
docker run -p 8080:8080 -p 9999:9999 -v /tmp/srv-solr-data:/srv/solr/data -t geneontology/amigo-standalone
```

## Build own system (example with ontology-only, similar to GO-GO-CAM load):

```bash
docker run -e "GOLR_SOLR_MEMORY=4G" -e "GOLR_LOADER_MEMORY=8G" -e "GOLR_INPUT_ONTOLOGIES=http://purl.obolibrary.org/obo/ncbitaxon/subsets/taxslim.owl" -v /tmp/srv-solr-data:/srv/solr/data -t geneontology/golr-autoindex-ontology
docker run -p 8080:8080 -p 9999:9999 -v /tmp/srv-solr-data:/srv/solr/data -t geneontology/amigo-standalone
```

## Grab remote pipeline contents and use

``` bash
mkdir -p /tmp/srv-solr-data/index
cd /tmp/srv-solr-data/index
wget http://skyhook.berkeleybop.org/issue-35-neo-test/products/solr/golr-index-contents.tgz
tar -zxvf golr-index-contents.tgz
docker run -p 8080:8080 -p 9999:9999 -v /tmp/srv-solr-data:/srv/solr/data -t geneontology/amigo-standalone
```
