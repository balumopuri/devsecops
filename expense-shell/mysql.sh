#!/bin/bash

R="[/e31m";
G="[/e32m";
Y="[/e33m";
N="[/e0m";

# Log configuration
LOG_FOLDER="/var/shellscript-logs"
SCRIPT_NAME=$(basename "$0" .sh)
TIMESTAMP=$(date +"%Y-%m-%d-%H-%M-%S")
LOG_FILE_NAME="$LOG_FOLDER/$SCRIPT_NAME-$TIMESTAMP.log"

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 .....$R FAILURE $N"
    else
        echo -e "$2 ..... $G SUCCESS $N"
    fi
}

CHECK_ROOT

mkdir -p "$LOG_FOLDER"

echo "Script started executing at: $TIMESTAMP" &>>"$LOG_FILE_NAME"


dnf install mysql-server -y &>>$LOG_FILE_NAME
VALIDATE $? "Installing My SQL server"

systemctl enable mysqld &>>$LOG_FILE_NAME
VALIDATE $? "Enabling the mysqld"

systemctl start mysqld &>>$LOG_FILE_NAME
VALIDATE $? "Starting the MySQL"

mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOG_FILE_NAME
VALIDATE $? "Setting up root password"