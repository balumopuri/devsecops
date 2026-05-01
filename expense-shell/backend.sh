#!/bin/bash

# ---------------- Colors ----------------
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

# ---------------- Log configuration ----------------
LOG_FOLDER="/var/shellscript-logs"
SCRIPT_NAME=$(basename "$0" .sh)
TIMESTAMP=$(date +"%Y-%m-%d-%H-%M-%S")
LOG_FILE_NAME="$LOG_FOLDER/$SCRIPT_NAME-$TIMESTAMP.log"

# ---------------- Functions ----------------
VALIDATE() {
    if [ $1 -ne 0 ]; then
        echo -e "$2 ..... ${R}FAILURE${N}"
        exit 1
    else
        echo -e "$2 ..... ${G}SUCCESS${N}"
    fi
}

CHECK_ROOT() {
    if [ "$(id -u)" -ne 0 ]; then
        echo -e "${R}ERROR: Please run this script as root or with sudo${N}"
        exit 1
    fi
}

# ---------------- Pre-Checks ----------------
CHECK_ROOT
mkdir -p "$LOG_FOLDER"

echo "Script started at: $TIMESTAMP" &>>"$LOG_FILE_NAME"

dnf module disable nodejs -y &>>"$LOG_FILE_NAME"
VALIDATE $? "Disabling NodeJS module"

dnf install nodejs -y &>>"$LOG_FILE_NAME"
VALIDATE $? "Installing NodeJS"

dnf enable nodejs:20 -y &>>"$LOG_FILE_NAME"
VALIDATE $? "Enabling NodeJS 20"

useradd expense
VALIDATE $? "Creating user 'expense'"

mkdir /app
VALIDATE $? "Creating /app directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip
VALIDATE $? "Downloading backend code"

cd /app
unzip /tmp/backend.zip &>>"$LOG_FILE_NAME"
VALIDATE $? "Extracting backend code"

cd /app
npm install &>>"$LOG_FILE_NAME"
VALIDATE $? "Installing backend dependencies"

cp /path/to/backend.service /etc/systemd/system/backend.service
VALIDATE $? "Copying backend service file"

dnf install mysql-server -y &>>"$LOG_FILE_NAME"
VALIDATE $? "Installing MySQL server"

mysql -h mysql.balaportfolio.space -uroot -pExpenseApp@1 < /app/schema/backend.sql
VALIDATE $? "Initializing backend database"

systemctl daemon-reload
VALIDATE $? "Reloading systemd daemon"

systemctl enable backend &>>"$LOG_FILE_NAME"
VALIDATE $? "Enabling backend service"

systemctl restart backend &>>"$LOG_FILE_NAME"
VALIDATE $? "Restarting backend service"