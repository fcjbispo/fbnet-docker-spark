#!/bin/bash

/wait-for-step.sh
/execute-step.sh

if [ ! -z "${JUPYTER_USER}" ]; then
    USER_EXISTS=$(grep "^${JUPYTER_USER}:" /etc/passwd)
    if [ ! -z "${USER_EXISTS}" ]; then
        su - -c "/bin/bash /home/$JUPYTER_USER/jupyterlab.sh $SPARK_MASTER_NAME $SPARK_MASTER_PORT $JUPYTER_USER_PASSWD $HADOOP_NAMENODE_NAME $HADOOP_NAMENODE_PORT" $JUPYTER_USER
    else
        echo "Not found jupyter user."
    fi
else
    echo "Not recognized jupyter user."
fi

/finish-step.sh
