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
    if [[ $(docker inspect cattle | jq -r .[0].Name) != "/cattle" ]]; then
        docker create --privileged -v /var/lib/docker:/var/lib/docker -p 8080:8080 --name=cattle cattleserver
    else
        docker stop cattle
    fi
}

function create_hosts(){
    for i in {1..3}
    do
        docker rm -vf host$i  | echo > /dev/null;docker create  -v /var/lib/docker:/var/lib/docker --link=cattle:cattle --privileged --name=host$i hostcontainer
    done
}

function start_stuff(){
    docker restart cattle
    docker restart host1 host2 host3
    
}

cd $(dirname $0)/..
docker build --rm -t cattleserver .
cd scripts/
docker build -t hostcontainer .
create_hosts
cattle_server
start_stuff