#!/bin/bash

export SPARK_USER=$1

/wait-for-step.sh
/execute-step.sh

if [ ! -z "${SPARK_USER}" ]; then
    USER_EXISTS=$(grep "^${SPARK_USER}:" /etc/passwd)
    if [ ! -z "${USER_EXISTS}" ]; then
        su - -c "/bin/bash /home/$SPARK_USER/jupyterlab.sh $SPARK_MASTER_NAME $SPARK_MASTER_PORT" $SPARK_USER
    else
        echo "Not found spark user."
    fi
else
    echo "Not recognized spark user."
fi

/finish-step.sh
