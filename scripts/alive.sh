#!/bin/bash

set -e

number=0
while sleep 5
do
    echo $number
    number=$(($number + 1))
done
