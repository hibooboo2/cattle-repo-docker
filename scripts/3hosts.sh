#!/bin/bash

set -e

docker build -t test .
docker rm  -fv $(docker ps -qa)
docker run -d --privileged --name=cattle test
docker run -d --privileged --name=host1 test
docker run -d --privileged --name=host2 test
docker run -d --privileged --name=host3 test
