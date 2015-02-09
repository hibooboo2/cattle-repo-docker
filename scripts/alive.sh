#!/bin/bash

set -e

wrapdocker

number=0
while sleep 5
do
    echo $number
    number=$(($number + 1))
    echo $(curl cattle:8080/v1/hosts)
    docker ps -a
done
