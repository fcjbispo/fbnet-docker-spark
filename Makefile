TAG:=$(shell git rev-parse --abbrev-ref HEAD)
DOCKER_PROJECT=fbnet-spark
IMAGE_PREFIX=fcjbispo/${DOCKER_PROJECT}

DOCKER_NETWORK = fbnet-hadoop

base: base/Dockerfile
	docker build -t ${IMAGE_PREFIX}-base:$(TAG) ./base

master: master/Dockerfile
	docker build -t ${IMAGE_PREFIX}-master:$(TAG) ./master

worker: worker/Dockerfile
	docker build -t ${IMAGE_PREFIX}-worker:$(TAG) ./worker

historyserver: historyserver/Dockerfile
	docker build -t ${IMAGE_PREFIX}-historyserver:$(TAG) ./historyserver

jupyter: jupyter/Dockerfile
	docker build -t ${IMAGE_PREFIX}-jupyter:$(TAG) ./jupyter

submit: submit/Dockerfile
	docker build -t ${IMAGE_PREFIX}-submit:$(TAG) ./submit

all: base master worker historyserver jupyter submit
	echo "Done: ${DOCKER_PROJECT}"

up:
	docker compose -p ${DOCKER_PROJECT} -f ./docker-compose.yml up --detach

down:
	docker compose -p ${DOCKER_PROJECT} -f ./docker-compose.yml down

restart:
	docker compose -p ${DOCKER_PROJECT} -f ./docker-compose.yml restart