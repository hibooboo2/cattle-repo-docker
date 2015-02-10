#!/bin/bash

set -e

wrapdocker

number=0
while [ -z $(curl cattle:8080/v1/hosts) ]
do
    sleep 5
    echo $number
    number=$(($number + 1))
    echo $(curl cattle:8080/v1/hosts)
    docker ps -a
done

echo Now start the agent.
