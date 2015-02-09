#!/bin/bash

set -e

CMDS="jq curl docker"

for i in $CMDS
do
        # command -v will return >0 when the $i is not found
	which $i >/dev/null && continue || { echo "$i command not found."; exit 1; }
done

function cattle_server(){
#the magic to determine if cattle server needs to be run restarted or rebuilt.
    docker rm -vf cattle | echo > /dev/null;docker create --privileged -p 8080:8080 --name=cattle cattleserver
        
}

function create_hosts(){
    docker rm -vf host1  | echo > /dev/null;docker create --privileged -p 9345:9345 --name=host1 hostcontainer
    docker rm -vf host2  | echo > /dev/null;docker create --privileged -p 9345:9345 --name=host2 hostcontainer
    docker rm -vf host3  | echo > /dev/null;docker create --privileged -p 9345:9345 --name=host3 hostcontainer
}

function start_stuff(){
    docker start host1 host2 host3
    docker start cattle
    
}

cd $(dirname $0)/..
docker build --rm -t cattleserver .
cd scripts/
docker build -t hostcontainer .
create_hosts
cattle_server
start_stuff