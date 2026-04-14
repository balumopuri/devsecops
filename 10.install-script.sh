#!/bin/bash

USERID=$(id -u)

if [ $USERID -ne 0 ]
then 
    echo "Error:: you must have sudo access to execute the script"
    exit 1
fi

dnf install mysql -y

if [ $? -ne 0 ]
then 
    echo "Installing MySQL.... Failure"
    exit 1
else
    echo "Installing MySQL.....success"
fi                


















