# #!/bin/bash


# R="\e[31m"
# G="\e[32m"
# Y="\e[33m"
# N="\e[0m


# # Log configuration
# LOG_FOLDER="/var/shellscript-logs"
# SCRIPT_NAME=$(basename "$0" .sh)
# TIMESTAMP=$(date +"%Y-%m-%d-%H-%M-%S")
# LOG_FILE_NAME="$LOG_FOLDER/$SCRIPT_NAME-$TIMESTAMP.log"

# VALIDATE(){
#     if [ $1 -ne 0 ]
#     then
#         echo -e "$2 .....$R FAILURE $N"
#     else
#         echo -e "$2 ..... $G SUCCESS $N"
#     fi
# }

# CHECK_ROOT() {
#     if [ "$(id -u)" -ne 0 ]; 
#     then
#         echo -e "${R}ERROR: You must run this script as root or with sudo${N}"
#         exit 1
#     fi
# }


# mkdir -p "$LOG_FOLDER"

# echo "Script started executing at: $TIMESTAMP" &>>"$LOG_FILE_NAME"


# dnf install mysql-server -y &>>$LOG_FILE_NAME
# VALIDATE $? "Installing My SQL server"

# systemctl enable mysqld &>>$LOG_FILE_NAME
# VALIDATE $? "Enabling the mysqld"

# systemctl start mysqld &>>$LOG_FILE_NAME
# VALIDATE $? "Starting the MySQL"

# mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOG_FILE_NAME
# VALIDATE $? "Setting up root password"


#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

# Log configuration
LOG_FOLDER="/var/shellscript-logs"
SCRIPT_NAME=$(basename "$0" .sh)
TIMESTAMP=$(date +"%Y-%m-%d-%H-%M-%S")
LOG_FILE_NAME="$LOG_FOLDER/$SCRIPT_NAME-$TIMESTAMP.log"

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo -e "$2 ..... ${R}FAILURE${N}"
    else
        echo -e "$2 ..... ${G}SUCCESS${N}"
    fi
}

CHECK_ROOT() {
    if [ "$(id -u)" -ne 0 ]; then
        echo -e "${R}ERROR: You must run this script as root or with sudo${N}"
        exit 1
    fi
}

CHECK_ROOT
mkdir -p "$LOG_FOLDER"

echo "Script started executing at: $TIMESTAMP" &>>"$LOG_FILE_NAME"

dnf install mysql-server -y &>>"$LOG_FILE_NAME"
VALIDATE $? "Installing MySQL server"

systemctl enable mysqld &>>"$LOG_FILE_NAME"
VALIDATE $? "Enabling mysqld"

systemctl start mysqld &>>"$LOG_FILE_NAME"
VALIDATE $? "Starting MySQL"

mysql_secure_installation --set-root-pass ExpenseApp@1 &>>"$LOG_FILE_NAME"
VALIDATE $? "Setting up root password"