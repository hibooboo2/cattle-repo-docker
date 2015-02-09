#!/bin/bash

set -e

CMDS="jq curl docker"

for i in $CMDS
do
        # command -v will return >0 when the $i is not found
	which $i >/dev/null && continue || { echo "$i command not found."; exit 1; }
done

function cattleServer(){
#the magic to determine if cattle server needs to be run restarted or rebuilt.
    if [[ $(docker inspect cattle | jq -r .[0].Id | echo) == "null" ]]; then
        docker run -d --privileged -p 8080:8080 --ip=172.17.0.20 --name=cattle cattleserver
    else
        docker restart cattle
    fi
    
}

cd $(dirname $0)/..
docker build --rm -t cattleserver .
cd scripts/
docker build -t hostcontainer .
cattleServer
docker rm -vf host1  | echo > /dev/null;docker run -d --privileged -p 9345:9345 --name=host1 --ip=172.17.0.21 hostcontainer
docker rm -vf host2  | echo > /dev/null;docker run -d --privileged -p 9345:9345 --name=host2 --ip=172.17.0.22 hostcontainer
docker rm -vf host3  | echo > /dev/null;docker run -d --privileged -p 9345:9345 --name=host3 --ip=172.17.0.23 hostcontainer
