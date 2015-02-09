#!/bin/bash

set -e

cd $(dirname $0)/..
docker build -t cattleserver .
cd scripts/
docker build -t hostcontainer .

docker rm  -fv $(docker ps -qa) | echo > /dev/null
docker run -d --privileged -p 8080:8080 --name=cattle cattleserver
docker run -d --privileged --name=host1 hostcontainer
docker run -d --privileged --name=host2 hostcontainer
docker run -d --privileged --name=host3 hostcontainer
