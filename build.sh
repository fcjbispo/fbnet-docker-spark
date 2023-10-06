#!/bin/bash

set -e

TAG=$(git rev-parse --abbrev-ref HEAD)

build() {
    NAME=$1
    IMAGE=fcjbispo/fbnet-spark-$NAME:$TAG
    cd $([ -z "$2" ] && echo "./$NAME" || echo "$2")
    echo '--------------------------' building $IMAGE in $(pwd)
    docker build -t $IMAGE .
    cd -
}

if [ $# -eq 0 ]
  then
    build base
    build master
    build worker
    build historyserver
    build submit
    build jupyter
#    build maven-template template/maven
#    build sbt-template template/sbt
#    build python-template template/python    
#    build python-example examples/python
  else
    build $1 $2
fi
