####
#### This docker file is trying to run and install AmiGO/GOlr
#### minimally as root on localhost:
####
#### Build (from repo root):
####   TAG=`git log | head -1 | cut -d ' ' -f 2`_`date +%Y-%m-%dT%H%M%S` docker build -t geneontology/dev-base:latest -t geneontology/dev-base:$TAG -f docker/dev-base/Dockerfile .
####
#### To push:
####  docker push geneontology/dev-base:latest
####  docker push geneontology/dev-base:$TAG

### 1. Get Linux
FROM ubuntu:18.04

# Update and install software
RUN apt-get update -y

RUN apt-get install -y git curl rsync make mmv wget python3.6 python3-pip python3-venv openjdk-8-jdk ca-certificates-java maven pigz
RUN update-ca-certificates -f

# http://click.palletsprojects.com/en/7.x/python3/, this is for the python click module for making command line interfaces
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java

ADD docker/dev-base/requirements.txt /tmp/requirements.txt
RUN pip3 install -r /tmp/requirements.txt
