####
#### This docker file is trying to run and install AmiGO/GOlr
#### minimally as root on localhost:
####
#### Build (from repo root):
####   docker build -t geneontology/golr-autoindex-ontology:latest -t geneontology/golr-autoindex-ontology:`git log | head -1 | cut -d ' ' -f 2`_`date +%Y-%m-%dT%H%M%S` docker/golr-autoindex-ontology
####
#### To push:
####  docker push geneontology/golr-autoindex-ontology:latest
####  docker push geneontology/golr-autoindex-ontology:281249f558dbe9099d70be9e92a7bbc9cc30b91c_2018-05-13T130218
####
#### Run (standard):
####  docker run -v /tmp/srv-solr-data:/srv/solr/data -t geneontology/golr-autoindex-ontology:281249f558dbe9099d70be9e92a7bbc9cc30b91c_2018-05-13T130218
####
#### Run with port exposed:
####  docker run -p 19999:8080 -v /tmp/srv-solr-data:/srv/solr/data geneontology/golr-autoindex-ontology:281249f558dbe9099d70be9e92a7bbc9cc30b91c_2018-05-13T130218
####
#### Check on solr with port exposed:
####  docker run -it -p 19999:8080 -v /tmp/srv-solr-data:/srv/solr/data geneontology/golr-autoindex-ontology:281249f558dbe9099d70be9e92a7bbc9cc30b91c_2018-05-13T130218 /bin/bash
####

## Grab the latest(?) Ubuntu image.
FROM ubuntu:18.04

## Quiet it down a little bit.
ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux

## Get the system updated.
RUN apt-get -qq update && \
    apt-get -qq -y install libterm-readline-gnu-perl apt-utils \
                           software-properties-common netcat rsync \
                           build-essential wget curl pigz subversion \
                           less mg byobu htop iotop di git make kwalify vim
## Node.
#RUN apt-get -y install build-essential curl
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs

## Grab the AmiGO/GOlr repo and change context.
RUN mkdir -p /srv
RUN git clone https://github.com/geneontology/amigo.git --branch master --single-branch /srv/amigo
WORKDIR /srv/amigo
RUN git pull

## GOlr/Jetty setup.
RUN apt-get -y install jetty9
RUN cp ./golr/solr/solr.war /var/lib/jetty9/webapps/
RUN chown jetty /var/lib/jetty9/webapps/solr.war
RUN chgrp adm /var/lib/jetty9/webapps/solr.war
RUN cp ./golr/jetty/jetty /etc/default/jetty9
RUN mkdir -p /srv/solr/data
RUN mkdir -p /srv/solr/conf
RUN cp ./golr/solr/conf/schema.xml /srv/solr/conf/schema.xml
RUN cp ./golr/solr/conf/solrconfig.xml /srv/solr/conf/solrconfig.xml
RUN chown -R jetty /srv/solr/
RUN chgrp -R adm /srv/solr/

## Custom runtime locations for jetty9/solr for the Docker environment.
RUN mkdir -p /tmp/jetty9
RUN chown -R jetty /tmp/jetty9
RUN chgrp -R adm /tmp/jetty9

##
#EXPOSE 8080
#WORKDIR /usr/share/jetty9

ADD "run-indexer.sh" /tmp/run-indexer.sh
RUN ["chmod", "+x", "/tmp/run-indexer.sh"]
CMD "/tmp/run-indexer.sh"
