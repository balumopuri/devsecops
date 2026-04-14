#!/bin/bash

USERID=$(id -u)

if [ USERID -ne 0 ]
then 
    echo "Error:: you must have sudo access to execute the script"
    exit 1
fi

dnf install mysql -y

if [ $? -ne 0 ]
then 
    echo "Installing Msql.... Failure"
    exit 1
else
    echo "Installing Msql.....success"
fi               


















