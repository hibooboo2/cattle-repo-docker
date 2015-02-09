#!/bin/bash

set -e

number=0
while sleep 5
do
    echo $number
    number=$(($number + 1))
    echo $(curl 172.17.0.20:8080/v1/hosts)
done
