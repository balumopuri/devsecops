#!/bin/bash

USERID=$(id -u)

R="/e[31m"
G="/e[32m"
Y="/e[33m"
N="/e[0m"

LOG_FOLDER="/var/shellscript-logs"
SCRIPT_NAME=$(basename "$0" .sh)
TIMESTAMP=$(date +"%Y-%m-%d-%H-%M-%S")
LOG_FILE_NAME="$LOG_FOLDER/$SCRIPT_NAME-$TIMESTAMP.log"

VALIDATE(){
    if [ $1 -ne 0 ]
    then 
        echo -e "${R} FAILED...${N}" >> "$LOG_FILE_NAME"
        exit 1
    else   
        echo -e "$2 .... ${G}SUCCESS${N}" >> "$LOG_FILE_NAME"
    fi
}

if [ $USERID -ne 0 ]
then
    echo -e "${R}Error:: You must have sudo/root access to execute this script${N}"
    exit 1
fi

for package in $@
do
    dnf list installed $package &>>"$LOG_FILE_NAME"
    if [ $? -ne 0 ]
    then   
        dnf install $package -y &>>"$LOG_FILE_NAME"
        VALIDATE $? "iNSTALLING $package"
    else 
        echo -e "$package is alreay $Y.....Installed $N"
    fi
done