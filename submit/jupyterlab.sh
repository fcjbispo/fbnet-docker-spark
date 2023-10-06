#!/bin/bash

SPARK_MASTER_NAME=$1
SPARK_MASTER_PORT=$2

export SPARK_MASTER_URL=spark://${SPARK_MASTER_NAME}:${SPARK_MASTER_PORT}
export SPARK_HOME=/spark

source $HOME/.local/bin/activate

jupyter-lab --no-browser --notebook-dir=/var/jupyter --Notebook.App.token='' --ip='*' --NotebookApp.token='' --NotebookApp.password=''