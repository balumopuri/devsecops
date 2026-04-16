#!/bin/bash

TIMESTAMP=$(date +"%Y-%m-%d-%H-%M-%S")

echo "Today Date is: $TIMESTAMP"

echo "$(pwd)"

# echo "$( ls -a )"

echo "$( who )"

echo "$( uptime )"

echo "( df -h )"