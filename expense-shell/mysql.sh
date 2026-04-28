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


# #!/bin/bash

# R="\e[31m"
# G="\e[32m"
# Y="\e[33m"
# N="\e[0m"

# # Log configuration
# LOG_FOLDER="/var/shellscript-logs"
# SCRIPT_NAME=$(basename "$0" .sh)
# TIMESTAMP=$(date +"%Y-%m-%d-%H-%M-%S")
# LOG_FILE_NAME="$LOG_FOLDER/$SCRIPT_NAME-$TIMESTAMP.log"

# VALIDATE(){
#     if [ $1 -ne 0 ]; then
#         echo -e "$2 ..... ${R}FAILURE${N}"
#     else
#         echo -e "$2 ..... ${G}SUCCESS${N}"
#     fi
# }

# CHECK_ROOT() {
#     if [ "$(id -u)" -ne 0 ]; then
#         echo -e "${R}ERROR: You must run this script as root or with sudo${N}"
#         exit 1
#     fi
# }

# CHECK_ROOT
# mkdir -p "$LOG_FOLDER"

# echo "Script started executing at: $TIMESTAMP" &>>"$LOG_FILE_NAME"

# dnf install mysql-server -y &>>"$LOG_FILE_NAME"
# VALIDATE $? "Installing MySQL server"

# systemctl enable mysqld &>>"$LOG_FILE_NAME"
# VALIDATE $? "Enabling mysqld"

# systemctl start mysqld &>>"$LOG_FILE_NAME"
# VALIDATE $? "Starting MySQL"

# mysql_secure_installation --set-root-pass ExpenseApp@1 &>>"$LOG_FILE_NAME"
# VALIDATE $? "Setting up root password"



# Below script is taken from copilot to install mysql 

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
        echo -e "${R}ERROR: You must run this script as root or with sudo${N}"
        exit 1
    fi
}

# ------------------- Execution Starts -------------------
CHECK_ROOT
mkdir -p "$LOG_FOLDER"

echo "Script started executing at: $TIMESTAMP" &>>"$LOG_FILE_NAME"

# ------------------- OS Detection -------------------
OS_NAME=$(grep '^NAME=' /etc/os-release | cut -d= -f2 | tr -d '"')
echo "Detected OS: $OS_NAME" &>>"$LOG_FILE_NAME"

# ------------------- Package Manager -------------------
if command -v dnf &>/dev/null; then
    PKG_MGR="dnf"
else
    PKG_MGR="yum"
fi

# ------------------- Database Installation -------------------
if [[ "$OS_NAME" == *"Amazon Linux"* ]]; then

    $PKG_MGR install mariadb-server -y &>>"$LOG_FILE_NAME"
    VALIDATE $? "Installing MariaDB server"

    systemctl enable mariadb &>>"$LOG_FILE_NAME"
    VALIDATE $? "Enabling MariaDB"

    systemctl start mariadb &>>"$LOG_FILE_NAME"
    VALIDATE $? "Starting MariaDB"

elif [[ "$OS_NAME" == *"Red Hat"* || "$OS_NAME" == *"CentOS"* ]]; then

    $PKG_MGR install mysql-server -y &>>"$LOG_FILE_NAME"
    VALIDATE $? "Installing MySQL server"

    systemctl enable mysqld &>>"$LOG_FILE_NAME"
    VALIDATE $? "Enabling mysqld"

    systemctl start mysqld &>>"$LOG_FILE_NAME"
    VALIDATE $? "Starting MySQL"

else
    echo -e "${R}Unsupported OS: $OS_NAME${N}"
    exit 1
fi

echo -e "${G}Database installation completed successfully${N}"