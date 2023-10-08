#!/bin/bash

SPARK_MASTER_NAME=$1
SPARK_MASTER_PORT=$2
USER_PASSWD=$3
HADOOP_NAMENODE_NAME=$4
HADOOP_NAMENODE_PORT=$5

export SPARK_MASTER_URL=spark://${SPARK_MASTER_NAME}:${SPARK_MASTER_PORT}
export SPARK_HOME=/spark
export HADOOP_CLUSTER_URL=hdfs://${HADOOP_NAMENODE_NAME}:${HADOOP_NAMENODE_PORT}

source $HOME/.bashrc

jupyter-lab --no-browser --notebook-dir=/var/jupyter --Notebook.App.token='' --ip='*' --NotebookApp.token='' --NotebookApp.password=''