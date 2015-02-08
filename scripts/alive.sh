#!/bin/bash

set -e

number=1
while [ $number -gt 0 ]
do
    echo $number
    number=$(($number + 1))
done
