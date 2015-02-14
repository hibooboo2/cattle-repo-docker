#!/bin/bash

set -e

cd $(dirname $0)

wget http://stedolan.github.io/jq/download/linux64/jq
mv ./jq /source/bin/jq
mkdir /source
mkdir /source/bin
chmod u+rwx /source/bin/jq

export PATH="${PATH}:/source/bin/"

wrapdocker

git clone https://github.com/rancherio/build-master-scripts.git

function create_hosts(){
    cattleip=$(docker inspect cattle | jq -r .[0].NetworkSettings.IPAddress)
    for i in {1..3}
    do 
        docker rm -vf host$i  | echo > /dev/null;docker run -v /var/tmp/rancher/host$ienv/:/var/lib/docker --privileged --name=host$i rancher/node-simulator $cattleip:8080
#        docker rm -vf host$i  | echo > /dev/null;docker create -v /var/tmp/rancher/host$ienv/:/var/lib/docker --link=cattle:cattle --privileged --name=host$i hostcontainer
    done
}

cd $(dirname $0)/build-master-scripts/
docker build --rm -t cattleservercontainer .
docker restart cattle || docker run -d --privileged -v /var/tmp/rancher/masterenv/:/var/lib/docker -p 8080:8080 --name=cattle cattleservercontainer
create_hosts
while sleep 10
do
    docker logs -f cattle
done