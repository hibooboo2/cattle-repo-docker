#!/bin/bash

wrapdocker

number=0
while [ -z $(curl cattle:8080/v1/hosts) ]
do
    sleep 5
    echo Connection attempts $number
    number=$(($number + 1))
done

echo Now start the agent.

docker run -d --privileged -v /var/lib/docker:/var/lib/docker -v /var/run/docker.sock:/var/run/docker.sock rancher/agent http://cattle:8080/v1/scripts/A5D504A17F9646C27F73:1423544400000:Vcq98xfUKoXvVTSWKg3BuWh4XFc
while sleep 10
do
    echo skhfkjhf
done