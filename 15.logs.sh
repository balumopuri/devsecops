#!/bin/bash

USERID=$(id -u)

R="/e[31m"
G="/e[32m"
Y="/e[33m"
N="/e[0m"

LOG_FOLDER="/var/shellscript-logs"
LOG_FILE=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date-%Y-%m-%d-%H-%S)
LOG_FILE_NAME="$LOG_FOLDER/$LOG_FILE-$TIMESTAMP.log"

VALIDATE(){
    if [ $1 -ne 0 ]
        then 
            echo -e "$2.... $R Failure $N" &>>$LOG_FILE_NAME
            exit 1
        else
            echo -e "$2.....$G success $N" &>>$LOG_FILE_NAME
        fi
}
echo "Script started executed at:$TIMESTAMP" &>>$LOG_FILE_NAME

if [ $USERID -ne 0 ]
then 
    echo -e $R "Error:: you must have sudo access to execute the script"
    exit 1
fi

    dnf list installed git &>>$LOG_FILE_NAME
        if [ $? -ne 0 ]
        then 
            dnf install git -y &>>$LOG_FILE_NAME
         VALIDATE $2 "Installing GIT"
    else                 
        echo -e $G "Git is already installed $N"
    fi