#!/bin/bash

USERID=$(id -u)

if [ "$USERID" -ne 0 ]; then
    echo "Error:: you must have sudo access to execute the script"
    exit 1
fi

echo "Running as root... good"

# Install MySQL repo (EL9 first, fallback to EL8)
dnf install -y https://repo.mysql.com/mysql80-community-release-el9-1.noarch.rpm \
|| dnf install -y https://repo.mysql.com/mysql80-community-release-el8-1.noarch.rpm

# Import correct MySQL GPG key
rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022

# Clean metadata
dnf clean all

# Install MySQL if not already installed
if ! dnf list installed mysql-community-server >/dev/null 2>&1; then
    dnf install -y mysql-community-server
    if [ $? -ne 0 ]; then
        echo "Installing MySQL.... Failure"
        exit 1
    else
        echo "Installing MySQL.....success"
    fi
else
    echo "MySQL is already installed"
fi

# Install Git if not installed
if ! dnf list installed git >/dev/null 2>&1; then
    dnf install -y git
    if [ $? -ne 0 ]; then
        echo "Installing Git.... Failure"
        exit 1
    else
        echo "Installing Git.....success"
    fi
else
    echo "Git is already installed"
fi