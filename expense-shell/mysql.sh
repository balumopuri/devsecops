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
else
    echo "MySQL Root password is already set. Skipping mysql_secure_installation." &>>"$LOG_FILE_NAME"
    exit 0
fi



# Below script is taken from copilot to install mysql 

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

# ---------------- OS Detection ----------------
OS_NAME=$(grep '^NAME=' /etc/os-release | cut -d= -f2 | tr -d '"')
echo "Detected OS: $OS_NAME" &>>"$LOG_FILE_NAME"

# ---------------- Package Manager Detection ----------------
if command -v dnf &>/dev/null; then
    PKG_MGR="dnf"
else
    PKG_MGR="yum"
fi

echo "Using package manager: $PKG_MGR" &>>"$LOG_FILE_NAME"

# ---------------- Database Installation ----------------
if [[ "$OS_NAME" == *"Amazon Linux"* ]]; then
    echo "Installing MariaDB on Amazon Linux" &>>"$LOG_FILE_NAME"

    $PKG_MGR clean all &>>"$LOG_FILE_NAME"
    $PKG_MGR makecache &>>"$LOG_FILE_NAME"

    $PKG_MGR install mariadb105-server -y &>>"$LOG_FILE_NAME"
    VALIDATE $? "Installing MariaDB server"

    systemctl enable mariadb &>>"$LOG_FILE_NAME"
    VALIDATE $? "Enabling MariaDB service"

    systemctl start mariadb &>>"$LOG_FILE_NAME"
    VALIDATE $? "Starting MariaDB service"

    mysql_secure_installation --set-root-pass=ExpenseApp@1 &>>"$LOG_FILE_NAME"
    VALIDATE $? "Setting up root password"

elif [[ "$OS_NAME" == *"Red Hat"* || "$OS_NAME" == *"CentOS"* ]]; then
    echo "Installing MySQL on RHEL/CentOS" &>>"$LOG_FILE_NAME"

    $PKG_MGR install mysql-server -y &>>"$LOG_FILE_NAME"
    VALIDATE $? "Installing MySQL server"

    systemctl enable mysqld &>>"$LOG_FILE_NAME"
    VALIDATE $? "Enabling mysqld service"

    systemctl start mysqld &>>"$LOG_FILE_NAME"
    VALIDATE $? "Starting MySQL service"

else
    echo -e "${R}Unsupported OS detected: $OS_NAME${N}" | tee -a "$LOG_FILE_NAME"
    exit 1
fi

echo -e "${G}Database installation completed successfully${N}"
echo "Script completed at: $(date)" &>>"$LOG_FILE_NAME"